import 'package:flutter/material.dart';
import '../core/theme.dart';

class ManagerDashboard extends StatefulWidget {
  const ManagerDashboard({super.key});

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  String _selectedDayKey = 'qua';

  final Map<String, _DayDashboardData> _daysData = const {
    'seg': _DayDashboardData(
      key: 'seg',
      menuLabel: 'Segunda-feira',
      buttonLabel: 'Segunda',
      dateDescription: 'Segunda, 18 de agosto de 2026',
      peakLabel: 'Pico às 17h30',
      peakIndex: 3,
      chartPoints: [0.15, 0.42, 0.60, 0.85, 0.20],
      totalMovimentado: '312',
      totalSubtitle: 'Ciclos completos de carrinhos na segunda',
      totalPillText: '+8%',
      totalPillColor: AppTheme.success,
      tempoMedio: '4m 10s',
      tempoPillText: 'Normal',
      tempoPillColor: AppTheme.success,
      tarefasCriticas: '8',
      tarefasPillText: 'Moderado',
      tarefasPillColor: AppTheme.warning,
      isToday: false,
    ),
    'ter': _DayDashboardData(
      key: 'ter',
      menuLabel: 'Terça-feira',
      buttonLabel: 'Terça',
      dateDescription: 'Terça, 19 de agosto de 2026',
      peakLabel: 'Pico às 18h15',
      peakIndex: 3,
      chartPoints: [0.18, 0.45, 0.52, 0.88, 0.22],
      totalMovimentado: '328',
      totalSubtitle: 'Ciclos completos de carrinhos na terça',
      totalPillText: '+10%',
      totalPillColor: AppTheme.success,
      tempoMedio: '4m 20s',
      tempoPillText: 'Normal',
      tempoPillColor: AppTheme.success,
      tarefasCriticas: '9',
      tarefasPillText: 'Moderado',
      tarefasPillColor: AppTheme.warning,
      isToday: false,
    ),
    'qua': _DayDashboardData(
      key: 'qua',
      menuLabel: 'Quarta-feira (Hoje)',
      buttonLabel: 'Hoje',
      dateDescription: 'Quarta, 23 de agosto de 2026',
      peakLabel: 'Pico às 18h00',
      peakIndex: 3,
      chartPoints: [0.20, 0.48, 0.55, 0.94, 0.28],
      totalMovimentado: '347',
      totalSubtitle: 'Ciclos completos de carrinhos hoje',
      totalPillText: '+12%',
      totalPillColor: AppTheme.success,
      tempoMedio: '4m 30s',
      tempoPillText: 'Atenção',
      tempoPillColor: AppTheme.warning,
      tarefasCriticas: '12',
      tarefasPillText: 'Crítico',
      tarefasPillColor: AppTheme.error,
      isToday: true,
    ),
    'qui': _DayDashboardData(
      key: 'qui',
      menuLabel: 'Quinta-feira',
      buttonLabel: 'Quinta',
      dateDescription: 'Quinta, 24 de agosto de 2026',
      peakLabel: 'Pico às 18h30',
      peakIndex: 3,
      chartPoints: [0.22, 0.50, 0.58, 0.91, 0.32],
      totalMovimentado: '365',
      totalSubtitle: 'Ciclos completos de carrinhos na quinta',
      totalPillText: '+15%',
      totalPillColor: AppTheme.success,
      tempoMedio: '4m 45s',
      tempoPillText: 'Atenção',
      tempoPillColor: AppTheme.warning,
      tarefasCriticas: '14',
      tarefasPillText: 'Crítico',
      tarefasPillColor: AppTheme.error,
      isToday: false,
    ),
    'sex': _DayDashboardData(
      key: 'sex',
      menuLabel: 'Sexta-feira',
      buttonLabel: 'Sexta',
      dateDescription: 'Sexta, 25 de agosto de 2026',
      peakLabel: 'Pico às 19h00',
      peakIndex: 3,
      chartPoints: [0.25, 0.55, 0.70, 0.98, 0.45],
      totalMovimentado: '420',
      totalSubtitle: 'Ciclos completos de carrinhos na sexta',
      totalPillText: '+24%',
      totalPillColor: AppTheme.success,
      tempoMedio: '5m 10s',
      tempoPillText: 'Alerta',
      tempoPillColor: AppTheme.warning,
      tarefasCriticas: '19',
      tarefasPillText: 'Crítico',
      tarefasPillColor: AppTheme.error,
      isToday: false,
    ),
    'sab': _DayDashboardData(
      key: 'sab',
      menuLabel: 'Sábado',
      buttonLabel: 'Sábado',
      dateDescription: 'Sábado, 26 de agosto de 2026',
      peakLabel: 'Pico às 14h00',
      peakIndex: 2,
      chartPoints: [0.30, 0.82, 0.96, 0.72, 0.35],
      totalMovimentado: '495',
      totalSubtitle: 'Ciclos completos de carrinhos no sábado',
      totalPillText: '+35%',
      totalPillColor: AppTheme.success,
      tempoMedio: '5m 35s',
      tempoPillText: 'Alerta',
      tempoPillColor: AppTheme.warning,
      tarefasCriticas: '23',
      tarefasPillText: 'Crítico',
      tarefasPillColor: AppTheme.error,
      isToday: false,
    ),
    'dom': _DayDashboardData(
      key: 'dom',
      menuLabel: 'Domingo',
      buttonLabel: 'Domingo',
      dateDescription: 'Domingo, 27 de agosto de 2026',
      peakLabel: 'Pico às 11h30',
      peakIndex: 1,
      chartPoints: [0.18, 0.82, 0.65, 0.38, 0.15],
      totalMovimentado: '275',
      totalSubtitle: 'Ciclos completos de carrinhos no domingo',
      totalPillText: '-6%',
      totalPillColor: AppTheme.textSecondary,
      tempoMedio: '3m 50s',
      tempoPillText: 'Ótimo',
      tempoPillColor: AppTheme.success,
      tarefasCriticas: '5',
      tarefasPillText: 'Baixo',
      tarefasPillColor: AppTheme.success,
      isToday: false,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final currentDay = _daysData[_selectedDayKey] ?? _daysData['qua']!;

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
                  currentDay.dateDescription,
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: const PopupMenuThemeData(
                color: AppTheme.surface,
              ),
            ),
            child: PopupMenuButton<String>(
              color: AppTheme.surface,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
              ),
              offset: const Offset(0, 48),
              tooltip: 'Selecionar dia da semana',
              onSelected: (dayKey) {
                setState(() {
                  _selectedDayKey = dayKey;
                });
              },
              itemBuilder: (context) {
                return _daysData.entries.map((entry) {
                  final isSelected = entry.key == _selectedDayKey;
                  return PopupMenuItem<String>(
                    value: entry.key,
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                          size: 16,
                          color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            entry.value.menuLabel,
                            style: TextStyle(
                              color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: AppTheme.textPrimary),
                    const SizedBox(width: 6),
                    Text(
                      currentDay.buttonLabel,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.arrow_drop_down, color: AppTheme.textPrimary),
                  ],
                ),
              ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Uso de Carrinhos por Horário', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      // Pílula Pico dinâmica
                      _StatusPill(text: currentDay.peakLabel, color: AppTheme.primary),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Monitoramento de fluxo ativo na loja', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  const SizedBox(height: 16),
                  _HourlyUsageChart(
                    normalizedPoints: currentDay.chartPoints,
                    peakIndex: currentDay.peakIndex,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Card Total Movimentado
            _MetricCard(
              title: 'Total Movimentado',
              subtitle: currentDay.totalSubtitle,
              value: currentDay.totalMovimentado,
              pillText: currentDay.totalPillText,
              pillColor: currentDay.totalPillColor,
            ),
            const SizedBox(height: 16),

            // Card Tempo Médio
            _MetricCard(
              title: 'Tempo Médio de Reposição',
              subtitle: 'Tempo para retornar carrinhos às estações',
              value: currentDay.tempoMedio,
              pillText: currentDay.tempoPillText,
              pillColor: currentDay.tempoPillColor,
            ),
            const SizedBox(height: 16),

            // Card Tarefas Críticas
            _MetricCard(
              title: currentDay.isToday ? 'Tarefas Críticas Hoje' : 'Tarefas Críticas do Dia',
              subtitle: 'Abandono fora da zona de tolerância',
              value: currentDay.tarefasCriticas,
              pillText: currentDay.tarefasPillText,
              pillColor: currentDay.tarefasPillColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _DayDashboardData {
  final String key;
  final String menuLabel;
  final String buttonLabel;
  final String dateDescription;
  final String peakLabel;
  final int peakIndex;
  final List<double> chartPoints;
  final String totalMovimentado;
  final String totalSubtitle;
  final String totalPillText;
  final Color totalPillColor;
  final String tempoMedio;
  final String tempoPillText;
  final Color tempoPillColor;
  final String tarefasCriticas;
  final String tarefasPillText;
  final Color tarefasPillColor;
  final bool isToday;

  const _DayDashboardData({
    required this.key,
    required this.menuLabel,
    required this.buttonLabel,
    required this.dateDescription,
    required this.peakLabel,
    required this.peakIndex,
    required this.chartPoints,
    required this.totalMovimentado,
    required this.totalSubtitle,
    required this.totalPillText,
    required this.totalPillColor,
    required this.tempoMedio,
    required this.tempoPillText,
    required this.tempoPillColor,
    required this.tarefasCriticas,
    required this.tarefasPillText,
    required this.tarefasPillColor,
    required this.isToday,
  });
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
    final bool isPeak = text.startsWith('Pico');
    final bool isTrend = text.contains('%');
    final bool isWarningOrCritical = text == 'Atenção' || text == 'Crítico' || text == 'Alerta';

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
          if (isTrend)
            Icon(Icons.trending_up, size: 12, color: color)
          else if (isPeak)
            Icon(Icons.access_time_rounded, size: 12, color: color)
          else if (isWarningOrCritical)
            Icon(Icons.warning_amber_rounded, size: 12, color: color)
          else
            Icon(Icons.check_circle_outline, size: 12, color: color),
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
  final List<double> normalizedPoints;
  final int peakIndex;

  const _HourlyUsageChart({
    required this.normalizedPoints,
    required this.peakIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 130,
          width: double.infinity,
          child: CustomPaint(
            painter: _ChartPainter(
              normalizedPoints: normalizedPoints,
              peakIndex: peakIndex,
            ),
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
  final List<double> normalizedPoints;
  final int peakIndex;

  _ChartPainter({
    required this.normalizedPoints,
    required this.peakIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 8.0;
    const rightPad = 8.0;
    const topPad = 18.0;
    const bottomPad = 8.0;

    final usableWidth = size.width - leftPad - rightPad;
    final usableHeight = size.height - topPad - bottomPad;

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

    // 3. Linha guia pontilhada vertical no pico
    final safePeakIndex = peakIndex.clamp(0, points.length - 1);
    final peakPoint = points[safePeakIndex];
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

    // 6. Pontos de dados (Nodes) com destaque no pico
    for (int i = 0; i < points.length; i++) {
      final pt = points[i];
      if (i == safePeakIndex) {
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
  bool shouldRepaint(covariant _ChartPainter oldDelegate) {
    return oldDelegate.normalizedPoints != normalizedPoints || oldDelegate.peakIndex != peakIndex;
  }
}
