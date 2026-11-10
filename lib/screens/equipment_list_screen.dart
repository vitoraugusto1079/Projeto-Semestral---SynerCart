import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/mock_db.dart';
import 'equipment_detail_screen.dart';
import 'equipment_registration_screen.dart';

class EquipmentListScreen extends StatefulWidget {
  final String role; // 'manager' ou 'employee'
  final String stationName;
  final String initialEquipmentType; // 'Carrinhos' ou 'Cestos'
  final bool hasCarrinhos;

  const EquipmentListScreen({
    super.key,
    this.role = 'manager',
    this.stationName = 'Estação 1 - Entrada',
    this.initialEquipmentType = 'Carrinhos',
    this.hasCarrinhos = true,
  });

  @override
  State<EquipmentListScreen> createState() => _EquipmentListScreenState();
}

class _EquipmentListScreenState extends State<EquipmentListScreen> {
  late String _selectedType;

  Map<String, dynamic>? get _stationData {
    for (final s in MockDB.stations) {
      if (s['name'] == widget.stationName) return s;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    final hasCestos = (_stationData?['hasCestos'] as bool?) ?? true;
    final hasCarrinhos = (_stationData?['hasCarrinhos'] as bool?) ?? widget.hasCarrinhos;
    if (widget.initialEquipmentType == 'Carrinhos' && hasCarrinhos) {
      _selectedType = 'Carrinhos';
    } else if (hasCestos) {
      _selectedType = 'Cestos';
    } else {
      _selectedType = 'Carrinhos';
    }
  }

  @override
  Widget build(BuildContext context) {
    final station = _stationData;
    final hasCestos = (station?['hasCestos'] as bool?) ?? true;
    final hasCarrinhos = (station?['hasCarrinhos'] as bool?) ?? widget.hasCarrinhos;
    final cestosTotal = (station?['cestosTotal'] as int?) ?? 20;
    final carrinhosTotal = (station?['carrinhosTotal'] as int?) ?? 28;

    final isCestos = _selectedType == 'Cestos';
    final itemCount = isCestos ? cestosTotal : carrinhosTotal;
    final singularLabel = isCestos ? 'Cesto' : 'Carrinho';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Equipamentos • $_selectedType',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Unidade 7', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          widget.stationName,
                          style: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.8), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Pílulas de alternância entre Cestos e Carrinhos
            Row(
              children: [
                if (hasCestos)
                  _buildTypeFilterPill(
                    label: 'Cestos ($cestosTotal)',
                    type: 'Cestos',
                    icon: Icons.shopping_basket_outlined,
                  ),
                if (hasCestos && hasCarrinhos) const SizedBox(width: 10),
                if (hasCarrinhos)
                  _buildTypeFilterPill(
                    label: 'Carrinhos ($carrinhosTotal)',
                    type: 'Carrinhos',
                    icon: Icons.shopping_cart_outlined,
                  ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Grid de Equipamentos (Carrinhos ou Cestos)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                final itemNumber = index + 1;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (_) => EquipmentDetailScreen(
                          role: widget.role,
                          cartNumber: itemNumber,
                          stationName: widget.stationName,
                          equipmentType: singularLabel,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isCestos ? Icons.shopping_basket_outlined : Icons.shopping_cart_outlined,
                              size: 14,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text('$singularLabel $itemNumber', style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            if (widget.role != 'employee') ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EquipmentRegistrationScreen()),
                  );
                },
                child: const Text('Adicionar equipamento +'),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeFilterPill({
    required String label,
    required String type,
    required IconData icon,
  }) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.18) : AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.textSecondary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
