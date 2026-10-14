import 'package:flutter/material.dart';
import '../core/theme.dart';

class EquipmentDetailScreen extends StatefulWidget {
  final String role; // 'manager' ou 'employee'
  final int cartNumber;

  const EquipmentDetailScreen({
    super.key,
    this.role = 'manager',
    this.cartNumber = 1,
  });

  @override
  State<EquipmentDetailScreen> createState() => _EquipmentDetailScreenState();
}

class _EquipmentDetailScreenState extends State<EquipmentDetailScreen> {
  late String _status;
  late TextEditingController _problemController;
  bool _hasPhotoAttached = false;

  final List<String> _statusOptions = ['Ativo', 'Em conserto', 'Inativo'];

  @override
  void initState() {
    super.initState();
    _status = 'Ativo';
    _problemController = TextEditingController(
      text: 'Roda dianteira da frente quebrada',
    );
  }

  @override
  void dispose() {
    _problemController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Ativo':
        return AppTheme.success;
      case 'Em conserto':
        return AppTheme.warning;
      case 'Inativo':
        return AppTheme.error;
      default:
        return AppTheme.textSecondary;
    }
  }

  void _submitEmployeeReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: AppTheme.success, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Avaria Reportada!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'O gerente foi notificado sobre o problema no Carrinho ${widget.cartNumber} e poderá alterar o status para conserto.',
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
                  Navigator.pop(context); // volta para a lista
                },
                child: const Text('Entendido'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveManagerChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Carrinho ${widget.cartNumber} atualizado para "$_status" com sucesso!'),
        backgroundColor: AppTheme.success,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEmployee = widget.role == 'employee';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Equipamento - Carrinho ${widget.cartNumber}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
            // Top Card
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Carrinho ${widget.cartNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Estação 1 - Entrada', style: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.8), fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Formulário / Detalhes
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReadOnlyField('ID do Equipamento:', 'CR00${widget.cartNumber}'),
                  const SizedBox(height: 16),
                  _buildReadOnlyField('Data de Cadastro:', '24/02/2026'),
                  const SizedBox(height: 16),
                  _buildReadOnlyField('Estação pertencente:', 'Estação 4 - Saída'),
                  const SizedBox(height: 16),
                  _buildReadOnlyField('Localização:', 'Registrado na baia da Saída, há 12 minutos'),
                  const SizedBox(height: 16),

                  // Status do Equipamento
                  const Text('Status do Equipamento:', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  const SizedBox(height: 8),
                  if (isEmployee)
                    // Funcionário apenas visualiza o status (badge)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.circle, color: _getStatusColor(_status), size: 10),
                          const SizedBox(width: 8),
                          Text(
                            _status,
                            style: TextStyle(
                              color: _getStatusColor(_status),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            '(Gerente gerencia)',
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                          ),
                        ],
                      ),
                    )
                  else
                    // Gerente pode alterar o status
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _status,
                          dropdownColor: AppTheme.surface,
                          icon: const Icon(Icons.arrow_drop_down, color: AppTheme.textPrimary),
                          items: _statusOptions.map((opt) {
                            return DropdownMenuItem<String>(
                              value: opt,
                              child: Row(
                                children: [
                                  Icon(Icons.circle, color: _getStatusColor(opt), size: 10),
                                  const SizedBox(width: 8),
                                  Text(opt, style: TextStyle(color: _getStatusColor(opt), fontWeight: FontWeight.bold, fontSize: 14)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            if (newVal != null) {
                              setState(() => _status = newVal);
                            }
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Problemas do Equipamento
                  const Text('Problemas do Equipamento:', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  const SizedBox(height: 8),
                  if (isEmployee)
                    // Funcionário pode digitar/editar o relato da avaria
                    TextField(
                      controller: _problemController,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppTheme.background,
                        hintText: 'Descreva a avaria encontrada...',
                        hintStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    )
                  else
                    // Gerente vê a avaria reportada
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _problemController.text.isNotEmpty ? _problemController.text : 'Nenhuma avaria reportada',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  const SizedBox(height: 16),
                  
                  // Imagem da Avaria: Upload para Funcionário, Visualização para Gerente
                  Text(
                    isEmployee ? 'Foto da Avaria:' : 'Registro Visual da Avaria:',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  if (isEmployee)
                    // Funcionário pode carregar/anexar foto
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _hasPhotoAttached = !_hasPhotoAttached;
                        });
                        if (_hasPhotoAttached) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Foto da avaria anexada com sucesso!'), duration: Duration(seconds: 1)),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _hasPhotoAttached ? AppTheme.success : AppTheme.textSecondary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _hasPhotoAttached ? Icons.check_circle : Icons.image_outlined,
                                  color: _hasPhotoAttached ? AppTheme.success : AppTheme.textSecondary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _hasPhotoAttached ? 'Foto da avaria anexada (toque para remover)' : 'Carregar imagem da avaria',
                                  style: TextStyle(
                                    color: _hasPhotoAttached ? AppTheme.success : AppTheme.textSecondary,
                                    fontSize: 12,
                                    fontWeight: _hasPhotoAttached ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              _hasPhotoAttached ? Icons.close : Icons.camera_alt_outlined,
                              color: AppTheme.textSecondary,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    // Gerente apenas visualiza a foto anexada pelo funcionário
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            backgroundColor: AppTheme.surface,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Foto da Avaria', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppTheme.background,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: AppTheme.error.withValues(alpha: 0.15),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.broken_image_outlined, color: AppTheme.error, size: 44),
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'Roda dianteira travada e trincada',
                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'Foto enviada pelo repositor • Há 15 minutos',
                                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.25)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppTheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
                              ),
                              child: const Center(
                                child: Icon(Icons.image_outlined, color: AppTheme.primary, size: 24),
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'avaria_roda_cr001.jpg',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Enviado pelo funcionário • Toque para ampliar',
                                    style: TextStyle(fontSize: 11, color: AppTheme.primary),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.zoom_in, color: AppTheme.textSecondary, size: 20),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                  
                  // Botão de Ação dependendo do papel
                  if (isEmployee)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444), // Vermelho de atenção para reportar
                        ),
                        onPressed: _submitEmployeeReport,
                        child: const Text('Reportar Avaria ao Gerente'),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveManagerChanges,
                        child: const Text('Salvar Alterações / Atualizar Status'),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Card: Ciclo de Vida & Histórico
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.timeline_rounded, color: AppTheme.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ciclo de Vida & Histórico',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Linha do tempo e rastreabilidade deste equipamento',
                              style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  _buildTimelineItem(
                    title: 'Previsão de Retorno Operacional',
                    badge: 'Em Manutenção',
                    badgeColor: AppTheme.warning,
                    timestamp: 'Previsto para Hoje às 16:30',
                    description: 'Aguardando substituição do conjunto de rodízios na oficina interna de reparos.',
                    icon: Icons.schedule_rounded,
                    iconColor: AppTheme.warning,
                    isFirst: true,
                    isLast: false,
                    isPending: true,
                  ),
                  _buildTimelineItem(
                    title: 'Encaminhado para Conserto',
                    badge: 'OS #048',
                    badgeColor: AppTheme.primary,
                    timestamp: 'Hoje às 14:35 • Aline Carvalho (Gerente)',
                    description: 'Ordem de serviço aberta. Status alterado no sistema para "Em conserto" e carrinho retirado de circulação.',
                    icon: Icons.build_circle_outlined,
                    iconColor: AppTheme.primary,
                    isFirst: false,
                    isLast: false,
                    isPending: false,
                  ),
                  _buildTimelineItem(
                    title: 'Avaria Reportada em Campo',
                    badge: 'Crítico',
                    badgeColor: AppTheme.error,
                    timestamp: 'Hoje às 14:10 • João Silva (Repositor)',
                    description: 'Roda dianteira travada e com trinca detectada durante coleta na Estação 4. Foto anexada ao sistema.',
                    icon: Icons.report_problem_outlined,
                    iconColor: AppTheme.error,
                    isFirst: false,
                    isLast: false,
                    isPending: false,
                  ),
                  _buildTimelineItem(
                    title: 'Última Coleta e Reposição',
                    badge: 'Concluído',
                    badgeColor: AppTheme.success,
                    timestamp: 'Hoje às 11:15 • Marcos Silva (Repositor)',
                    description: 'Carrinho recolhido no estacionamento externo e retornado com sucesso à baia da Estação 1.',
                    icon: Icons.replay_rounded,
                    iconColor: AppTheme.success,
                    isFirst: false,
                    isLast: false,
                    isPending: false,
                  ),
                  _buildTimelineItem(
                    title: 'Cadastro e Entrada em Operação',
                    badge: 'Origem',
                    badgeColor: AppTheme.textSecondary,
                    timestamp: '24/02/2026 às 08:30 • Sistema Synercart',
                    description: 'Identificador RFID tag #CR00${widget.cartNumber} pareado e alocado inicialmente na Estação 1 - Entrada.',
                    icon: Icons.inventory_2_outlined,
                    iconColor: AppTheme.primary,
                    isFirst: false,
                    isLast: true,
                    isPending: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String badge,
    required Color badgeColor,
    required String timestamp,
    required String description,
    required IconData icon,
    required Color iconColor,
    required bool isFirst,
    required bool isLast,
    required bool isPending,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coluna da linha do tempo (Ícone + Linha vertical)
          SizedBox(
            width: 36,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isPending 
                        ? iconColor.withValues(alpha: 0.15)
                        : iconColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: iconColor,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(icon, color: iconColor, size: 16),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Conteúdo do evento
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isPending ? AppTheme.textPrimary : Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            color: badgeColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 11, color: AppTheme.textSecondary.withValues(alpha: 0.8)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          timestamp,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
                    ),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary.withValues(alpha: 0.9),
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
}
