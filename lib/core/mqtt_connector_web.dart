import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

abstract class SynerMqttTransport {
  void Function()? onConnected;
  void Function()? onDisconnected;
  void Function(String topic, String payload)? onMessage;

  Future<bool> connect(String clientId);
  void subscribe(String topic);
  void publish(String topic, String payload);
  void disconnect();
}

SynerMqttTransport createSynerMqttTransport() => _WebMqttTransport();

class _WebMqttTransport extends SynerMqttTransport {
  web.WebSocket? _ws;
  Timer? _pingTimer;
  final BytesBuilder _rxBuffer = BytesBuilder(copy: false);
  int _nextPacketId = 1;
  bool _connected = false;

  @override
  Future<bool> connect(String clientId) async {
    disconnect();
    // Tenta primeiro WSS (porta 8884 - TLS) e, se falhar, WS (porta 8000)
    final okWss = await _tryConnectUrl(
      'wss://broker.hivemq.com:8884/mqtt',
      clientId,
    );
    if (okWss) return true;

    return _tryConnectUrl(
      'ws://broker.hivemq.com:8000/mqtt',
      clientId,
    );
  }

  Future<bool> _tryConnectUrl(String url, String clientId) async {
    final completer = Completer<bool>();

    try {
      final protocols = <JSString>['mqtt'.toJS].toJS;
      final ws = web.WebSocket(url, protocols);
      ws.binaryType = 'arraybuffer';
      _ws = ws;

      final timeoutTimer = Timer(const Duration(seconds: 10), () {
        if (!completer.isCompleted) {
          completer.complete(false);
          try {
            ws.close();
          } catch (_) {}
        }
      });

      ws.onopen = ((web.Event _) {
        // Envia pacote MQTT 3.1.1 CONNECT binário puro (Uint8List.toJS)
        final connectPacket = _buildConnectPacket(clientId);
        ws.send(connectPacket.toJS);
      }).toJS;

      ws.onmessage = ((web.MessageEvent event) {
        final data = event.data;
        if (data == null) return;
        final buffer = data as JSArrayBuffer;
        final bytes = buffer.toDart.asUint8List();
        _onBytesReceived(bytes, completer, timeoutTimer);
      }).toJS;

      ws.onerror = ((web.Event _) {
        timeoutTimer.cancel();
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      }).toJS;

      ws.onclose = ((web.CloseEvent _) {
        timeoutTimer.cancel();
        _pingTimer?.cancel();
        final wasConnected = _connected;
        _connected = false;
        if (!completer.isCompleted) {
          completer.complete(false);
        } else if (wasConnected) {
          onDisconnected?.call();
        }
      }).toJS;
    } catch (_) {
      if (!completer.isCompleted) completer.complete(false);
    }

    return completer.future;
  }

  void _onBytesReceived(
    Uint8List chunk,
    Completer<bool> connectCompleter,
    Timer timeoutTimer,
  ) {
    final existing = _rxBuffer.takeBytes();
    final combined = Uint8List(existing.length + chunk.length);
    combined.setRange(0, existing.length, existing);
    combined.setRange(existing.length, combined.length, chunk);

    int offset = 0;
    while (offset < combined.length) {
      if (offset + 2 > combined.length) break;

      final headerByte = combined[offset];
      final packetType = (headerByte & 0xF0) >> 4;

      // Decodifica Remaining Length (varint MQTT)
      int multiplier = 1;
      int remainingLength = 0;
      int lenPos = offset + 1;
      bool validLen = false;

      while (lenPos < combined.length) {
        final encodedByte = combined[lenPos];
        remainingLength += (encodedByte & 127) * multiplier;
        lenPos++;
        if ((encodedByte & 128) == 0) {
          validLen = true;
          break;
        }
        multiplier *= 128;
        if (multiplier > 128 * 128 * 128) break;
      }

      if (!validLen) break; // Aguarda mais bytes

      final packetEnd = lenPos + remainingLength;
      if (packetEnd > combined.length) break; // Pacote incompleto

      final body = Uint8List.sublistView(combined, lenPos, packetEnd);
      offset = packetEnd;

      if (packetType == 2) {
        // CONNACK (0x20)
        timeoutTimer.cancel();
        final returnCode = body.length >= 2 ? body[1] : 1;
        if (returnCode == 0) {
          _connected = true;
          _startPingTimer();
          if (!connectCompleter.isCompleted) {
            connectCompleter.complete(true);
          }
          onConnected?.call();
        } else {
          if (!connectCompleter.isCompleted) {
            connectCompleter.complete(false);
          }
        }
      } else if (packetType == 3) {
        // PUBLISH (0x30..0x3F)
        final qos = (headerByte & 0x06) >> 1;
        if (body.length >= 2) {
          final topicLen = (body[0] << 8) | body[1];
          int payloadStart = 2 + topicLen;
          if (qos > 0) payloadStart += 2; // pula Packet Identifier
          if (body.length >= payloadStart) {
            final topic = utf8.decode(body.sublist(2, 2 + topicLen), allowMalformed: true);
            final payload = utf8.decode(body.sublist(payloadStart), allowMalformed: true);
            onMessage?.call(topic, payload);
          }
        }
      }
    }

    if (offset < combined.length) {
      _rxBuffer.add(Uint8List.sublistView(combined, offset));
    }
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 25), (_) {
      if (_connected && _ws != null && _ws!.readyState == web.WebSocket.OPEN) {
        final pingPacket = Uint8List.fromList([0xC0, 0x00]);
        _ws!.send(pingPacket.toJS);
      }
    });
  }

  @override
  void subscribe(String topic) {
    if (!_connected || _ws == null || _ws!.readyState != web.WebSocket.OPEN) return;
    final topicBytes = utf8.encode(topic);
    final packetId = _nextPacketId++;
    if (_nextPacketId > 60000) _nextPacketId = 1;

    final body = BytesBuilder();
    body.addByte((packetId >> 8) & 0xFF);
    body.addByte(packetId & 0xFF);
    body.addByte((topicBytes.length >> 8) & 0xFF);
    body.addByte(topicBytes.length & 0xFF);
    body.add(topicBytes);
    body.addByte(0x00); // QoS 0

    final packet = _wrapFixedHeader(0x82, body.toBytes());
    _ws!.send(packet.toJS);
  }

  @override
  void publish(String topic, String payload) {
    if (!_connected || _ws == null || _ws!.readyState != web.WebSocket.OPEN) return;
    final topicBytes = utf8.encode(topic);
    final payloadBytes = utf8.encode(payload);

    final body = BytesBuilder();
    body.addByte((topicBytes.length >> 8) & 0xFF);
    body.addByte(topicBytes.length & 0xFF);
    body.add(topicBytes);
    body.add(payloadBytes);

    final packet = _wrapFixedHeader(0x30, body.toBytes());
    _ws!.send(packet.toJS);
  }

  @override
  void disconnect() {
    _pingTimer?.cancel();
    _connected = false;
    _rxBuffer.clear();
    try {
      _ws?.close();
    } catch (_) {}
    _ws = null;
  }

  Uint8List _buildConnectPacket(String clientId) {
    final idBytes = utf8.encode(clientId);
    final body = BytesBuilder();
    // Protocol Name: "MQTT"
    body.add([0x00, 0x04, 0x4D, 0x51, 0x54, 0x54]);
    // Protocol Level: 4 (MQTT 3.1.1)
    body.addByte(0x04);
    // Connect Flags: 0x02 (Clean Session)
    body.addByte(0x02);
    // Keep Alive: 60 seconds
    body.add([0x00, 0x3C]);
    // Client Identifier
    body.addByte((idBytes.length >> 8) & 0xFF);
    body.addByte(idBytes.length & 0xFF);
    body.add(idBytes);

    return _wrapFixedHeader(0x10, body.toBytes());
  }

  Uint8List _wrapFixedHeader(int firstByte, Uint8List bodyBytes) {
    final out = BytesBuilder();
    out.addByte(firstByte);

    int x = bodyBytes.length;
    do {
      int encodedByte = x % 128;
      x = x ~/ 128;
      if (x > 0) {
        encodedByte = encodedByte | 128;
      }
      out.addByte(encodedByte);
    } while (x > 0);

    out.add(bodyBytes);
    return out.toBytes();
  }
}
