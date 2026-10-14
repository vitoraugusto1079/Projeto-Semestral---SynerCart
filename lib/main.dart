import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/role_selection_screen.dart';

void main() {
  runApp(const SynercartApp());
}

class SynercartApp extends StatelessWidget {
  const SynercartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synercart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const RoleSelectionScreen(),
    );
  }
}
