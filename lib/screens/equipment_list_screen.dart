import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'equipment_detail_screen.dart';

class EquipmentListScreen extends StatelessWidget {
  final String role; // 'manager' ou 'employee'
  const EquipmentListScreen({super.key, this.role = 'manager'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Equipamentos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.store, color: AppTheme.primary, size: 32),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Unidade 7', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Estação 1 - Entrada', style: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.8), fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Grid de Carrinhos
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 28,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (_) => EquipmentDetailScreen(
                          role: role,
                          cartNumber: index + 1,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Carrinho ${index + 1}', style: const TextStyle(fontSize: 12)),
                        const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            if (role != 'employee') ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Adicionar equipamento +'),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
