import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'login_screen.dart';

class EmployeeRegistrationScreen extends StatelessWidget {
  const EmployeeRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Logo do Figma
              Image.asset('lib/assets/icons/logo.png', height: 120),
              const SizedBox(height: 16),
              const Text(
                'Gestão Inteligente de Frota de Carrinhos',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 40),

              const Text('Nome Completo:', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              const SizedBox(height: 8),
              const TextField(
                decoration: InputDecoration(hintText: 'Ex: Róger Mendes Azevedo', prefixIcon: Icon(Icons.person_outline)),
              ),
              const SizedBox(height: 16),
              
              const Text('Email Corporativo:', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              const SizedBox(height: 8),
              const TextField(
                decoration: InputDecoration(hintText: 'Ex: lagoinha@gmail.com', prefixIcon: Icon(Icons.email_outlined)),
              ),
              const SizedBox(height: 16),

              const Text('Senha:', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              const SizedBox(height: 8),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(hintText: 'Ex: 123456', prefixIcon: Icon(Icons.lock_outline)),
              ),
              const SizedBox(height: 16),

              const Text('Unidade da Loja', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              const SizedBox(height: 8),
              const TextField(
                decoration: InputDecoration(hintText: 'Central - Unidade 07', prefixIcon: Icon(Icons.store), suffixIcon: Icon(Icons.arrow_drop_down)),
              ),
              const SizedBox(height: 16),

              const Text('Cargo', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              const SizedBox(height: 8),
              const TextField(
                decoration: InputDecoration(hintText: 'Ex: Reposição', prefixIcon: Icon(Icons.badge_outlined)),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen(role: 'employee')));
                },
                child: const Text('Cadastrar'),
              ),
              const SizedBox(height: 16),
              
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen(role: 'employee')));
                  },
                  child: const Text('Já possui uma conta? Clique aqui', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
