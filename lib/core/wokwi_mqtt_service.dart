import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'mock_db.dart';
import 'mqtt_connector_io.dart' if (dart.library.js_interop) 'mqtt_connector_web.dart';

class WokwiEquipmentTag {
  final String id;
  final String tipo; // 'CR' ou 'CS'
  final String zona;
  final int rssi;
  final String status; // 'em_uso', 'observando', 'possivel_abandono', 'sinal_fraco', 'sem_sinal'

  const WokwiEquipmentTag({
    required this.id,
    required this.tipo,
    required this.zona,
    required this.rssi,
    required this.status,
  });

  String get formattedStatus {
    switch (status) {
      case 'possivel_abandono':
        return 'Possível Abandono';
      case 'observando':
        return 'Parado (Observando)';
      case 'em_uso':
        return 'Em Uso';
      case 'sinal_fraco':
        return 'Sinal Fraco';
      case 'sem_sinal':
        return 'Sem Sinal';
      default:
        return status;
    }
  }
}

class WokwiMqttService {
  static const String broker = 'broker.hivemq.com';
  static const String baseTopic = 'synercart/vitor/demo-71507/filial01/gateway01';
  static const String topicoComando = '$baseTopic/comando';
  static const String topicoEstacao = '$baseTopic/estacao';
  static const String topicoEquipamentos = '$baseTopic/equipamentos';
  static const String topicoAck = '$baseTopic/ack';

  static SynerMqttTransport? _transport;
  static bool _isConnecting = false;
  static Timer? _reconnectTimer;

  // Estado da conexão MQTT
  static bool isConnected = false;
  static String connectionStatusText = 'Desconectado';

  // Última telemetria recebida de /estacao (Wokwi HC-SR04 ou MQTT Simulado)
  static bool hasReceivedStationTelemetry = false;
  static String estacaoId = 'EST01';
  static int capacidade = 20;
  static int? quantidade;
  static int? ocupacaoPercentual;
  static double? distanciaCm;
  static bool leituraValida = false;
  static String origem = 'hc_sr04'; // 'hc_sr04' ou 'mqtt_simulado'
  static String statusRaw = 'normal'; // 'critico', 'atencao', 'normal', 'erro_sensor'
  static int uptimeMs = 0;
  static DateTime? lastTelemetryTime;

  // Tags BLE simuladas via /equipamentos no Wokwi
  static List<WokwiEquipmentTag> equipmentTags = [];

  // Última resposta de confirmação (/ack) do ESP32
  static String? lastAckMessage;
  static bool? lastAckOk;

  // Estados dos 3 LEDs físicos do Wokwi (pinos 25, 26, 27)
  static bool get ledVerdeOn => leituraValida && (quantidade ?? 0) >= 10;
  static bool get ledAmareloOn =>
      leituraValida && (quantidade ?? 0) > 4 && (quantidade ?? 0) < 10;
  static bool get ledVermelhoOn => leituraValida && (quantidade ?? 0) <= 4;

  static Future<void> ensureConnected() async {
    if (isConnected || _isConnecting) return;
    await connect();
  }

  static Future<void> connect() async {
    if (_isConnecting) return;
    _isConnecting = true;
    connectionStatusText = 'Conectando ao Broker...';
    MockDB.stateNotifier.value++;

    try {
      _transport?.disconnect();

      final randomSuffix = Random().nextInt(900000) + 100000;
      final clientId = 'synercart-app-$randomSuffix';

      final transport = createSynerMqttTransport();
      _transport = transport;

      transport.onConnected = () {
        isConnected = true;
        connectionStatusText = 'MQTT Conectado (HiveMQ)';
        MockDB.stateNotifier.value++;
      };

      transport.onDisconnected = () {
        isConnected = false;
        connectionStatusText = 'Reconectando MQTT...';
        MockDB.stateNotifier.value++;
        _scheduleReconnect();
      };

      transport.onMessage = _handleMessage;

      final ok = await transport.connect(clientId);

      if (ok) {
        isConnected = true;
        connectionStatusText = 'MQTT Conectado (HiveMQ)';
        _subscribeTopics();
        sendCommand({'acao': 'consultar'});
      } else {
        isConnected = false;
        connectionStatusText = 'Reconectando ao Broker...';
        _scheduleReconnect();
      }
    } catch (e) {
      isConnected = false;
      connectionStatusText = 'Reconectando ao Broker...';
      if (kDebugMode) {
        print('Erro MQTT: $e');
      }
      _scheduleReconnect();
    } finally {
      _isConnecting = false;
      MockDB.stateNotifier.value++;
    }
  }

  static void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (!isConnected && !_isConnecting) {
        connect();
      }
    });
  }

  static void _subscribeTopics() {
    final transport = _transport;
    if (transport == null || !isConnected) return;

    transport.subscribe(topicoEstacao);
    transport.subscribe(topicoEquipamentos);
    transport.subscribe(topicoAck);
  }

  static void _handleMessage(String topic, String payloadString) {
    try {
      final decoded = jsonDecode(payloadString);
      if (decoded is! Map<String, dynamic>) return;

      if (topic == topicoEstacao) {
        _processStationPayload(decoded);
      } else if (topic == topicoEquipamentos) {
        _processEquipmentPayload(decoded);
      } else if (topic == topicoAck) {
        lastAckOk = decoded['ok'] as bool?;
        lastAckMessage = decoded['detalhe']?.toString();
        MockDB.stateNotifier.value++;
      }
    } catch (_) {}
  }

  static void _processStationPayload(Map<String, dynamic> data) {
    hasReceivedStationTelemetry = true;
    lastTelemetryTime = DateTime.now();

    estacaoId = data['estacao_id']?.toString() ?? 'EST01';
    capacidade = (data['capacidade'] as num?)?.toInt() ?? 20;
    leituraValida = (data['leitura_valida'] as bool?) ?? false;
    origem = data['origem']?.toString() ?? 'hc_sr04';
    statusRaw = data['status']?.toString() ?? 'normal';
    uptimeMs = (data['uptime_ms'] as num?)?.toInt() ?? 0;

    final rawQtd = data['quantidade'];
    quantidade = rawQtd is num ? rawQtd.toInt() : null;

    final rawPct = data['ocupacao_percentual'];
    ocupacaoPercentual = rawPct is num ? rawPct.toInt() : null;

    final rawDist = data['distancia_cm'];
    distanciaCm = rawDist is num ? rawDist.toDouble() : null;

    // Sincroniza em tempo real com a Estação 1 - Entrada (EST01) no MockDB
    if (MockDB.stations.isNotEmpty) {
      final station = MockDB.stations[0];
      if (leituraValida && ocupacaoPercentual != null && quantidade != null) {
        station['percentage'] = ocupacaoPercentual!.clamp(0, 100);
        station['carrinhosTotal'] = capacidade;
        station['carrinhosActive'] = quantidade!.clamp(0, capacidade);

        String mappedStatus = 'stable';
        if (statusRaw == 'critico') {
          mappedStatus = 'critical';
        } else if (statusRaw == 'atencao') {
          mappedStatus = 'alert';
        }
        station['status'] = mappedStatus;

        final origemLabel = origem == 'hc_sr04'
            ? 'Sensor HC-SR04 (${distanciaCm?.toStringAsFixed(0) ?? "--"} cm)'
            : 'MQTT Simulado';
        station['sector'] = 'Acesso ao Supermercado • $quantidade/$capacidade carrinhos ($origemLabel)';

        // Atualiza a tarefa da Estação 1 - Entrada conforme leitura do sensor
        final taskIdx = MockDB.tasks.indexWhere((t) => t.id == 'task_1');
        if (taskIdx != -1) {
          final task = MockDB.tasks[taskIdx];
          if (statusRaw == 'critico') {
            final faltam = (capacidade - quantidade!).clamp(1, capacidade);
            task.status = 'critical';
            task.timeText = 'Sensor agora';
            task.subtitle = 'Carrinhos: $quantidade/$capacidade disponíveis';
            task.quantityText = 'Quantidade Necessária: $faltam Carrinhos';
            task.profileDescription =
                'Retirar $faltam carrinhos da Estação 2 - Saída para suprir a Estação 1 - Entrada ($quantidade/$capacidade no sensor).';
          } else if (statusRaw == 'atencao' && !task.isResolved) {
            task.status = 'warning';
            task.subtitle = 'Carrinhos: $quantidade/$capacidade disponíveis';
          }
        }
      }
    }

    MockDB.stateNotifier.value++;
  }

  static void _processEquipmentPayload(Map<String, dynamic> data) {
    final itens = data['itens'];
    if (itens is List) {
      final parsed = <WokwiEquipmentTag>[];
      for (final raw in itens) {
        if (raw is Map<String, dynamic>) {
          parsed.add(
            WokwiEquipmentTag(
              id: raw['id']?.toString() ?? '',
              tipo: raw['tipo']?.toString() ?? 'CR',
              zona: raw['zona']?.toString() ?? 'Loja',
              rssi: (raw['rssi'] as num?)?.toInt() ?? -100,
              status: raw['status']?.toString() ?? 'observando',
            ),
          );
        }
      }
      equipmentTags = parsed;
      MockDB.stateNotifier.value++;
    }
  }

  static void sendCommand(Map<String, dynamic> payload) {
    final transport = _transport;
    if (transport == null || !isConnected) {
      lastAckOk = false;
      lastAckMessage = 'Conecte-se ao Broker MQTT primeiro';
      MockDB.stateNotifier.value++;
      return;
    }

    final mapWithId = Map<String, dynamic>.from(payload);
    mapWithId['request_id'] ??= 'req_${DateTime.now().millisecondsSinceEpoch}';

    transport.publish(topicoComando, jsonEncode(mapWithId));
  }
}
