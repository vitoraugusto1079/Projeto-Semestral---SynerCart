import 'package:flutter/material.dart';
import '../core/theme.dart';

class EquipmentRegistrationScreen extends StatefulWidget {
  const EquipmentRegistrationScreen({super.key});

  @override
  State<EquipmentRegistrationScreen> createState() => _EquipmentRegistrationScreenState();
}

class _EquipmentRegistrationScreenState extends State<EquipmentRegistrationScreen> {
  String _tipoSelecionado = ''; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Cadastro de Equipamento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, color: AppTheme.primary, size: 36),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Novo Equipamento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        const SizedBox(height: 4),
                        Text('Preencha os dados de equipamento que deseja cadastrar', style: TextStyle(color: AppTheme.textSecondary.withOpacity(0.8), fontSize: 11)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: AppTheme.textSecondary.withOpacity(0.1)),
              const SizedBox(height: 20),

              // Form
              _buildLabel('Numeração do equipamento'),
              _buildTextField('Ex: Carrinho 1'),
              const SizedBox(height: 16),

              _buildLabel('Estação:'),
              _buildTextField('Ex: Entrada'),
              const SizedBox(height: 16),

              _buildLabel('Status atual:'),
              _buildTextField('Ex: Inativo'),
              const SizedBox(height: 24),

              // Tipo de Equipamento toggle
              const Center(
                child: Text('Tipo de Equipamento', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _tipoSelecionado = 'Cesto'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _tipoSelecionado == 'Cesto' ? AppTheme.primary.withOpacity(0.1) : AppTheme.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _tipoSelecionado == 'Cesto' ? AppTheme.primary : Colors.transparent),
                        ),
                        alignment: Alignment.center,
                        child: Text('Cesto', style: TextStyle(
                          color: _tipoSelecionado == 'Cesto' ? AppTheme.primary : AppTheme.textSecondary, 
                          fontWeight: FontWeight.bold
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _tipoSelecionado = 'Carrinho'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _tipoSelecionado == 'Carrinho' ? AppTheme.primary.withOpacity(0.1) : AppTheme.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _tipoSelecionado == 'Carrinho' ? AppTheme.primary : Colors.transparent),
                        ),
                        alignment: Alignment.center,
                        child: Text('Carrinho', style: TextStyle(
                          color: _tipoSelecionado == 'Carrinho' ? AppTheme.primary : AppTheme.textSecondary, 
                          fontWeight: FontWeight.bold
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Equipamento cadastrado com sucesso!'), backgroundColor: AppTheme.success));
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Salvar Cadastro', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: AppTheme.background,
                  ),
                  child: const Text('Cancelar', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppTheme.textSecondary.withOpacity(0.5), fontSize: 14),
        filled: true,
        fillColor: AppTheme.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
