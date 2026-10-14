import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'task_detail_screen.dart';

class EmployeeTasksScreen extends StatelessWidget {
  const EmployeeTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Tarefas não resolvidas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner de Atenção no Topo
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.45),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Atenção!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          '3 pontos de coleta abaixo do mínimo',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Alertas Ativos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 14),

            // Task 1 - Entrada Principal
            _TaskCard(
              title: 'Entrada Principal',
              subtitle: 'Carrinhos: 2/20 disponíveis',
              timeText: 'Há 15 min',
              tagText: 'CRÍTICO',
              tagColor: const Color(0xFFEF4444),
              tagBgColor: const Color(0xFF3F1D24),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TaskDetailScreen()),
                );
              },
            ),
            const SizedBox(height: 14),

            // Task 2 - Setor Hortifruti
            _TaskCard(
              title: 'Setor Hortifruti',
              subtitle: 'Cestos: 0/15 disponíveis',
              timeText: 'Há 8 min',
              tagText: 'CRÍTICO',
              tagColor: const Color(0xFFEF4444),
              tagBgColor: const Color(0xFF3F1D24),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TaskDetailScreen()),
                );
              },
            ),
            const SizedBox(height: 14),

            // Task 3 - Estacionamento Norte
            _TaskCard(
              title: 'Estacionamento Norte',
              subtitle: 'Carrinhos: 5/25 disponíveis',
              timeText: 'Há 22 min',
              tagText: 'ATENÇÃO',
              tagColor: const Color(0xFFF59E0B),
              tagBgColor: const Color(0xFF382A12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TaskDetailScreen()),
                );
              },
            ),

            const SizedBox(height: 24),
            const Text(
              'Histórico Recente',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 14),

            // Task 4 - Histórico Resolvido (Corredor 7)
            _TaskCard(
              title: 'Corredor 7',
              subtitle: 'Cestos repostos — 12 unidades',
              timeText: 'Resolvido há 1h',
              tagText: 'RESOLVIDO',
              tagColor: const Color(0xFF10B981),
              tagBgColor: const Color(0xFF0F3528),
              showButton: false,
              onTap: () {},
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timeText;
  final String tagText;
  final Color tagColor;
  final Color tagBgColor;
  final bool showButton;
  final VoidCallback onTap;

  const _TaskCard({
    required this.title,
    required this.subtitle,
    required this.timeText,
    required this.tagText,
    required this.tagColor,
    required this.tagBgColor,
    this.showButton = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Barra indicadora lateral colorida com cantos arredondados
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: tagColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Status pill + Timestamp
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: tagBgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 6, color: tagColor),
                          const SizedBox(width: 5),
                          Text(
                            tagText,
                            style: TextStyle(
                              color: tagColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      timeText,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),

                if (showButton) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B2838),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Saiba mais'),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
