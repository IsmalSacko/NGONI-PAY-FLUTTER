import 'package:flutter/material.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    // 🎨 Colors
    scaffoldBackgroundColor: Kolors.kOffWhite,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Kolors.kPrimary,
      primary: Kolors.kPrimary,
      secondary: Kolors.kPrimaryLight,
      background: Kolors.kOffWhite,
      error: Kolors.kRed,
    ),

    // 🧱 AppBar
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Kolors.kDark,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Kolors.kDark,
      ),
    ),

    // ✍️ Text Theme
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Kolors.kDark,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Kolors.kDark,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Kolors.kDark,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Kolors.kDark),
      bodyMedium: TextStyle(fontSize: 14, color: Kolors.kGray),
      labelLarge: TextStyle(
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Kolors.kPrimary,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),

    // 🧾 Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Kolors.kWhite,
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
        borderSide: const BorderSide(color: Kolors.kPrimary),
      ),
      labelStyle: const TextStyle(color: Kolors.kGray),
    ),
  );
}
