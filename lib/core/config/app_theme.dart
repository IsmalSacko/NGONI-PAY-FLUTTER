import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamilyFallback: const [
      'Noto Color Emoji',
      'Apple Color Emoji',
      'Segoe UI Emoji',
    ],

    // 🎨 Colors
    scaffoldBackgroundColor: Kolors.kOffWhite,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Kolors.kPrimary,
      primary: Kolors.kPrimary,
      secondary: Kolors.kBlue,
      background: Kolors.kOffWhite,
      error: Kolors.kRed,
    ),

    // 🧱 AppBar
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Kolors.kPrimary,
      foregroundColor: Kolors.kWhite,
      titleTextStyle: GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Kolors.kWhite,
      ),
    ),

    // ✍️ Text Theme
    textTheme: GoogleFonts.manropeTextTheme().copyWith(
      headlineLarge: GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Kolors.kDark,
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Kolors.kDark,
      ),
      titleLarge: GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Kolors.kDark,
      ),
      bodyLarge: GoogleFonts.manrope(fontSize: 16, color: Kolors.kDark),
      bodyMedium: GoogleFonts.manrope(fontSize: 14, color: Kolors.kGray),
      labelLarge: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Kolors.kWhite,
      ),
    ),

    // 🔘 Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Kolors.kPrimary,
        foregroundColor: Kolors.kWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
        textStyle: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Kolors.kPrimary,
        textStyle: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // 🧾 Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Kolors.kWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Kolors.kBlue),
      ),
      labelStyle: GoogleFonts.manrope(color: Kolors.kGray),
    ),

    cardTheme: CardThemeData(
      color: Kolors.kWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
