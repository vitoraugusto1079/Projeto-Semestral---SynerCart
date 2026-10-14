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
