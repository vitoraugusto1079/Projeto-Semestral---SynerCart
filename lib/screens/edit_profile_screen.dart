import 'package:flutter/material.dart';
import '../core/theme.dart';

class EditProfileScreen extends StatelessWidget {
  final String role; // 'manager' ou 'employee'

  const EditProfileScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Editar Perfil', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.background,
                      child: Icon(Icons.person, color: AppTheme.textSecondary, size: 50),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              const Text('Nome Completo:', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: role == 'manager' ? 'Aline Carvalho' : 'João Silva',
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 20),
              
              const Text('Email Corporativo:', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: role == 'manager' ? 'carvalho@gmail.com' : 'silvajo@gmail.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 40),
              
              ElevatedButton(
                onPressed: () {
                  // Simula o salvamento e retorna à tela anterior
                  Navigator.pop(context);
                },
                child: const Text('Salvar Alterações'),
              ),
              const SizedBox(height: 12),
              
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.textPrimary,
                    side: const BorderSide(color: AppTheme.textSecondary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
