import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/home_page.dart';

void main() {
  runApp(const ProviderScope(child: PortfolioApp()));
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JVCSS – Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const HomePage(),
    );
  }
}
