import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFFE50914); // Netflix-like Red
  static const Color scaffoldBackgroundColor = Color(0xFF121212);
  static Color linear = const Color(0xFF9C9F8E);
  static const Color cardColor = Color(0xFF1E1E1E);
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color secondaryTextColor = Color(0xFFB3B3B3);
  static Color kSubheadingColor = const Color.fromRGBO(0, 0, 0, 0.5);
  static Color kWhite = const Color(0xFFFFFFFF);
  static Color kdark = const Color(0xFF2F302E);
  static Color kblack = const Color(0xFF000000);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        surface: cardColor,
        onSurface: textColor,
      ),
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: textColor,
        displayColor: textColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        hintStyle: const TextStyle(color: secondaryTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }
}
