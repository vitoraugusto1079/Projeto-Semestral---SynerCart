import 'package:flutter/material.dart';
import '../core/theme.dart';

class ManagerMapScreen extends StatelessWidget {
  const ManagerMapScreen({super.key});

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
                                left: w * 0.12 - 9,
                                top: h * 0.065 - 9,
                                child: const _MapDot(color: AppTheme.error),
                              ),
                              // 2. Ponto Amarelo com Avaria (Superior Direito)
                              Positioned(
                                left: w * 0.81 - 9,
                                top: h * 0.145 - 9,
                                child: const _MapDot(color: AppTheme.warning),
                              ),
                              // 3. Ponto Vermelho (Centro Direito)
                              Positioned(
                                left: w * 0.745 - 9,
                                top: h * 0.485 - 9,
                                child: const _MapDot(color: AppTheme.error),
                              ),
                              // 4. Ponto Vermelho (Inferior Esquerdo)
                              Positioned(
                                left: w * 0.26 - 9,
                                top: h * 0.705 - 9,
                                child: const _MapDot(color: AppTheme.error),
                              ),
                              // 5. Ponto Vermelho (Inferior Direito)
                              Positioned(
                                left: w * 0.835 - 9,
                                top: h * 0.92 - 9,
                                child: const _MapDot(color: AppTheme.error),
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

            // Linha 1 de Status: 6 Carrinhos fora + 1 Carrinho com avaria
            Row(
              children: [
                Expanded(
                  child: _MapInfoCard(
                    icon: Icons.warning_amber_rounded,
                    iconColor: const Color(0xFFEF4444),
                    iconBgColor: const Color(0xFFEF4444).withValues(alpha: 0.18),
                    title: '6 Carrinhos fora\ndas estações',
                    subtitle: 'Espalhados nos\ncorredores de venda',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MapInfoCard(
                    icon: Icons.warning_amber_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    iconBgColor: const Color(0xFFF59E0B).withValues(alpha: 0.18),
                    title: '1 Carrinho com\navaria',
                    subtitle: 'Espalhado no corredor\nde venda',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Linha 2 de Status: Funcionários ativos (na coluna da esquerda como no mockup)
            Row(
              children: [
                Expanded(
                  child: _MapInfoCard(
                    icon: Icons.person,
                    iconColor: const Color(0xFF3B82F6),
                    iconBgColor: const Color(0xFF3B82F6).withValues(alpha: 0.18),
                    title: 'Funcionários\nativos: 40',
                    subtitle: '6 funcionários com\ncargo para função',
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
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

class _MapInfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;

  const _MapInfoCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF8B949E),
                    fontSize: 10,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
