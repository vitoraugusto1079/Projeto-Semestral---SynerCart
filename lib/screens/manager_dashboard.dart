import 'package:flutter/material.dart';
import '../core/theme.dart';

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.shopping_cart, color: AppTheme.primary, size: 32),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Unidade 7',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Quarta, 23 de agosto de 2026',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: AppTheme.textPrimary),
                SizedBox(width: 6),
                Text('Hoje', style: TextStyle(fontSize: 14, color: AppTheme.textPrimary)),
                Icon(Icons.arrow_drop_down, color: AppTheme.textPrimary),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card Gráfico (Uso por Horário)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Uso de Carrinhos por Horário', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      // Pílula Pico
                      _StatusPill(text: 'Pico às 18h00', color: AppTheme.primary),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Monitoramento de fluxo ativo na loja', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  const SizedBox(height: 16),
                  const _HourlyUsageChart(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Card Total Movimentado
            _MetricCard(
              title: 'Total Movimentado',
              subtitle: 'Ciclos completos de carrinhos hoje',
              value: '347',
              pillText: '+12%',
              pillColor: AppTheme.success,
            ),
            const SizedBox(height: 16),

            // Card Tempo Médio
            _MetricCard(
              title: 'Tempo Médio de Reposição',
              subtitle: 'Tempo para retornar carrinhos às estações',
              value: '4m 30s',
              pillText: 'Atenção',
              pillColor: AppTheme.warning,
            ),
            const SizedBox(height: 16),

            // Card Tarefas Críticas
            _MetricCard(
              title: 'Tarefas Críticas Hoje',
              subtitle: 'Abandono fora da zona de tolerância',
              value: '12',
              pillText: 'Crítico',
              pillColor: AppTheme.error,
            ),
          ],
        ),
      ),
// bottomNavigationBar removido para o Wrapper
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final String pillText;
  final Color pillColor;

  const _MetricCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.pillText,
    required this.pillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              _StatusPill(text: pillText, color: pillColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusPill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (text.contains('%') || text == 'Pico às 18h00') // Lógica simples para os ícones
            Icon(
              text.contains('%') ? Icons.trending_up : Icons.circle, 
              size: 12, 
              color: color
            )
          else
            Icon(Icons.warning_amber_rounded, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _HourlyUsageChart extends StatelessWidget {
  const _HourlyUsageChart();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 130,
          width: double.infinity,
          child: CustomPaint(
            painter: _ChartPainter(),
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('6h', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
            Text('10h', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
            Text('14h', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
            Text('18h', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
            Text('22h', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 8.0;
    const rightPad = 8.0;
    const topPad = 18.0;
    const bottomPad = 8.0;

    final usableWidth = size.width - leftPad - rightPad;
    final usableHeight = size.height - topPad - bottomPad;

    // Normalizado de 0 a 1 (0 é a base, 1 é o pico)
    // 6h: 20%, 10h: 48%, 14h: 55%, 18h: 94% (Pico), 22h: 28%
    final normalizedPoints = [0.20, 0.48, 0.55, 0.94, 0.28];
    final stepX = usableWidth / (normalizedPoints.length - 1);

    final points = List.generate(normalizedPoints.length, (i) {
      final x = leftPad + (i * stepX);
      final y = size.height - bottomPad - (normalizedPoints[i] * usableHeight);
      return Offset(x, y);
    });

    final baselineY = size.height - bottomPad;

    // 1. Linhas horizontais de grade
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1.0;

    for (int i = 1; i <= 3; i++) {
      final gy = topPad + (usableHeight * (i / 4));
      canvas.drawLine(Offset(0, gy), Offset(size.width, gy), gridPaint);
    }

    // 2. Linha base horizontal
    final baseLinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0, baselineY), Offset(size.width, baselineY), baseLinePaint);

    // 3. Linha guia pontilhada vertical no pico (18h)
    final peakPoint = points[3];
    final dashPaint = Paint()
      ..color = const Color(0xFF3B82F6).withValues(alpha: 0.35)
      ..strokeWidth = 1.2;

    double dashY = peakPoint.dy;
    while (dashY < baselineY) {
      canvas.drawLine(
        Offset(peakPoint.dx, dashY),
        Offset(peakPoint.dx, (dashY + 4).clamp(peakPoint.dy, baselineY)),
        dashPaint,
      );
      dashY += 8;
    }

    // 4. Área de gradiente sob a curva
    final areaPath = Path();
    areaPath.moveTo(points.first.dx, baselineY);
    areaPath.lineTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cp1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final cp2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      areaPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
    }

    areaPath.lineTo(points.last.dx, baselineY);
    areaPath.close();

    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF3B82F6).withValues(alpha: 0.32),
          const Color(0xFF3B82F6).withValues(alpha: 0.08),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, topPad, size.width, usableHeight + bottomPad));

    canvas.drawPath(areaPath, areaPaint);

    // 5. Linha de dados com curva suave
    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cp1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final cp2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      linePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
    }

    final linePaint = Paint()
      ..color = const Color(0xFF3B82F6)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, linePaint);

    // 6. Pontos de dados (Nodes) com destaque no pico das 18h
    for (int i = 0; i < points.length; i++) {
      final pt = points[i];
      if (i == 3) {
        // Halo de brilho externo
        canvas.drawCircle(
          pt,
          10,
          Paint()..color = const Color(0xFF3B82F6).withValues(alpha: 0.25),
        );
        // Anel azul
        canvas.drawCircle(
          pt,
          6,
          Paint()..color = const Color(0xFF3B82F6),
        );
        // Centro branco vivo
        canvas.drawCircle(
          pt,
          3,
          Paint()..color = Colors.white,
        );
      } else {
        // Pontos normais
        canvas.drawCircle(
          pt,
          4,
          Paint()..color = const Color(0xFF161B22),
        );
        canvas.drawCircle(
          pt,
          2.5,
          Paint()..color = const Color(0xFF3B82F6),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

