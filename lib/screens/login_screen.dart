import 'package:flutter/material.dart';
import '../core/theme.dart';
// import 'manager_dashboard.dart'; // TODO: implementar em seguida
import 'employee_main_screen.dart';
import 'manager_main_screen.dart';
import 'manager_registration_screen.dart';
import 'employee_registration_screen.dart';

class LoginScreen extends StatelessWidget {
  final String role; // 'manager' ou 'employee'
  
  const LoginScreen({super.key, required this.role});

  void _login(BuildContext context) {
    if (role == 'manager') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ManagerMainScreen()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const EmployeeMainScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              // Logo do Figma
              Image.asset('lib/assets/icons/logo.png', height: 160),
              const SizedBox(height: 12),
              const SizedBox(height: 8),
              const Text(
                'Gestão Inteligente de Frota de Carrinhos',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 60),

              // Mantido fiel à print: "Nome Completo" (embora Email seja melhor)
              const Text('Nome Completo:', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Ex: Róger Mendes Azevedo',
                  prefixIcon: Icon(Icons.person_outline, color: AppTheme.textSecondary),
                ),
              ),
              const SizedBox(height: 20),

              const Text('Senha:', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Ex: 123456',
                  prefixIcon: Icon(Icons.lock_outline, color: AppTheme.textSecondary),
                ),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () => _login(context),
                child: Text(role == 'manager' ? 'Entrar' : 'Logar'),
              ),
              const SizedBox(height: 16),
              
              Center(
                child: TextButton(
                  onPressed: () {
                    if (role == 'manager') {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ManagerRegistrationScreen()));
                    } else {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const EmployeeRegistrationScreen()));
                    }
                  },
                  child: const Text(
                    'Não possui uma conta? Clique aqui',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'v2.4.1 — Conectado de forma segura',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
