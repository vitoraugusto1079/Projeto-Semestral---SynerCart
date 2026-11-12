import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/mock_db.dart';
import '../core/wokwi_mqtt_service.dart';

class WokwiIotBanner extends StatefulWidget {
  const WokwiIotBanner({super.key});

  @override
  State<WokwiIotBanner> createState() => _WokwiIotBannerState();
}

class _WokwiIotBannerState extends State<WokwiIotBanner> {
  @override
  void initState() {
    super.initState();
    WokwiMqttService.ensureConnected();
  }

  Color _getStatusColor() {
    if (!WokwiMqttService.hasReceivedStationTelemetry) {
      return WokwiMqttService.isConnected ? AppTheme.primary : AppTheme.textSecondary;
    }
    switch (WokwiMqttService.statusRaw) {
      case 'critico':
        return AppTheme.error;
      case 'atencao':
        return AppTheme.warning;
      case 'normal':
        return AppTheme.success;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _getStationLevelLabel() {
    if (!WokwiMqttService.hasReceivedStationTelemetry) {
      return WokwiMqttService.isConnected
          ? 'Aguardando publicação do Wokwi...'
          : 'Clique para conectar ao Wokwi / HiveMQ';
    }
    if (!WokwiMqttService.leituraValida) {
      return 'Erro de leitura no sensor ultrassônico';
    }
    final qtd = WokwiMqttService.quantidade ?? 0;
    final cap = WokwiMqttService.capacidade;
    if (qtd <= 4) {
      return 'Quase Vazia ($qtd/$cap un.) • Reposição Urgente';
    } else if (qtd < 10) {
      return 'Nível Intermediário ($qtd/$cap un.) • Atenção';
    } else {
      return 'Estação Abastecida ($qtd/$cap un.) • Normal';
    }
  }

  void _openIotControlModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => const _WokwiControlModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: MockDB.stateNotifier,
      builder: (context, _, _) {
        final statusColor = _getStatusColor();
        final hasTelemetry = WokwiMqttService.hasReceivedStationTelemetry;
        final dist = WokwiMqttService.distanciaCm;
        final isSensor = WokwiMqttService.origem == 'hc_sr04';

        return GestureDetector(
          onTap: () => _openIotControlModal(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: statusColor.withValues(alpha: 0.35),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.sensors_rounded, size: 16, color: statusColor),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gateway IoT Wokwi • EST01 (Entrada)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              WokwiMqttService.connectionStatusText,
                              style: TextStyle(
                                fontSize: 10,
                                color: WokwiMqttService.isConnected
                                    ? AppTheme.success
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Indicador dos 3 LEDs físicos do Wokwi (Verde 25, Amarelo 26, Vermelho 27)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _LedDot(
                            color: AppTheme.success,
                            isOn: hasTelemetry && WokwiMqttService.ledVerdeOn,
                          ),
                          const SizedBox(width: 5),
                          _LedDot(
                            color: AppTheme.warning,
                            isOn: hasTelemetry && WokwiMqttService.ledAmareloOn,
                          ),
                          const SizedBox(width: 5),
                          _LedDot(
                            color: AppTheme.error,
                            isOn: hasTelemetry && WokwiMqttService.ledVermelhoOn,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _getStationLevelLabel(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: hasTelemetry ? Colors.white : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    if (hasTelemetry)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isSensor && dist != null
                              ? 'HC-SR04: ${dist.toStringAsFixed(0)} cm'
                              : 'Modo: MQTT Simulado',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                      )
                    else
                      const Row(
                        children: [
                          Text(
                            'Abrir Painel MQTT',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(Icons.chevron_right_rounded, size: 14, color: AppTheme.primary),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LedDot extends StatelessWidget {
  final Color color;
  final bool isOn;

  const _LedDot({required this.color, required this.isOn});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOn ? color : color.withValues(alpha: 0.18),
        boxShadow: isOn
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.7),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}

class _WokwiControlModal extends StatefulWidget {
  const _WokwiControlModal();

  @override
  State<_WokwiControlModal> createState() => _WokwiControlModalState();
}

class _WokwiControlModalState extends State<_WokwiControlModal> {
  double _simulatedQty = (WokwiMqttService.quantidade ?? 12).toDouble();
  final TextEditingController _tagIdController = TextEditingController(text: 'CR001');
  String _selectedZone = 'Hortifruti';
  int _selectedRssi = -62;
  bool _tagParado = true;

  static const List<String> _zones = [
    'Entrada',
    'Saida',
    'Hortifruti',
    'Padaria',
    'Estacionamento',
  ];

  @override
  void dispose() {
    _tagIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: MockDB.stateNotifier,
      builder: (context, _, _) {
        final hasTelemetry = WokwiMqttService.hasReceivedStationTelemetry;
        final qtd = WokwiMqttService.quantidade;
        final pct = WokwiMqttService.ocupacaoPercentual;
        final dist = WokwiMqttService.distanciaCm;
        final tags = WokwiMqttService.equipmentTags;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Central IoT Wokwi & MQTT (HiveMQ)',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Tópico base: synercart/vitor/demo-71507/filial01/gateway01',
                              style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => WokwiMqttService.connect(),
                        icon: const Icon(Icons.sync_rounded, size: 15),
                        label: Text(
                          WokwiMqttService.isConnected ? 'Reconectar' : 'Conectar',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Card de Telemetria ao Vivo do Sensor Ultrassônico
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TELEMETRIA DA ESTAÇÃO (EST01)',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textSecondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              hasTelemetry
                                  ? 'Origem: ${WokwiMqttService.origem.toUpperCase()}'
                                  : 'Aguardando Wokwi...',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _TelemetryMetricBox(
                                label: 'Quantidade',
                                value: qtd != null ? '$qtd/${WokwiMqttService.capacidade}' : '--',
                                subtitle: 'carrinhos na baia',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _TelemetryMetricBox(
                                label: 'Ocupação',
                                value: pct != null ? '$pct%' : '--',
                                subtitle: 'status: ${WokwiMqttService.statusRaw}',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _TelemetryMetricBox(
                                label: 'HC-SR04',
                                value: dist != null ? '${dist.toStringAsFixed(0)} cm' : 'Simulado',
                                subtitle: 'distância lida',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Controle de Comandos para o Wokwi (/comando)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'ENVIAR COMANDO MQTT PARA O WOKWI',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textSecondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            if (WokwiMqttService.lastAckMessage != null)
                              Text(
                                'ACK: ${WokwiMqttService.lastAckMessage}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: (WokwiMqttService.lastAckOk ?? false)
                                      ? AppTheme.success
                                      : AppTheme.warning,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Simular quantidade: ${_simulatedQty.round()} carrinhos',
                              style: const TextStyle(fontSize: 12, color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () {
                                WokwiMqttService.sendCommand({'acao': 'usar_sensor'});
                              },
                              child: const Text(
                                'Usar Sensor HC-SR04',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _simulatedQty,
                          min: 0,
                          max: 20,
                          divisions: 20,
                          activeColor: AppTheme.primary,
                          onChanged: (val) => setState(() => _simulatedQty = val),
                          onChangeEnd: (val) {
                            WokwiMqttService.sendCommand({
                              'acao': 'definir_quantidade',
                              'quantidade': val.round(),
                            });
                          },
                        ),
                        const SizedBox(height: 6),
                        const Divider(height: 16, color: Colors.white12),
                        const Text(
                          'Simular Tag BLE de Equipamento (/comando -> acao: "tag")',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: _tagIdController,
                                style: const TextStyle(fontSize: 12, color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'CR001 ou CS001',
                                  filled: true,
                                  fillColor: AppTheme.surface,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppTheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedZone,
                                    isExpanded: true,
                                    dropdownColor: AppTheme.surface,
                                    style: const TextStyle(fontSize: 12, color: Colors.white),
                                    items: _zones
                                        .map((z) => DropdownMenuItem(value: z, child: Text(z)))
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() => _selectedZone = val);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _tagParado,
                                  activeColor: AppTheme.primary,
                                  onChanged: (v) => setState(() => _tagParado = v ?? true),
                                ),
                                const Text('Parado', style: TextStyle(fontSize: 11, color: Colors.white)),
                              ],
                            ),
                            DropdownButton<int>(
                              value: _selectedRssi,
                              dropdownColor: AppTheme.surface,
                              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                              items: const [
                                DropdownMenuItem(value: -55, child: Text('RSSI -55 (Forte)')),
                                DropdownMenuItem(value: -62, child: Text('RSSI -62 (Normal)')),
                                DropdownMenuItem(value: -90, child: Text('RSSI -90 (Fraco)')),
                              ],
                              onChanged: (v) {
                                if (v != null) setState(() => _selectedRssi = v);
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(90, 36),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                              onPressed: () {
                                WokwiMqttService.sendCommand({
                                  'acao': 'tag',
                                  'id': _tagIdController.text.trim().toUpperCase(),
                                  'zona': _selectedZone,
                                  'rssi': _selectedRssi,
                                  'parado': _tagParado,
                                });
                              },
                              child: const Text('Enviar Tag', style: TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    const Text(
                      'TAGS BLE MONITORADAS PELO WOKWI (/equipamentos)',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...tags.map((t) {
                      final isAbandoned = t.status == 'possivel_abandono';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isAbandoned
                                ? AppTheme.error.withValues(alpha: 0.4)
                                : Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${t.id} • ${t.zona} (${t.rssi} dBm)',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            Row(
                              children: [
                                Text(
                                  t.formattedStatus,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isAbandoned ? AppTheme.error : AppTheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    WokwiMqttService.sendCommand({
                                      'acao': 'remover_tag',
                                      'id': t.id,
                                    });
                                  },
                                  child: const Icon(Icons.close, size: 14, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TelemetryMetricBox extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;

  const _TelemetryMetricBox({
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
