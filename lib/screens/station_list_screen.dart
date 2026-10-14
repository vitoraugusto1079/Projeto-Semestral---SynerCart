import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'equipment_list_screen.dart';
import 'station_registration_screen.dart';

class StationListScreen extends StatelessWidget {
  final String role; // 'manager' ou 'employee'
  const StationListScreen({super.key, this.role = 'manager'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Estações', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Card - Unidade 7
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.shopping_cart_checkout, color: AppTheme.primary, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Unidade 7', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Estações (Área de retirada do carrinho/cesto)', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Station Cards
            _buildStationCard(context, 'Estação 1 - Entrada', true),
            const SizedBox(height: 12),
            _buildStationCard(context, 'Estação 2 - Saída', true),
            const SizedBox(height: 12),
            _buildStationCard(context, 'Estação 3 - Hortifruti', false),
            const SizedBox(height: 12),
            _buildStationCard(context, 'Estação 4 - Padaria', false),

            if (role != 'employee') ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const StationRegistrationScreen()));
                },
                child: const Text('Adicionar Estação +'),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStationCard(BuildContext context, String title, bool hasCarrinhos) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => EquipmentListScreen(role: role)));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            const Text('Equipamentos do local', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildEquipmentDropdown('Cestos'),
                if (hasCarrinhos) ...[
                  const SizedBox(width: 12),
                  _buildEquipmentDropdown('Carrinhos'),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentDropdown(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.textSecondary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            type == 'Cestos' ? Icons.shopping_basket_outlined : Icons.shopping_cart_outlined, 
            size: 14, 
            color: AppTheme.textPrimary
          ),
          const SizedBox(width: 6),
          Text(type, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 6),
          const Icon(Icons.keyboard_arrow_down, size: 14, color: AppTheme.textSecondary),
        ],
      ),
    );
  }
}
