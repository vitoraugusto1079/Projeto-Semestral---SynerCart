import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/mock_db.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskItemModel? task;

  const TaskDetailScreen({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    final currentTask = task ?? MockDB.tasks.first;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Tarefas não resolvidas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Retirar / Levar
              Row(
                children: [
                  const Icon(Icons.circle, color: AppTheme.error, size: 10),
                  const SizedBox(width: 8),
                  const Text('Retirar de: ', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                  Expanded(
                    child: Text(
                      currentTask.fromLocation,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 4),
                height: 20,
                child: const VerticalDivider(color: AppTheme.textSecondary, width: 2),
              ),
              Row(
                children: [
                  const Icon(Icons.circle, color: AppTheme.success, size: 10),
                  const SizedBox(width: 8),
                  const Text('Levar para: ', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                  Expanded(
                    child: Text(
                      currentTask.toLocation,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              Text(currentTask.quantityText, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                currentTask.priorityText,
                style: const TextStyle(color: AppTheme.warning, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              
              const SizedBox(height: 32),
              const Text(
                'ROTA SUGERIDA INTERNA',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              
              // Simulação do Mapa Interno de Rota
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        currentTask.corridorLabel,
                        style: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.5)),
                      ),
                    ),
                    // Origem
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        color: AppTheme.surface,
                        child: Text(
                          currentTask.fromLocation.toUpperCase(),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // Destino
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(border: Border.all(color: AppTheme.success)),
                        child: Text(
                          currentTask.toLocation.toUpperCase(),
                          style: const TextStyle(color: AppTheme.success, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // Tempo estimado
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Row(
                        children: [
                          const Icon(Icons.timer_outlined, color: AppTheme.warning, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            currentTask.estimatedTime,
                            style: const TextStyle(color: AppTheme.warning, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: () {
                  MockDB.resolveTask(currentTask.id);
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
                            'Tarefa Concluída!',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'A reposição em "${currentTask.title}" foi registrada como resolvida e contabilizada no seu turno.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                              onPressed: () {
                                Navigator.pop(context); // Fecha o modal
                                Navigator.pop(context); // Volta para a tela anterior
                              },
                              child: const Text('Continuar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text('Aceitar e concluir tarefa'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppTheme.background,
                  ),
                  child: const Text('Voltar', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
