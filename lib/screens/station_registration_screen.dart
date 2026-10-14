import 'package:flutter/material.dart';
import '../core/theme.dart';

class StationRegistrationScreen extends StatefulWidget {
  const StationRegistrationScreen({super.key});

  @override
  State<StationRegistrationScreen> createState() => _StationRegistrationScreenState();
}

class _StationRegistrationScreenState extends State<StationRegistrationScreen> {
  bool _cestoSelected = false;
  bool _carrinhoSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Cadastro de Estação', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                        const Text('Nova Estação', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        const SizedBox(height: 4),
                        Text('Preencha os dados da estação que deseja cadastrar', style: TextStyle(color: AppTheme.textSecondary.withOpacity(0.8), fontSize: 11)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: AppTheme.textSecondary.withOpacity(0.1)),
              const SizedBox(height: 20),

              // Form
              _buildLabel('Nome da Estação:'),
              _buildTextField('Ex: Estação 1 - Entrada'),
              const SizedBox(height: 16),

              _buildLabel('Máximo de unidades:'),
              _buildTextField('Ex: 300'),
              const SizedBox(height: 24),

              // Equipamentos checkboxes
              const Center(
                child: Text('Equipamentos da Estação', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCheckboxItem('Cesto', _cestoSelected, (val) => setState(() => _cestoSelected = val!)),
                  const SizedBox(width: 16),
                  _buildCheckboxItem('Carrinho', _carrinhoSelected, (val) => setState(() => _carrinhoSelected = val!)),
                ],
              ),
              const SizedBox(height: 32),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Feedback visual e volta
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Estação cadastrada com sucesso!'), backgroundColor: AppTheme.success));
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

  Widget _buildCheckboxItem(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return AppTheme.primary;
              return AppTheme.background;
            }),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: BorderSide.none,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ),
      ],
    );
  }
}
