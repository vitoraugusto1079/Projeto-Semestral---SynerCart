import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme.dart';
import 'manager_dashboard.dart';
import 'manager_map_screen.dart';
import 'station_list_screen.dart';
import 'manager_profile_screen.dart';

class ManagerMainScreen extends StatefulWidget {
  const ManagerMainScreen({super.key});

  @override
  State<ManagerMainScreen> createState() => _ManagerMainScreenState();
}

class _ManagerMainScreenState extends State<ManagerMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ManagerDashboard(),
    const ManagerMapScreen(),
    const StationListScreen(),
    const ManagerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppTheme.primary,
            unselectedItemColor: AppTheme.textSecondary,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, height: 1.3),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, height: 1.3),
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SvgPicture.asset(
                    'lib/assets/icons/nav_relatorio.svg',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(AppTheme.textSecondary, BlendMode.srcIn),
                  ),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SvgPicture.asset(
                    'lib/assets/icons/nav_relatorio.svg',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(AppTheme.primary, BlendMode.srcIn),
                  ),
                ),
                label: 'Relatório Diário',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SvgPicture.asset(
                    'lib/assets/icons/nav_localizacao.svg',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(AppTheme.textSecondary, BlendMode.srcIn),
                  ),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SvgPicture.asset(
                    'lib/assets/icons/nav_localizacao.svg',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(AppTheme.primary, BlendMode.srcIn),
                  ),
                ),
                label: 'Mapa',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SvgPicture.asset(
                    'lib/assets/icons/nav_carrinho.svg',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(AppTheme.textSecondary, BlendMode.srcIn),
                  ),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SvgPicture.asset(
                    'lib/assets/icons/nav_carrinho.svg',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(AppTheme.primary, BlendMode.srcIn),
                  ),
                ),
                label: 'Equipamentos',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SvgPicture.asset(
                    'lib/assets/icons/nav_perfil.svg',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(AppTheme.textSecondary, BlendMode.srcIn),
                  ),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SvgPicture.asset(
                    'lib/assets/icons/nav_perfil.svg',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(AppTheme.primary, BlendMode.srcIn),
                  ),
                ),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
