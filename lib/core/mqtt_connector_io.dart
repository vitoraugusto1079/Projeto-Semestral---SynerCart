import 'dart:async';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

abstract class SynerMqttTransport {
  void Function()? onConnected;
  void Function()? onDisconnected;
  void Function(String topic, String payload)? onMessage;

  Future<bool> connect(String clientId);
  void subscribe(String topic);
  void publish(String topic, String payload);
  void disconnect();
}

SynerMqttTransport createSynerMqttTransport() => _IoMqttTransport();

class _IoMqttTransport extends SynerMqttTransport {
  MqttServerClient? _client;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _sub;

  @override
  Future<bool> connect(String clientId) async {
    disconnect();
    final client = MqttServerClient.withPort('broker.hivemq.com', clientId, 1883);
    client.keepAlivePeriod = 25;
    client.connectTimeoutPeriod = 10000;
    client.autoReconnect = true;
    client.logging(on: false);
    _client = client;

    client.onConnected = () => onConnected?.call();
    client.onDisconnected = () => onDisconnected?.call();

    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMess;

    try {
      await client.connect();
      if (client.connectionStatus?.state == MqttConnectionState.connected) {
        _sub = client.updates?.listen((messages) {
          for (final msg in messages) {
            final recMess = msg.payload as MqttPublishMessage;
            final payload = utf8.decode(recMess.payload.message, allowMalformed: true);
            onMessage?.call(msg.topic, payload);
          }
        });
        return true;
      }
    } catch (_) {}
    return false;
  }

  @override
  void subscribe(String topic) {
    final client = _client;
    if (client?.connectionStatus?.state == MqttConnectionState.connected) {
      client!.subscribe(topic, MqttQos.atMostOnce);
    }
  }

  @override
  void publish(String topic, String payload) {
    final client = _client;
    if (client?.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addUTF8String(payload);
      client!.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
    }
  }

  @override
  void disconnect() {
    _sub?.cancel();
    _sub = null;
    try {
      _client?.disconnect();
    } catch (_) {}
    _client = null;
  }
}
