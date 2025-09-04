import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Betsy MQTT',
      theme: ThemeData.dark(),
      home: const MqttHomePage(),
    );
  }
}

class MqttHomePage extends StatefulWidget {
  const MqttHomePage({super.key});
  @override
  State<MqttHomePage> createState() => _MqttHomePageState();
}

class _MqttHomePageState extends State<MqttHomePage> {
  late MqttServerClient _client;
  final _messages = <String>[];
  bool _connected = false;

  final broker = 'test.mosquitto.org'; // Trocar para o provedor original
  final port = 1883;
  final topic = 'demo/hello';

  @override
  void initState() {
    super.initState();
    _initMqtt();
  }

  Future<void> _initMqtt() async {
    final clientId = 'flutter_${DateTime.now().millisecondsSinceEpoch}';
    _client = MqttServerClient(broker, clientId);
    _client.port = port;
    _client.keepAlivePeriod = 20;
    _client.logging(on: false);
    _client.autoReconnect = true;
    _client.resubscribeOnAutoReconnect = true;

    _client.onConnected = () {
      setState(() => _connected = true);
      _log('Conectado.');
    };
    _client.onDisconnected = () {
      setState(() => _connected = false);
      _log('Desconectado.');
    };
    _client.onSubscribed = (t) => _log('Assinado: $t');
    _client.onAutoReconnect = () => _log('Tentando reconectar...');
    _client.onAutoReconnected = () => _log('Reconectado!');

    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .keepAliveFor(20)
        .withWillTopic('clients/$clientId/status')
        .withWillMessage('offline')
        .withWillQos(MqttQos.atLeastOnce)
        .withWillRetain();
    _client.connectionMessage = connMess;

    _client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>> events) {
      final rec = events.first;
      final MqttPublishMessage msg = rec.payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(msg.payload.message);
      _log('[${
        rec.topic
      }] $payload');
    });

    Connectivity().onConnectivityChanged.listen((status) {
      if (status == ConnectivityResult.none) {
        _log('Sem rede.');
      } else {
        if (!_connected) {
          _connect();
        }
      }
    });

    await _connect();
  }

  Future<void> _connect() async {
    try {
      await _client.connect();
      if (_client.connectionStatus?.state == MqttConnectionState.connected) {
        _client.subscribe(topic, MqttQos.atLeastOnce);
        publish('Betsy!');
      } else {
        _log('Falha na conexão: ${_client.connectionStatus}');
        _client.disconnect();
      }
    } catch (e) {
      _log('Erro ao conectar: $e');
      _client.disconnect();
    }
  }

  void publish(String text) {
    final builder = MqttClientPayloadBuilder()..addString(text);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    _log('[PUB] $text');
  }

  void _log(String m) => setState(() => _messages.insert(0, m));

  @override
  void dispose() {
    _client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Betsy MQTT'),
        actions: [
          Icon(
            _connected ? Icons.cloud_done : Icons.cloud_off,
            color: _connected ? Colors.greenAccent : Colors.redAccent,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Mensagem pra publicar',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _connected
                      ? () {
                          final text = controller.text.trim();
                          if (text.isNotEmpty) publish(text);
                          controller.clear();
                        }
                      : null,
                  child: const Text('Enviar'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              reverse: true,
              itemCount: _messages.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) => ListTile(
                dense: true,
                title: Text(_messages[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
