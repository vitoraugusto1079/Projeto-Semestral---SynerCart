import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/mock_db.dart';
import '../core/image_picker_io.dart' if (dart.library.js_interop) '../core/image_picker_web.dart';

class StationRegistrationScreen extends StatefulWidget {
  const StationRegistrationScreen({super.key});

  @override
  State<StationRegistrationScreen> createState() => _StationRegistrationScreenState();
}

class _StationRegistrationScreenState extends State<StationRegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sectorController = TextEditingController();

  // Quantidades de Cestos
  final TextEditingController _cestosTotalController = TextEditingController(text: '20');
  final TextEditingController _cestosActiveController = TextEditingController(text: '18');

  // Quantidades de Carrinhos
  final TextEditingController _carrinhosTotalController = TextEditingController(text: '28');
  final TextEditingController _carrinhosActiveController = TextEditingController(text: '25');

  // Parâmetros operacionais
  final TextEditingController _minAlertController = TextEditingController(text: '25');
  final TextEditingController _toleranceController = TextEditingController(text: '15');

  String _selectedUnit = 'Unidade 7 - Supermercado Central';

  bool _cestoSelected = true;
  bool _carrinhoSelected = true;

  // Imagem da planta da estação
  String? _floorPlanFileName;
  Uint8List? _floorPlanBytes;

  static const List<String> _units = [
    'Unidade 7 - Supermercado Central',
    'Unidade 3 - Filial Zona Sul',
    'Unidade 12 - Filial Norte',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _sectorController.dispose();
    _cestosTotalController.dispose();
    _cestosActiveController.dispose();
    _carrinhosTotalController.dispose();
    _carrinhosActiveController.dispose();
    _minAlertController.dispose();
    _toleranceController.dispose();
    super.dispose();
  }

  int get _cestosTotal => _cestoSelected ? (int.tryParse(_cestosTotalController.text) ?? 0) : 0;
  int get _cestosActive => _cestoSelected ? (int.tryParse(_cestosActiveController.text) ?? 0) : 0;

  int get _carrinhosTotal => _carrinhoSelected ? (int.tryParse(_carrinhosTotalController.text) ?? 0) : 0;
  int get _carrinhosActive => _carrinhoSelected ? (int.tryParse(_carrinhosActiveController.text) ?? 0) : 0;

  int get _totalStationCapacity => _cestosTotal + _carrinhosTotal;
  int get _totalActiveEquipment => _cestosActive + _carrinhosActive;

  Future<void> _selectFloorPlanImage() async {
    final picked = await pickFloorPlanImage();
    if (picked != null && mounted) {
      setState(() {
        _floorPlanFileName = picked.name;
        _floorPlanBytes = picked.bytes;
      });
    }
  }

  void _saveStation() {
    if (!_cestoSelected && !_carrinhoSelected) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppTheme.warning, size: 54),
              const SizedBox(height: 14),
              const Text(
                'Selecione um Equipamento',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'A estação precisa ter pelo menos um tipo de equipamento habilitado (Cesto ou Carrinho).',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.warning),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Entendi'),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    final stationName = _nameController.text.trim().isEmpty
        ? 'Estação ${MockDB.stations.length + 1} - Nova Área'
        : _nameController.text.trim();
    final sectorSubtitle = _sectorController.text.trim().isEmpty
        ? 'Equipamentos do local'
        : _sectorController.text.trim();

    final occupancyPct = _totalStationCapacity > 0
        ? ((_totalActiveEquipment / _totalStationCapacity) * 100).round().clamp(0, 100)
        : 85;

    MockDB.addStation({
      'name': stationName,
      'sector': sectorSubtitle,
      'status': occupancyPct <= 30 ? 'critical' : (occupancyPct <= 55 ? 'alert' : 'stable'),
      'percentage': occupancyPct,
      'hasCestos': _cestoSelected,
      'hasCarrinhos': _carrinhoSelected,
      'cestosTotal': _cestosTotal,
      'cestosActive': _cestosActive,
      'cestosMaintenance': 0,
      'carrinhosTotal': _carrinhosTotal,
      'carrinhosActive': _carrinhosActive,
      'carrinhosMaintenance': 0,
      'minAlertPercentage': int.tryParse(_minAlertController.text) ?? 25,
      'toleranceMinutes': int.tryParse(_toleranceController.text) ?? 15,
      'floorPlanFileName': _floorPlanFileName,
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppTheme.success, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Estação Cadastrada!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'A "$stationName" foi configurada com capacidade para $_totalStationCapacity equipamentos ($_totalActiveEquipment ativos) na $_selectedUnit.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                onPressed: () {
                  Navigator.pop(context); // fecha dialog
                  Navigator.pop(context); // volta para lista
                },
                child: const Text('Continuar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.storefront_outlined, color: AppTheme.primary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nova Estação de Retirada',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Preencha os dados de localização, planta da estação e frota de equipamentos',
                          style: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.8), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: AppTheme.textSecondary.withValues(alpha: 0.12)),
              const SizedBox(height: 16),

              // ==========================================
              // SEÇÃO 1: IDENTIFICAÇÃO E PLANTA DA ESTAÇÃO
              // ==========================================
              _buildSectionHeader(Icons.location_on_outlined, '1. Identificação e Localização'),
              const SizedBox(height: 14),

              _buildLabel('Unidade Vinculada:'),
              _buildDropdown(
                value: _selectedUnit,
                items: _units,
                icon: Icons.business_outlined,
                onChanged: (val) => setState(() => _selectedUnit = val!),
              ),
              const SizedBox(height: 14),

              _buildLabel('Nome da Estação:'),
              _buildTextField(
                controller: _nameController,
                hint: 'Ex: Estação 5 - Açougue',
                prefixIcon: Icons.badge_outlined,
              ),
              const SizedBox(height: 14),

              _buildLabel('Setor / Subtítulo do Local:'),
              _buildTextField(
                controller: _sectorController,
                hint: 'Ex: Carnes, Frios e Congelados',
                prefixIcon: Icons.store_mall_directory_outlined,
              ),
              const SizedBox(height: 14),

              _buildLabel('Planta da Estação (Imagem do Mapa):'),
              _buildFloorPlanImageField(),

              const SizedBox(height: 24),
              Divider(color: AppTheme.textSecondary.withValues(alpha: 0.12)),
              const SizedBox(height: 16),

              // ==========================================
              // SEÇÃO 2: EQUIPAMENTOS E QUANTIDADES
              // ==========================================
              _buildSectionHeader(Icons.shopping_cart_outlined, '2. Equipamentos e Capacidade da Estação'),
              const SizedBox(height: 6),
              const Text(
                'Selecione os tipos de equipamento disponíveis nesta estação e defina a quantidade:',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _buildEquipmentToggleCard(
                      label: 'Cestos',
                      subtitle: 'Cestos de mão/rodinha',
                      icon: Icons.shopping_basket_outlined,
                      isSelected: _cestoSelected,
                      onTap: () => setState(() => _cestoSelected = !_cestoSelected),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildEquipmentToggleCard(
                      label: 'Carrinhos',
                      subtitle: 'Carrinhos de compras',
                      icon: Icons.shopping_cart_outlined,
                      isSelected: _carrinhoSelected,
                      onTap: () => setState(() => _carrinhoSelected = !_carrinhoSelected),
                    ),
                  ),
                ],
              ),

              if (_cestoSelected) ...[
                const SizedBox(height: 16),
                _buildEquipmentConfigBox(
                  title: 'Configuração de Cestos',
                  icon: Icons.shopping_basket_outlined,
                  totalController: _cestosTotalController,
                  activeController: _cestosActiveController,
                ),
              ],

              if (_carrinhoSelected) ...[
                const SizedBox(height: 14),
                _buildEquipmentConfigBox(
                  title: 'Configuração de Carrinhos',
                  icon: Icons.shopping_cart_outlined,
                  totalController: _carrinhosTotalController,
                  activeController: _carrinhosActiveController,
                ),
              ],

              const SizedBox(height: 14),
              // Resumo consolidado da capacidade da estação
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Capacidade Máxima da Estação',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Soma automática de cestos e carrinhos',
                          style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$_totalStationCapacity un.',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary),
                        ),
                        Text(
                          '$_totalActiveEquipment ativos',
                          style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Divider(color: AppTheme.textSecondary.withValues(alpha: 0.12)),
              const SizedBox(height: 16),

              // ==========================================
              // SEÇÃO 3: PARÂMETROS DE MONITORAMENTO
              // ==========================================
              _buildSectionHeader(Icons.analytics_outlined, '3. Parâmetros de Monitoramento'),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Alerta de Reposição (%):'),
                        _buildTextField(
                          controller: _minAlertController,
                          hint: 'Ex: 25',
                          isNumeric: true,
                          suffixText: '% mín.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Tolerância de Abandono:'),
                        _buildTextField(
                          controller: _toleranceController,
                          hint: 'Ex: 15',
                          isNumeric: true,
                          suffixText: 'min',
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveStation,
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

  Widget _buildFloorPlanImageField() {
    final hasImage = _floorPlanFileName != null;

    return GestureDetector(
      onTap: _selectFloorPlanImage,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasImage
                ? AppTheme.primary.withValues(alpha: 0.45)
                : AppTheme.textSecondary.withValues(alpha: 0.2),
          ),
        ),
        child: hasImage
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_floorPlanBytes != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        _floorPlanBytes!,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.image_outlined, color: AppTheme.primary, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _floorPlanFileName!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Planta da estação anexada • Toque para alterar',
                              style: TextStyle(fontSize: 10, color: AppTheme.success),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Remover imagem',
                        icon: const Icon(Icons.delete_outline, color: AppTheme.error, size: 18),
                        onPressed: () {
                          setState(() {
                            _floorPlanFileName = null;
                            _floorPlanBytes = null;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_photo_alternate_outlined, color: AppTheme.primary, size: 26),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Clique para enviar a imagem da planta da estação',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Formatos suportados: PNG, JPG ou SVG',
                    style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
    bool isNumeric = false,
    String? suffixText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.45), fontSize: 13),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18, color: AppTheme.textSecondary) : null,
        suffixText: suffixText,
        suffixStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
        filled: true,
        fillColor: AppTheme.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppTheme.surface,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
          style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(icon, size: 16, color: AppTheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildEquipmentToggleCard({
    required String label,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.14) : AppTheme.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.white.withValues(alpha: 0.08),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 14, color: isSelected ? AppTheme.primary : AppTheme.textPrimary),
                      const SizedBox(width: 5),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentConfigBox({
    required String title,
    required IconData icon,
    required TextEditingController totalController,
    required TextEditingController activeController,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 15, color: AppTheme.primary),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              children: [
                // Coluna 1: Total Disponível (delimitada em card próprio)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.primary.withValues(alpha: 0.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.inventory_2_outlined, size: 12, color: AppTheme.primary.withValues(alpha: 0.9)),
                            const SizedBox(width: 5),
                            const Text(
                              'Total Disponível',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildDelimitedMetricInput(
                          controller: totalController,
                          hint: '20',
                          accentColor: AppTheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Divisória vertical sutil entre os dois blocos
                VerticalDivider(
                  color: Colors.white.withValues(alpha: 0.10),
                  width: 4,
                  thickness: 1,
                ),
                const SizedBox(width: 10),
                // Coluna 2: Ativos (delimitada em card próprio)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.success.withValues(alpha: 0.28)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.circle, size: 8, color: AppTheme.success),
                            SizedBox(width: 5),
                            Text(
                              'Ativos',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildDelimitedMetricInput(
                          controller: activeController,
                          hint: '18',
                          accentColor: AppTheme.success,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDelimitedMetricInput({
    required TextEditingController controller,
    required String hint,
    required Color accentColor,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.45), fontSize: 14),
        suffixIcon: Container(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'un.',
            style: TextStyle(
              color: accentColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: AppTheme.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: accentColor, width: 1.4),
        ),
      ),
    );
  }
}
