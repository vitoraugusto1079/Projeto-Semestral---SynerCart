import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme.dart';
import 'role_selection_screen.dart';
import 'edit_profile_screen.dart';

class EmployeeProfileScreen extends StatelessWidget {
  const EmployeeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Meu Turno', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Perfil Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen(role: 'employee')),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: SvgPicture.asset(
                        'lib/assets/icons/avatar_employee.svg',
                        width: 48,
                        height: 48,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'João Silva',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Repositor - ID: 8849',
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF172554),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: Color(0xFF3B82F6), size: 6),
                          SizedBox(width: 5),
                          Text(
                            'ATIVO',
                            style: TextStyle(
                              color: Color(0xFF3B82F6),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Dados Card
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email:', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  SizedBox(height: 4),
                  Text(
                    'Silvajo@gmail.com',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text('Senha:', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  SizedBox(height: 4),
                  Text(
                    '******',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white, letterSpacing: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Dados de turno
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: AppTheme.textSecondary, size: 16),
                            SizedBox(width: 6),
                            Text('Concluídas', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text('3', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time, color: AppTheme.textSecondary, size: 16),
                            SizedBox(width: 6),
                            Text('Tempo Ativo', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text('4h 30m', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Tarefas Pendentes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            const SizedBox(height: 12),
            
            // Tarefa Pendente
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: const Border(left: BorderSide(color: AppTheme.error, width: 4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• PRIORIDADE: ENTRADA PRINCIPAL SEM CARRINHOS', style: TextStyle(color: AppTheme.error, fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Recolha Urgente de Carrinhos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  const Text('Retirar 15 unidades do Depósito Sul para suprir a entrada principal.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.background,
                        foregroundColor: AppTheme.textPrimary,
                        elevation: 0,
                      ),
                      onPressed: () {
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
                                const Text('Missão Cumprida!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                                const SizedBox(height: 8),
                                const Text('Essa tarefa foi encerrada e o status da estação foi atualizado.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
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
                      child: const Text('Encerrar Tarefa', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            // Logout
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppTheme.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Text('Deseja sair de sua conta?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    content: const Text('Todos os dados da sua sessão serão salvos', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                    actionsPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                    actions: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: const Text('Encerrar sessão'),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.textPrimary,
                              side: const BorderSide(color: AppTheme.textSecondary),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
