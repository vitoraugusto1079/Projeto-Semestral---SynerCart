import 'package:flutter/material.dart';
import '../core/theme.dart';

class UnitRegistrationScreen extends StatelessWidget {
  const UnitRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Cadastro de Unidade', style: TextStyle(fontSize: 16)),
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.storefront, color: AppTheme.primary),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nova Filial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Preencha os dados de infraestrutura comercial', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              const Text('Nome da Loja', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              const SizedBox(height: 8),
              const TextField(decoration: InputDecoration(hintText: 'Ex: Supermercado Syner - Pinheiros')),
              const SizedBox(height: 20),

              const Text('Endereço', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              const SizedBox(height: 8),
              const TextField(decoration: InputDecoration(hintText: 'Ex: Av. das Nações Unidas, 12400 - São Paulo')),
              const SizedBox(height: 20),

              const Text('Horário de Funcionamento:', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              const SizedBox(height: 8),
              const TextField(decoration: InputDecoration(hintText: 'Ex: 07:00 às 22:00')),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {},
                child: const Text('Salvar Unidade'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppTheme.textPrimary,
                    side: const BorderSide(color: AppTheme.textSecondary, width: 1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
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
