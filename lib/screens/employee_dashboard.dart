import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/mock_db.dart';
import '../core/wokwi_mqtt_service.dart';
import '../widgets/wokwi_iot_panel.dart';
import 'equipment_list_screen.dart';

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Supermercado Central',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              'Unidade 07 • Turno Manhã',
              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, color: AppTheme.success, size: 8),
                SizedBox(width: 6),
                Text('ONLINE', style: TextStyle(color: AppTheme.success, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: MockDB.stateNotifier,
        builder: (context, _, _) {
          final stations = MockDB.stations;
          final stableCount = stations.where((s) => s['status'] == 'stable').length;
          final alertCount = stations.where((s) => s['status'] == 'alert').length;
          final criticalCount = stations.where((s) => s['status'] == 'critical').length;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumo rápido e limpo do status das estações
                Row(
                  children: [
                    Expanded(
                      child: _SummaryMiniCard(
                        label: 'Estáveis',
                        count: '$stableCount',
                        color: AppTheme.success,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SummaryMiniCard(
                        label: 'Em Alerta',
                        count: '$alertCount',
                        color: AppTheme.warning,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SummaryMiniCard(
                        label: 'Críticas',
                        count: '$criticalCount',
                        color: AppTheme.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Painel ao vivo do Gateway IoT Wokwi (ESP32 + Sensor Ultrassônico HC-SR04 + MQTT HiveMQ)
                const WokwiIotBanner(),
                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'CAPACIDADE DAS ESTAÇÕES',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        if (WokwiMqttService.isConnected) {
                          WokwiMqttService.sendCommand({'acao': 'consultar'});
                        } else {
                          WokwiMqttService.connect();
                        }
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppTheme.surface,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            contentPadding: const EdgeInsets.all(24),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle, color: AppTheme.success, size: 60),
                                const SizedBox(height: 16),
                                const Text(
                                  'Dados Atualizados!',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'A capacidade de todas as estações foi sincronizada em tempo real.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Continuar'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.refresh_rounded, color: AppTheme.textSecondary, size: 14),
                            SizedBox(width: 5),
                            Text(
                              'Atualizar',
                              style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: ListView.separated(
                    itemCount: stations.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final station = stations[index];
                      return _StationCapacityCard(
                        name: station['name'] as String,
                        sector: (station['sector'] as String?) ?? 'Equipamentos do local',
                        percentage: station['percentage'] as int,
                        status: station['status'] as String,
                        hasCarrinhos: (station['hasCarrinhos'] as bool?) ??
                            !(station['name'].toString().contains('Hortifruti') ||
                                station['name'].toString().contains('Padaria')),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryMiniCard extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _SummaryMiniCard({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, size: 7, color: color),
                  const SizedBox(width: 5),
                  Text(
                    label,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                count,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StationCapacityCard extends StatelessWidget {
  final String name;
  final String sector;
  final int percentage;
  final String status;
  final bool hasCarrinhos;

  const _StationCapacityCard({
    required this.name,
    required this.sector,
    required this.percentage,
    required this.status,
    required this.hasCarrinhos,
  });

  @override
  Widget build(BuildContext context) {
    Color getStatusColor() {
      switch (status) {
        case 'critical':
          return AppTheme.error;
        case 'alert':
          return AppTheme.warning;
        default:
          return AppTheme.success;
      }
    }

    String getStatusText() {
      switch (status) {
        case 'critical':
          return 'CRÍTICO';
        case 'alert':
          return 'ALERTA';
        default:
          return 'ESTÁVEL';
      }
    }

    final statusColor = getStatusColor();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EquipmentListScreen(
              role: 'employee',
              stationName: name,
              initialEquipmentType: hasCarrinhos ? 'Carrinhos' : 'Cestos',
              hasCarrinhos: hasCarrinhos,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        sector,
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 6, color: statusColor),
                      const SizedBox(width: 5),
                      Text(
                        getStatusText(),
                        style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: AppTheme.background,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  '$percentage%',
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
