import 'package:flutter/material.dart';
import '../core/theme.dart';

class EmployeeMapScreen extends StatelessWidget {
  const EmployeeMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D1A),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        title: const Text(
          'Mapa de Carrinhos',
          style: TextStyle(
            fontSize: 18,
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
                                  'lib/assets/icons/mapa_planta.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // 1. Ponto Vermelho (Superior Esquerdo)
                              Positioned(
                                left: w * 0.12 - 16,
                                top: h * 0.065 - 16,
                                child: const _MapCartMarker(
                                  dotColor: AppTheme.error,
                                  title: 'Carrinho #12',
                                  code: 'CR012',
                                  status: 'Fora da Estação',
                                  statusColor: AppTheme.error,
                                  location: 'Hortifrúti • Maçãs',
                                  time: 'Parado há 18 min',
                                  battery: 'Bateria em 84%',
                                ),
                              ),
                              // 2. Ponto Amarelo com Avaria (Superior Direito)
                              Positioned(
                                left: w * 0.81 - 16,
                                top: h * 0.145 - 16,
                                child: const _MapCartMarker(
                                  dotColor: AppTheme.warning,
                                  title: 'Carrinho #07',
                                  code: 'CR007',
                                  status: 'Avaria Relatada',
                                  statusColor: AppTheme.warning,
                                  location: 'Hortifrúti • Temperos',
                                  time: 'Parado há 34 min',
                                  defect: 'Roda dianteira travada',
                                ),
                              ),
                              // 3. Ponto Vermelho (Centro Direito)
                              Positioned(
                                left: w * 0.745 - 16,
                                top: h * 0.485 - 16,
                                child: const _MapCartMarker(
                                  dotColor: AppTheme.error,
                                  title: 'Carrinho #19',
                                  code: 'CR019',
                                  status: 'Fora da Estação',
                                  statusColor: AppTheme.error,
                                  location: 'Hortifrúti • Balcão',
                                  time: 'Parado há 9 min',
                                  battery: 'Bateria em 95%',
                                ),
                              ),
                              // 4. Ponto Vermelho (Inferior Esquerdo)
                              Positioned(
                                left: w * 0.26 - 16,
                                top: h * 0.705 - 16,
                                child: const _MapCartMarker(
                                  dotColor: AppTheme.error,
                                  title: 'Carrinho #25',
                                  code: 'CR025',
                                  status: 'Fora da Estação',
                                  statusColor: AppTheme.error,
                                  location: 'Hortifrúti • Verduras',
                                  time: 'Parado há 27 min',
                                  battery: 'Bateria em 61%',
                                ),
                              ),
                              // 5. Ponto Vermelho (Inferior Direito)
                              Positioned(
                                left: w * 0.835 - 16,
                                top: h * 0.92 - 16,
                                child: const _MapCartMarker(
                                  dotColor: AppTheme.error,
                                  title: 'Carrinho #31',
                                  code: 'CR031',
                                  status: 'Fora da Estação',
                                  statusColor: AppTheme.error,
                                  location: 'Hortifrúti • Saída',
                                  time: 'Parado há 12 min',
                                  battery: 'Bateria em 88%',
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
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '6 Carrinhos fora das estações',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
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

class _MapCartMarker extends StatelessWidget {
  final Color dotColor;
  final String title;
  final String code;
  final String status;
  final Color statusColor;
  final String location;
  final String time;
  final String? defect;
  final String? battery;

  const _MapCartMarker({
    required this.dotColor,
    required this.title,
    required this.code,
    required this.status,
    required this.statusColor,
    required this.location,
    required this.time,
    this.defect,
    this.battery,
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
              if (defect != null)
                _row(Icons.warning_amber_rounded, defect!, AppTheme.warning)
              else if (battery != null)
                _row(Icons.battery_charging_full_rounded, battery!, AppTheme.success),
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
