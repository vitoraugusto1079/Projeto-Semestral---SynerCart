import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/mock_db.dart';
import 'equipment_list_screen.dart';

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Supermercado Central',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Unidade 07 • Turno Manhã',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
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
                Icon(Icons.circle, color: AppTheme.success, size: 10),
                SizedBox(width: 6),
                Text('ONLINE', style: TextStyle(color: AppTheme.success, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CAPACIDADE DAS ESTAÇÕES',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
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
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.refresh, color: AppTheme.textSecondary, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder<int>(
                valueListenable: MockDB.stateNotifier,
                builder: (context, _, _) {
                  return ListView.separated(
                    itemCount: MockDB.stations.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final station = MockDB.stations[index];
                      return _StationCapacityCard(
                        name: station['name'],
                        percentage: station['percentage'],
                        status: station['status'],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
// bottomNavigationBar removido para o Wrapper
    );
  }
}

class _StationCapacityCard extends StatelessWidget {
  final String name;
  final int percentage;
  final String status;

  const _StationCapacityCard({
    required this.name,
    required this.percentage,
    required this.status,
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

    return GestureDetector(
      onTap: () {
        final isBasketOnly = name.contains('Cestos') || name.contains('Hortifruti');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EquipmentListScreen(
              role: 'employee',
              stationName: name,
              initialEquipmentType: isBasketOnly ? 'Cestos' : 'Carrinhos',
              hasCarrinhos: !isBasketOnly,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusColor().withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    getStatusText(),
                    style: TextStyle(color: getStatusColor(), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: AppTheme.background, // Fundo da barra
                      valueColor: AlwaysStoppedAnimation<Color>(getStatusColor()),
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '$percentage%',
                  style: TextStyle(color: getStatusColor(), fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
