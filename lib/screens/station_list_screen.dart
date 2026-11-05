import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'equipment_list_screen.dart';
import 'equipment_detail_screen.dart';
import 'station_registration_screen.dart';

class StationListScreen extends StatefulWidget {
  final String role; // 'manager' ou 'employee'
  const StationListScreen({super.key, this.role = 'manager'});

  @override
  State<StationListScreen> createState() => _StationListScreenState();
}

class _StationListScreenState extends State<StationListScreen> {
  // Armazena qual pílula ('Cestos' ou 'Carrinhos') está expandida em cada estação
  final Map<String, String?> _expandedPillByStation = {};

  void _togglePill(String stationTitle, String type) {
    setState(() {
      if (_expandedPillByStation[stationTitle] == type) {
        _expandedPillByStation[stationTitle] = null;
      } else {
        _expandedPillByStation[stationTitle] = type;
      }
    });
  }

  void _openEquipmentList(String stationTitle, String type, bool hasCarrinhos) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EquipmentListScreen(
          role: widget.role,
          stationName: stationTitle,
          initialEquipmentType: type,
          hasCarrinhos: hasCarrinhos,
        ),
      ),
    );
  }

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
                      color: AppTheme.primary.withValues(alpha: 0.15),
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
                        Text(
                          'Estações (Área de retirada do carrinho/cesto)',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Station Cards
            _buildStationCard('Estação 1 - Entrada', true),
            const SizedBox(height: 12),
            _buildStationCard('Estação 2 - Saída', true),
            const SizedBox(height: 12),
            _buildStationCard('Estação 3 - Hortifruti', false),
            const SizedBox(height: 12),
            _buildStationCard('Estação 4 - Padaria', false),

            if (widget.role != 'employee') ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StationRegistrationScreen()),
                  );
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

  Widget _buildStationCard(String title, bool hasCarrinhos) {
    final expandedType = _expandedPillByStation[title];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _openEquipmentList(
              title,
              hasCarrinhos ? 'Carrinhos' : 'Cestos',
              hasCarrinhos,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    const Text(
                      'Equipamentos do local',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 10),
                    ),
                  ],
                ),
                const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 18),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildEquipmentDropdownPill(
                stationTitle: title,
                type: 'Cestos',
                isExpanded: expandedType == 'Cestos',
              ),
              if (hasCarrinhos) ...[
                const SizedBox(width: 12),
                _buildEquipmentDropdownPill(
                  stationTitle: title,
                  type: 'Carrinhos',
                  isExpanded: expandedType == 'Carrinhos',
                ),
              ],
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: expandedType != null
                ? _buildExpandedEquipmentPreview(
                    stationTitle: title,
                    type: expandedType,
                    hasCarrinhos: hasCarrinhos,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentDropdownPill({
    required String stationTitle,
    required String type,
    required bool isExpanded,
  }) {
    return GestureDetector(
      onTap: () => _togglePill(stationTitle, type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isExpanded ? AppTheme.primary.withValues(alpha: 0.16) : AppTheme.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isExpanded ? AppTheme.primary : AppTheme.textSecondary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type == 'Cestos' ? Icons.shopping_basket_outlined : Icons.shopping_cart_outlined,
              size: 14,
              color: isExpanded ? AppTheme.primary : AppTheme.textPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              type,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isExpanded ? FontWeight.bold : FontWeight.normal,
                color: isExpanded ? AppTheme.primary : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 6),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 14,
                color: isExpanded ? AppTheme.primary : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedEquipmentPreview({
    required String stationTitle,
    required String type,
    required bool hasCarrinhos,
  }) {
    final isCestos = type == 'Cestos';
    final singularLabel = isCestos ? 'Cesto' : 'Carrinho';
    final totalCount = isCestos ? 20 : 28;
    final activeCount = isCestos ? 18 : 25;
    final maintenanceCount = isCestos ? 1 : 2;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$type disponíveis ($totalCount)',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.circle, size: 7, color: AppTheme.success),
                    const SizedBox(width: 4),
                    Text(
                      '$activeCount ativos',
                      style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.circle, size: 7, color: AppTheme.warning),
                    const SizedBox(width: 4),
                    Text(
                      '$maintenanceCount conserto',
                      style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(4, (index) {
                final itemNumber = index + 1;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EquipmentDetailScreen(
                          role: widget.role,
                          cartNumber: itemNumber,
                          stationName: stationTitle,
                          equipmentType: singularLabel,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isCestos ? Icons.shopping_basket_outlined : Icons.shopping_cart_outlined,
                          size: 12,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '$singularLabel $itemNumber',
                          style: const TextStyle(fontSize: 11, color: AppTheme.textPrimary),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _openEquipmentList(stationTitle, type, hasCarrinhos),
                child: Text(
                  'Ver todos os $totalCount ${type.toLowerCase()} desta estação',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
