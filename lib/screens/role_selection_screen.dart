import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole; // 'manager' ou 'employee'

  void _confirmRole() {
    if (selectedRole != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(role: selectedRole!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma área de atuação.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              // Logo do Figma
              Image.asset('lib/assets/icons/logo.png', height: 160),
              const SizedBox(height: 16),
              const Text(
                'Gestão Inteligente de Frota de Carrinhos',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 48),
              
              const Text(
                'Escolha sua área de atuação',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 16),
              
              // Botão Gerente
              _RoleCard(
                title: 'Gerente',
                icon: Icons.manage_accounts_outlined,
                isSelected: selectedRole == 'manager',
                onTap: () => setState(() => selectedRole = 'manager'),
              ),
              const SizedBox(height: 12),
              
              // Botão Funcionário
              _RoleCard(
                title: 'Funcionário',
                icon: Icons.badge_outlined,
                isSelected: selectedRole == 'employee',
                onTap: () => setState(() => selectedRole = 'employee'),
              ),
              
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: _confirmRole,
                child: const Text('Confirmar'),
              ),
              
              const Spacer(),
              const Text(
                'v2.4.1 — Conectado de forma segura',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.textPrimary, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
