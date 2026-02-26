import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kBackground,
      colorScheme: const ColorScheme.dark(
        surface: kSurface,
        primary: Color(0xFFAB47BC),
        onSurface: kOnBackground,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          color: kOnBackground,
          fontSize: 48,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          color: kOnBackground,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.inter(
          color: kOnBackground,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: kOnBackground,
          fontSize: 16,
        ),
        bodySmall: GoogleFonts.inter(
          color: kOnSurfaceMuted,
          fontSize: 12,
        ),
        labelSmall: GoogleFonts.inter(
          color: kOnSurfaceMuted,
          fontSize: 11,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
