import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme.dart';
import '../core/mock_db.dart';
import '../core/image_picker_io.dart' if (dart.library.js_interop) '../core/image_picker_web.dart';

class EditProfileScreen extends StatefulWidget {
  final String role; // 'manager' ou 'employee'

  const EditProfileScreen({super.key, required this.role});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late String _selectedShift;
  Uint8List? _customAvatarBytes;

  static const List<String> _shifts = [
    'Turno Manhã (06h às 14h20)',
    'Turno Tarde (13h40 às 22h00)',
    'Turno Integral / Comercial',
  ];

  bool get _isManager => widget.role == 'manager';

  Map<String, dynamic> get _profileData =>
      _isManager ? MockDB.managerProfile : MockDB.employeeProfile;

  @override
  void initState() {
    super.initState();
    final data = _profileData;
    _nameController = TextEditingController(text: data['name'] as String? ?? '');
    _emailController = TextEditingController(text: data['email'] as String? ?? '');
    _phoneController = TextEditingController(text: data['phone'] as String? ?? '');
    final currentShift = data['shift'] as String? ?? _shifts.first;
    _selectedShift = _shifts.contains(currentShift) ? currentShift : _shifts.first;
    _customAvatarBytes = data['customAvatarBytes'] as Uint8List?;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picked = await pickFloorPlanImage();
    if (picked != null && picked.bytes != null && mounted) {
      setState(() {
        _customAvatarBytes = picked.bytes;
      });
    }
  }

  void _saveProfile() {
    MockDB.updateUserProfile(
      role: widget.role,
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      shift: _selectedShift,
      password: _profileData['password'] as String? ?? '',
      avatarBytes: _customAvatarBytes,
    );

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
              'Perfil Atualizado!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'As informações de ${_nameController.text.trim()} foram salvas com sucesso.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                onPressed: () {
                  Navigator.pop(context); // fecha dialog
                  Navigator.pop(context); // volta ao perfil
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
    final avatarAsset = _isManager
        ? 'lib/assets/icons/avatar_manager.svg'
        : 'lib/assets/icons/avatar_employee.svg';
    final roleBadgeText = _isManager
        ? 'GERENTE DE OPERAÇÕES • ID: 8849'
        : 'REPOSITOR / RECOLHEDOR • ID: 8849';

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Editar Perfil', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ==========================================
            // CARD 1: CABEÇALHO DO PERFIL E AVATAR
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickAvatar,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.primary.withValues(alpha: 0.6),
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: _customAvatarBytes != null
                                ? Image.memory(
                                    _customAvatarBytes!,
                                    width: 84,
                                    height: 84,
                                    fit: BoxFit.cover,
                                  )
                                : SvgPicture.asset(
                                    avatarAsset,
                                    width: 84,
                                    height: 84,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.surface, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt_rounded, size: 15, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _nameController.text.trim().isEmpty
                        ? (_isManager ? 'Aline Carvalho' : 'João Silva')
                        : _nameController.text.trim(),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      roleBadgeText,
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ==========================================
            // CARD 2: DADOS PESSOAIS E CONTATO
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    icon: Icons.badge_outlined,
                    title: 'Dados Pessoais e Contato',
                  ),
                  const SizedBox(height: 14),
                  Divider(color: Colors.white.withValues(alpha: 0.07), height: 1),
                  const SizedBox(height: 16),

                  _buildFieldLabel('Nome Completo'),
                  _buildStyledTextField(
                    controller: _nameController,
                    hint: _isManager ? 'Aline Carvalho' : 'João Silva',
                    prefixIcon: Icons.person_outline_rounded,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFieldLabel('E-mail Corporativo'),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Não editável',
                          style: TextStyle(
                            color: AppTheme.textSecondary.withValues(alpha: 0.45),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Campo de E-mail escurecido e bloqueado para indicar que não pode ser alterado
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF080B0F),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.alternate_email_rounded,
                          size: 18,
                          color: AppTheme.textSecondary.withValues(alpha: 0.35),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _emailController.text,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary.withValues(alpha: 0.45),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 15,
                          color: AppTheme.textSecondary.withValues(alpha: 0.35),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildFieldLabel('Telefone / Ramal Operacional'),
                  _buildStyledTextField(
                    controller: _phoneController,
                    hint: '(11) 98765-4321',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ==========================================
            // CARD 3: ALOCAÇÃO E TURNO DE TRABALHO
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    icon: Icons.storefront_outlined,
                    title: 'Vínculo Operacional',
                  ),
                  const SizedBox(height: 14),
                  Divider(color: Colors.white.withValues(alpha: 0.07), height: 1),
                  const SizedBox(height: 16),

                  _buildFieldLabel('Escala / Turno de Atuação'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedShift,
                        isExpanded: true,
                        dropdownColor: AppTheme.surface,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.textSecondary),
                        items: _shifts.map((shift) {
                          return DropdownMenuItem<String>(
                            value: shift,
                            child: Row(
                              children: [
                                const Icon(Icons.schedule_rounded, size: 16, color: AppTheme.primary),
                                const SizedBox(width: 10),
                                Text(
                                  shift,
                                  style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedShift = val);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // BOTÕES DE AÇÃO
            // ==========================================
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Salvar Alterações'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textPrimary,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.16)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: AppTheme.surface,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(prefixIcon, size: 18, color: AppTheme.primary),
        filled: true,
        fillColor: AppTheme.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
      ),
    );
  }
}
