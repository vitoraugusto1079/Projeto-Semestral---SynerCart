import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'mock_db.dart';
import 'pdf_saver_io.dart' if (dart.library.js_interop) 'pdf_saver_web.dart';

class WeeklyReportService {
  static Future<String> generateAndDownloadWeeklyReport() async {
    final doc = pw.Document(
      title: 'Relatorio Operacional Semanal - SynerCart',
      author: 'Aline Carvalho (Gerente - ID: 8849)',
      creator: 'SynerCart v2.4.1',
    );

    // Tenta carregar a logo do projeto para embutir no cabeçalho do PDF
    pw.MemoryImage? logoImage;
    try {
      final logoData = await rootBundle.load('lib/assets/icons/logo.png');
      logoImage = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (_) {}

    const primaryBlue = PdfColor.fromInt(0xFF1D4ED8);
    const accentBlue = PdfColor.fromInt(0xFF3B82F6);
    const darkBg = PdfColor.fromInt(0xFF0F172A);
    const cardBg = PdfColor.fromInt(0xFFF8FAFC);
    const borderGrey = PdfColor.fromInt(0xFFE2E8F0);
    const textDark = PdfColor.fromInt(0xFF1E293B);
    const textMuted = PdfColor.fromInt(0xFF64748B);
    const greenSuccess = PdfColor.fromInt(0xFF16A34A);
    const amberWarning = PdfColor.fromInt(0xFFD97706);
    const redError = PdfColor.fromInt(0xFFDC2626);

    final weeklyRows = [
      ['Segunda-feira (18/08)', '168 ciclos', '128 un.', '6 un.', '18h00 (44 un.)', '4m 10s', 'Normal'],
      ['Terca-feira (19/08)', '176 ciclos', '129 un.', '5 un.', '18h00 (46 un.)', '4m 20s', 'Normal'],
      ['Quarta-feira (23/08)', '194 ciclos', '126 un.', '7 un.', '18h00 (51 un.)', '4m 30s', 'Atencao'],
      ['Quinta-feira (24/08)', '205 ciclos', '127 un.', '6 un.', '18h00 (49 un.)', '4m 45s', 'Atencao'],
      ['Sexta-feira (25/08)', '238 ciclos', '130 un.', '4 un.', '18h00 (54 un.)', '5m 10s', 'Alerta'],
      ['Sabado (26/08)', '264 ciclos', '131 un.', '4 un.', '14h00 (55 un.)', '5m 35s', 'Critico'],
      ['Domingo (27/08)', '152 ciclos', '128 un.', '5 un.', '10h00 (46 un.)', '3m 50s', 'Otimo'],
    ];

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        footer: (context) => pw.Container(
          margin: const pw.EdgeInsets.only(top: 12),
          padding: const pw.EdgeInsets.only(top: 8),
          decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(color: borderGrey, width: 1)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Documento gerado automaticamente pelo sistema SynerCart v2.4.1 • Uso Interno Corporativo',
                style: const pw.TextStyle(fontSize: 8, color: textMuted),
              ),
              pw.Text(
                'Pagina ${context.pageNumber} de ${context.pagesCount}',
                style: pw.TextStyle(fontSize: 8, color: textMuted, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ),
        build: (context) => [
          // 1. Cabeçalho Corporativo
          pw.Container(
            padding: const pw.EdgeInsets.all(18),
            decoration: pw.BoxDecoration(
              color: darkBg,
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Row(
                  children: [
                    if (logoImage != null) ...[
                      pw.Container(
                        width: 44,
                        height: 44,
                        child: pw.Image(logoImage),
                      ),
                      pw.SizedBox(width: 12),
                    ],
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'SYNERCART — GESTAO INTELIGENTE DE FROTA',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 13,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Text(
                          'Relatorio Operacional Semanal • Supermercado Central (Unidade 07)',
                          style: const pw.TextStyle(
                            color: PdfColor.fromInt(0xFF94A3B8),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: pw.BoxDecoration(
                        color: accentBlue,
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Text(
                        'FROTA MONITORADA',
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 7,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Responsavel: Aline Carvalho (ID: 8849)',
                      style: const pw.TextStyle(color: PdfColors.white, fontSize: 8),
                    ),
                    pw.Text(
                      'Periodo: 18/08/2026 a 27/08/2026',
                      style: const pw.TextStyle(color: PdfColor.fromInt(0xFF94A3B8), fontSize: 8),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 18),

          // 2. Resumo Geral da Frota (Cards de Indicadores)
          pw.Text(
            '1. RESUMO EXECUTIVO DA FROTA E OPERACAO',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: textDark),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              pw.Expanded(
                child: _buildKpiCard(
                  title: 'Total da Frota',
                  value: '136 un.',
                  subtitle: '56 Carrinhos e 80 Cestos',
                  accentColor: primaryBlue,
                  bgColor: cardBg,
                  borderColor: borderGrey,
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(
                child: _buildKpiCard(
                  title: 'Em Operacao (Ativos)',
                  value: '126 un.',
                  subtitle: '92.6% da frota disponivel',
                  accentColor: greenSuccess,
                  bgColor: cardBg,
                  borderColor: borderGrey,
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(
                child: _buildKpiCard(
                  title: 'Em Manutencao',
                  value: '6 un.',
                  subtitle: '4.4% em oficina interna',
                  accentColor: amberWarning,
                  bgColor: cardBg,
                  borderColor: borderGrey,
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(
                child: _buildKpiCard(
                  title: 'Inativos / Reserva',
                  value: '4 un.',
                  subtitle: '3.0% aguardando triagem',
                  accentColor: redError,
                  bgColor: cardBg,
                  borderColor: borderGrey,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 18),

          // 3. Tabela de Desempenho Diário (Segunda a Domingo)
          pw.Text(
            '2. DESEMPENHO DIARIO DA SEMANA (SEGUNDA A DOMINGO)',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: textDark),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: [
              'Dia da Semana',
              'Total Movimentado',
              'Frota Ativa',
              'Manutencao',
              'Horario de Pico',
              'Tempo Medio',
              'Status',
            ],
            data: weeklyRows,
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 8.5,
              fontWeight: pw.FontWeight.bold,
            ),
            headerDecoration: const pw.BoxDecoration(color: primaryBlue),
            cellStyle: const pw.TextStyle(fontSize: 8, color: textDark),
            cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            oddRowDecoration: const pw.BoxDecoration(color: cardBg),
            border: pw.TableBorder.all(color: borderGrey, width: 0.6),
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.center,
              2: pw.Alignment.center,
              3: pw.Alignment.center,
              4: pw.Alignment.center,
              5: pw.Alignment.center,
              6: pw.Alignment.center,
            },
          ),
          pw.SizedBox(height: 18),

          // 4. Status Atual das Estações (Sincronizado com MockDB)
          pw.Text(
            '3. CAPACIDADE E STATUS ATUAL DAS ESTACOES (TEMPO REAL)',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: textDark),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: [
              'Estacao Monitorada',
              'Nivel de Ocupacao',
              'Status Operacional',
              'Equipamentos Alocados',
            ],
            data: MockDB.stations.map((s) {
              final name = s['name'].toString();
              final pct = s['percentage'] as int;
              final rawStatus = s['status'].toString();
              final statusLabel = rawStatus == 'critical'
                  ? 'CRITICO (Reposicao Imediata)'
                  : rawStatus == 'alert'
                      ? 'ALERTA (Monitorar)'
                      : 'ESTAVEL (Operacao Normal)';
              final equipType = (name.contains('Hortifruti') || name.contains('Padaria'))
                  ? 'Cestos de Compras'
                  : 'Carrinhos e Cestos';
              return [
                name,
                '$pct% da capacidade',
                statusLabel,
                equipType,
              ];
            }).toList(),
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 8.5,
              fontWeight: pw.FontWeight.bold,
            ),
            headerDecoration: const pw.BoxDecoration(color: darkBg),
            cellStyle: const pw.TextStyle(fontSize: 8, color: textDark),
            cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            oddRowDecoration: const pw.BoxDecoration(color: cardBg),
            border: pw.TableBorder.all(color: borderGrey, width: 0.6),
          ),
          pw.SizedBox(height: 18),

          // 5. Tipologia das Avarias e Custo de Manutenção
          pw.Text(
            '4. TIPOLOGIA DE AVARIAS E CUSTOS DE MANUTENCAO (${MockDB.formattedTotalMaintenanceCost})',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: textDark),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: [
              'Equipamento',
              'Estacao',
              'Avaria Registrada',
              'Categoria',
              'Status',
              'Custo Reparo',
            ],
            data: MockDB.maintenanceLogs.map((log) {
              final cost = log['cost'] as double;
              return [
                log['code'].toString(),
                log['station'].toString(),
                log['defectName'].toString(),
                log['category'].toString(),
                log['status'].toString(),
                'R\$ ${cost.toStringAsFixed(2).replaceAll('.', ',')}',
              ];
            }).toList(),
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
            ),
            headerDecoration: const pw.BoxDecoration(color: primaryBlue),
            cellStyle: const pw.TextStyle(fontSize: 7.5, color: textDark),
            cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            oddRowDecoration: const pw.BoxDecoration(color: cardBg),
            border: pw.TableBorder.all(color: borderGrey, width: 0.6),
            cellAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerLeft,
              3: pw.Alignment.centerLeft,
              4: pw.Alignment.center,
              5: pw.Alignment.centerRight,
            },
          ),
          pw.SizedBox(height: 16),

          // 6. Resumo da Equipe e Chamados
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: cardBg,
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: borderGrey),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'INDICADORES DE EQUIPE NO TURNO ATUAL',
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: primaryBlue),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      '• Equipe ativa no turno: 5 repositores/recolhedores de carrinhos e cestos via SynerCart',
                      style: const pw.TextStyle(fontSize: 8, color: textDark),
                    ),
                    pw.Text(
                      '• Tarefas de reposicao concluidas pelo operador atual (${MockDB.currentUser['name']}): ${MockDB.completedTasksCount} tarefas',
                      style: const pw.TextStyle(fontSize: 8, color: textDark),
                    ),
                    pw.Text(
                      '• Volume total acumulado na semana: 1.397 ciclos completos de carrinhos e cestos',
                      style: const pw.TextStyle(fontSize: 8, color: textDark),
                    ),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: pw.BoxDecoration(
                    color: greenSuccess,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Text(
                    'EFICIENCIA: 94.2%',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 8.5,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final Uint8List pdfBytes = await doc.save();
    return await savePdfBytes(pdfBytes, 'relatorio_semanal_synercart.pdf');
  }

  static pw.Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required PdfColor accentColor,
    required PdfColor bgColor,
    required PdfColor borderColor,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: bgColor,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: borderColor, width: 0.8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: const pw.TextStyle(fontSize: 8, color: PdfColor.fromInt(0xFF64748B)),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold, color: accentColor),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            subtitle,
            style: const pw.TextStyle(fontSize: 7.5, color: PdfColor.fromInt(0xFF475569)),
          ),
        ],
      ),
    );
  }
}
