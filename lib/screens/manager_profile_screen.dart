import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme.dart';
import 'role_selection_screen.dart';
import 'edit_profile_screen.dart';

class ManagerProfileScreen extends StatelessWidget {
  const ManagerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Meu Turno', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  MaterialPageRoute(builder: (_) => const EditProfileScreen(role: 'manager')),
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
                        'lib/assets/icons/avatar_manager.svg',
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
                            'Aline Carvalho',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Gerente - ID: 8849',
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
                    'Carvalho@gmail.com',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text('Senha:', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  SizedBox(height: 4),
                  Text(
                    '654321',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white, letterSpacing: 0.8),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Funcionários em atividade
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_outline, color: AppTheme.textSecondary, size: 24),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Funcionários em atividade',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Total de funcionários ativos no turno',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF172554),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      '40 Ativos',
                      style: TextStyle(
                        color: Color(0xFF3B82F6),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Arquivo baixado com sucesso!
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Relatório de turno em PDF baixado com sucesso!'),
                    backgroundColor: AppTheme.success,
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
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFF161B22),
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Arquivo baixado com sucesso!',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

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
