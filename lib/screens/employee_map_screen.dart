import 'package:flutter/material.dart';
import '../core/theme.dart';

class EmployeeMapScreen extends StatefulWidget {
  const EmployeeMapScreen({super.key});

  @override
  State<EmployeeMapScreen> createState() => _EmployeeMapScreenState();
}

class _EmployeeMapScreenState extends State<EmployeeMapScreen> {
  String _selectedStationKey = 'hortifruti';

  static const Map<String, _StationMapData> _stations = {
    'entrada': _StationMapData(
      key: 'entrada',
      name: 'Estação 1 - Entrada',
      sectorSubtitle: 'Acesso ao Supermercado',
      imageAsset: 'lib/assets/icons/mapa_entrada.png',
      outOfStationTitle: '3 Carrinhos fora das estações',
      markers: [
        _MarkerData(
          xFactor: 0.48,
          yFactor: 0.22,
          dotColor: AppTheme.error,
          title: 'Carrinho #02',
          code: 'CR002',
          status: 'Fora da Estação',
          statusColor: AppTheme.error,
          location: 'Entrada • Catracas',
          time: 'Parado há 11 min',
        ),
        _MarkerData(
          xFactor: 0.64,
          yFactor: 0.38,
          dotColor: AppTheme.error,
          title: 'Carrinho #05',
          code: 'CR005',
          status: 'Fora da Estação',
          statusColor: AppTheme.error,
          location: 'Entrada • Atendimento',
          time: 'Parado há 15 min',
        ),
        _MarkerData(
          xFactor: 0.28,
          yFactor: 0.82,
          dotColor: AppTheme.warning,
          title: 'Carrinho #09',
          code: 'CR009',
          status: 'Avaria Relatada',
          statusColor: AppTheme.warning,
          location: 'Entrada • Baia Principal',
          time: 'Parado há 29 min',
          defect: 'Grade lateral amassada',
        ),
        _MarkerData(
          xFactor: 0.62,
          yFactor: 0.74,
          dotColor: AppTheme.error,
          title: 'Carrinho #14',
          code: 'CR014',
          status: 'Fora da Estação',
          statusColor: AppTheme.error,
          location: 'Entrada • Cestos',
          time: 'Parado há 7 min',
        ),
      ],
    ),
    'saida': _StationMapData(
      key: 'saida',
      name: 'Estação 2 - Saída',
      sectorSubtitle: 'Caixas e Pagamento',
      imageAsset: 'lib/assets/icons/mapa_saida.png',
      outOfStationTitle: '4 Carrinhos fora das estações',
      markers: [
        _MarkerData(
          xFactor: 0.36,
          yFactor: 0.44,
          dotColor: AppTheme.error,
          title: 'Carrinho #04',
          code: 'CR004',
          status: 'Fora da Estação',
          statusColor: AppTheme.error,
          location: 'Saída • Caixa 01',
          time: 'Parado há 14 min',
        ),
        _MarkerData(
          xFactor: 0.60,
          yFactor: 0.46,
          dotColor: AppTheme.error,
          title: 'Carrinho #11',
          code: 'CR011',
          status: 'Fora da Estação',
          statusColor: AppTheme.error,
          location: 'Saída • Caixa 02',
          time: 'Parado há 8 min',
        ),
        _MarkerData(
          xFactor: 0.78,
          yFactor: 0.56,
          dotColor: AppTheme.warning,
          title: 'Carrinho #16',
          code: 'CR016',
          status: 'Avaria Relatada',
          statusColor: AppTheme.warning,
          location: 'Saída • Caixa 03',
          time: 'Parado há 41 min',
          defect: 'Alça de apoio solta',
        ),
        _MarkerData(
          xFactor: 0.24,
          yFactor: 0.75,
          dotColor: AppTheme.error,
          title: 'Carrinho #22',
          code: 'CR022',
          status: 'Fora da Estação',
          statusColor: AppTheme.error,
          location: 'Saída • Corredor Sul',
          time: 'Parado há 19 min',
        ),
        _MarkerData(
          xFactor: 0.50,
          yFactor: 0.84,
          dotColor: AppTheme.error,
          title: 'Carrinho #28',
          code: 'CR028',
          status: 'Fora da Estação',
          statusColor: AppTheme.error,
          location: 'Saída • Portas',
          time: 'Parado há 6 min',
        ),
      ],
    ),
    'hortifruti': _StationMapData(
      key: 'hortifruti',
      name: 'Estação 3 - Hortifrúti',
      sectorSubtitle: 'Frutas e Verduras',
      imageAsset: 'lib/assets/icons/mapa_planta.png',
      outOfStationTitle: '6 Carrinhos fora das estações',
      markers: [
        _MarkerData(
          xFactor: 0.12,
          yFactor: 0.065,
          dotColor: AppTheme.error,
          title: 'Carrinho #12',
          code: 'CR012',
          status: 'Fora da Estação',
          statusColor: AppTheme.error,
          location: 'Hortifrúti • Maçãs',
          time: 'Parado há 18 min',
        ),
        _MarkerData(
          xFactor: 0.81,
          yFactor: 0.145,
          dotColor: AppTheme.warning,
          title: 'Carrinho #07',
          code: 'CR007',
          status: 'Avaria Relatada',
          statusColor: AppTheme.warning,
          location: 'Hortifrúti • Temperos',
          time: 'Parado há 34 min',
          defect: 'Roda dianteira travada',
        ),
        _MarkerData(
          xFactor: 0.745,
          yFactor: 0.485,
          dotColor: AppTheme.error,
          title: 'Carrinho #19',
          code: 'CR019',
          status: 'Fora da Estação',
          statusColor: AppTheme.error,
          location: 'Hortifrúti • Balcão',
          time: 'Parado há 9 min',
        ),
        _MarkerData(
          xFactor: 0.26,
          yFactor: 0.705,
          dotColor: AppTheme.error,
          title: 'Carrinho #25',
          code: 'CR025',
          status: 'Fora da Estação',
          statusColor: AppTheme.error,
          location: 'Hortifrúti • Verduras',
          time: 'Parado há 27 min',
        ),
        _MarkerData(
          xFactor: 0.835,
          yFactor: 0.92,
          dotColor: AppTheme.error,
          title: 'Carrinho #31',
          code: 'CR031',
          status: 'Fora da Estação',
          statusColor: AppTheme.error,
          location: 'Hortifrúti • Saída',
          time: 'Parado há 12 min',
        ),
      ],
    ),
    'padaria': _StationMapData(
      key: 'padaria',
      name: 'Estação 4 - Padaria',
      sectorSubtitle: 'Pães e Confeitaria',
      imageAsset: 'lib/assets/icons/mapa_padaria.png',
      outOfStationTitle: '3 Carrinhos fora das estações',
      markers: [
        _MarkerData(
          xFactor: 0.28,
          yFactor: 0.18,
          dotColor: AppTheme.error,
          title: 'Carrinho #03',
          code: 'CR003',
          status: 'Fora da Estação',
          statusColor: AppTheme.error,
          location: 'Padaria • Baguetes',
          time: 'Parado há 16 min',
        ),
        _MarkerData(
          xFactor: 0.67,
          yFactor: 0.32,
          dotColor: AppTheme.error,
          title: 'Carrinho #08',
          code: 'CR008',
          status: 'Fora da Estação',
          statusColor: AppTheme.error,
          location: 'Padaria • Confeitaria',
          time: 'Parado há 22 min',
        ),
        _MarkerData(
          xFactor: 0.28,
          yFactor: 0.52,
          dotColor: AppTheme.warning,
          title: 'Carrinho #15',
          code: 'CR015',
          status: 'Avaria Relatada',
          statusColor: AppTheme.warning,
          location: 'Padaria • Pães Caseiros',
          time: 'Parado há 38 min',
          defect: 'Rodízio traseiro travando',
        ),
        _MarkerData(
          xFactor: 0.66,
          yFactor: 0.72,
          dotColor: AppTheme.error,
          title: 'Carrinho #21',
          code: 'CR021',
          status: 'Fora da Estação',
          statusColor: AppTheme.error,
          location: 'Padaria • Bolos',
          time: 'Parado há 10 min',
        ),
      ],
    ),
  };

  @override
  Widget build(BuildContext context) {
    final currentStation = _stations[_selectedStationKey] ?? _stations['hortifruti']!;

    return Scaffold(
      backgroundColor: const Color(0xFF090D1A),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: const Text(
          'Mapa de Carrinhos',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: Color(0xFFEF4444), size: 6),
                SizedBox(width: 5),
                Text(
                  'AO VIVO',
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Column(
          children: [
            // Seletor de Estação
            Theme(
              data: Theme.of(context).copyWith(
                popupMenuTheme: const PopupMenuThemeData(
                  color: Color(0xFF1E293B),
                ),
              ),
              child: PopupMenuButton<String>(
                color: const Color(0xFF1E293B),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
                ),
                offset: const Offset(0, 54),
                tooltip: 'Selecionar estação',
                onSelected: (stationKey) {
                  setState(() {
                    _selectedStationKey = stationKey;
                  });
                },
                itemBuilder: (context) {
                  return _stations.entries.map((entry) {
                    final isSelected = entry.key == _selectedStationKey;
                    return PopupMenuItem<String>(
                      value: entry.key,
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.check_circle_rounded : Icons.location_on_outlined,
                            size: 16,
                            color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  entry.value.name,
                                  style: TextStyle(
                                    color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  entry.value.sectorSubtitle,
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.primary.withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.location_on_outlined, color: AppTheme.primary, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentStation.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              currentStation.sectorSubtitle,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Trocar estação',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.textPrimary, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Planta Baixa Centralizada com AspectRatio e Zoom
            Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: 380,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AspectRatio(
                    aspectRatio: 1076 / 1462,
                    child: InteractiveViewer(
                      key: ValueKey(currentStation.key),
                      maxScale: 4.0,
                      minScale: 1.0,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final w = constraints.maxWidth;
                          final h = constraints.maxHeight;
                          return Stack(
                            children: [
                              // Imagem Real da Planta em Cores
                              Positioned.fill(
                                child: Image.asset(
                                  currentStation.imageAsset,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              for (final marker in currentStation.markers)
                                Positioned(
                                  left: w * marker.xFactor - 16,
                                  top: h * marker.yFactor - 16,
                                  child: _MapCartMarker(
                                    dotColor: marker.dotColor,
                                    title: marker.title,
                                    code: marker.code,
                                    status: marker.status,
                                    statusColor: marker.statusColor,
                                    location: marker.location,
                                    time: marker.time,
                                    defect: marker.defect,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Card "Atribuir Recolhimento" (Exclusivo do funcionário)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.error.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.warning_amber_rounded, color: AppTheme.error, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentStation.outOfStationTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Espalhados nos corredores de venda',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: const Color(0xFF1E293B),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            contentPadding: const EdgeInsets.all(24),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle, color: AppTheme.success, size: 60),
                                const SizedBox(height: 16),
                                const Text(
                                  'Tudo Certo!',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'O recolhimento foi atribuído à sua rota com sucesso.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Continuar'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Atribuir Recolhimento',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StationMapData {
  final String key;
  final String name;
  final String sectorSubtitle;
  final String imageAsset;
  final String outOfStationTitle;
  final List<_MarkerData> markers;

  const _StationMapData({
    required this.key,
    required this.name,
    required this.sectorSubtitle,
    required this.imageAsset,
    required this.outOfStationTitle,
    required this.markers,
  });
}

class _MarkerData {
  final double xFactor;
  final double yFactor;
  final Color dotColor;
  final String title;
  final String code;
  final String status;
  final Color statusColor;
  final String location;
  final String time;
  final String? defect;

  const _MarkerData({
    required this.xFactor,
    required this.yFactor,
    required this.dotColor,
    required this.title,
    required this.code,
    required this.status,
    required this.statusColor,
    required this.location,
    required this.time,
    this.defect,
  });
}

class _MapCartMarker extends StatelessWidget {
  final Color dotColor;
  final String title;
  final String code;
  final String status;
  final Color statusColor;
  final String location;
  final String time;
  final String? defect;

  const _MapCartMarker({
    required this.dotColor,
    required this.title,
    required this.code,
    required this.status,
    required this.statusColor,
    required this.location,
    required this.time,
    this.defect,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      waitDuration: const Duration(milliseconds: 50),
      showDuration: const Duration(seconds: 4),
      triggerMode: TooltipTriggerMode.tap,
      verticalOffset: 16,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      richMessage: WidgetSpan(
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shopping_cart_outlined, size: 15, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      code,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.08),
              ),
              const SizedBox(height: 8),
              _row(Icons.place_outlined, location, const Color(0xFF94A3B8)),
              const SizedBox(height: 4),
              _row(Icons.timer_outlined, time, const Color(0xFF94A3B8)),
              const SizedBox(height: 4),
              if (defect != null && defect!.isNotEmpty)
                _row(Icons.warning_amber_rounded, 'Com avaria: $defect', AppTheme.warning)
              else
                _row(Icons.check_circle_outline, 'Sem avarias', AppTheme.success),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.circle, color: statusColor, size: 7),
                  const SizedBox(width: 6),
                  Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 32,
          height: 32,
          color: Colors.transparent,
          alignment: Alignment.center,
          child: _MapDot(color: dotColor),
        ),
      ),
    );
  }

  Widget _row(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _MapDot extends StatelessWidget {
  final Color color;

  const _MapDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.28),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.7),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
