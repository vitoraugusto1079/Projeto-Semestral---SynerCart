import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/mock_db.dart';
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
      body: ValueListenableBuilder<int>(
        valueListenable: MockDB.stateNotifier,
        builder: (context, _, _) {
          final pendingTasks = MockDB.tasks.where((t) => !t.isResolved).toList();
          final resolvedTasks = MockDB.tasks.where((t) => t.isResolved).toList();
          final allResolved = pendingTasks.isEmpty;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner de Atenção / Status no Topo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (allResolved ? AppTheme.success : const Color(0xFFEF4444)).withValues(alpha: 0.45),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: allResolved ? AppTheme.success : const Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            allResolved ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              allResolved ? 'Tudo em dia!' : 'Atenção!',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              allResolved
                                  ? 'Todos os pontos de coleta foram normalizados'
                                  : '${pendingTasks.length} ${pendingTasks.length == 1 ? "ponto de coleta abaixo do mínimo" : "pontos de coleta abaixo do mínimo"}',
                              style: const TextStyle(
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

                if (pendingTasks.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.verified_outlined, color: AppTheme.success, size: 22),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Nenhuma tarefa pendente no momento.',
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...pendingTasks.map((task) {
                    final isCritical = task.status == 'critical';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _TaskCard(
                        title: task.title,
                        subtitle: task.subtitle,
                        timeText: task.timeText,
                        tagText: isCritical ? 'CRÍTICO' : 'ATENÇÃO',
                        tagColor: isCritical ? const Color(0xFFEF4444) : const Color(0xFFF59E0B),
                        tagBgColor: isCritical ? const Color(0xFF3F1D24) : const Color(0xFF382A12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
                          );
                        },
                      ),
                    );
                  }),

                const SizedBox(height: 10),
                const Text(
                  'Histórico Recente',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 14),

                ...resolvedTasks.map((task) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _TaskCard(
                      title: task.title,
                      subtitle: task.resolvedSubtitle,
                      timeText: task.timeText,
                      tagText: 'RESOLVIDO',
                      tagColor: const Color(0xFF10B981),
                      tagBgColor: const Color(0xFF0F3528),
                      showButton: false,
                      onTap: () {},
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
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
