import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient createMqttClient(String clientId) {
  final client = MqttServerClient.withPort('broker.hivemq.com', clientId, 1883);
  client.keepAlivePeriod = 20;
  client.autoReconnect = true;
  client.logging(on: false);
  return client;
}
