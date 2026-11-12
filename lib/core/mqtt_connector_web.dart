import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

MqttClient createMqttClient(String clientId) {
  final client = MqttBrowserClient.withPort('ws://broker.hivemq.com/mqtt', clientId, 8000);
  client.keepAlivePeriod = 20;
  client.autoReconnect = true;
  client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
  client.logging(on: false);
  return client;
}
