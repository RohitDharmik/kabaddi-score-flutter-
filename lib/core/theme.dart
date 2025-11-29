import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- Shared Color Palettes ---

  // Custom Primary Color (Vibrant Blue) for key actions and focus
  static const Color _primaryColor = Color.fromARGB(184, 58, 131, 248);
  // Custom Secondary Color (Teal) for accents
  static const Color _secondaryColor = Color(0xFF00FFAA);
  // Scoreboard Color (Neon Green/Cyan)
  static const Color _scoreColor = Color(0xFF00FFCC);

  // --- Light Theme Definition ---

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'digital7',
      // Background: Clean off-white
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      primaryColor: _primaryColor,
      colorScheme: ColorScheme.light(
        brightness: Brightness.light,
        primary: _primaryColor,
        secondary: _secondaryColor,
        error: const Color(0xFFD32F2F),
        // Surface: Pure white for cards/surfaces
        surface: const Color(0xFFFFFFFF),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: Colors.black87,
        elevation: 1,
        titleTextStyle:
            textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),

      // Text Input Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFEEEEEE), // Light gray fill
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
        labelStyle: textTheme.bodyLarge?.copyWith(color: Colors.black54),
        hintStyle: textTheme.bodyMedium?.copyWith(color: Colors.black38),
      ),

      textTheme: textTheme,

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          textStyle:
              textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          elevation: 4, // Added elevation
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryColor,
          side: BorderSide(color: _primaryColor, width: 1.5),
          textStyle:
              textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),

      // Card Theme (for the team panels)
      cardTheme: CardThemeData(
        color: Color(0xFFFFFFFF),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  // --- Dark Theme Definition (Enhanced) ---

  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme);

    // Define the color for the score text in the TextTheme
    final updatedTextTheme = textTheme.copyWith(
      displayLarge: textTheme.displayLarge?.copyWith(
        color: _scoreColor, // Apply neon color to large text styles if needed
        fontFamily: 'digital7',
        shadows: [
          // Added glow effect for score
          BoxShadow(color: _scoreColor.withOpacity(0.4), blurRadius: 10),
        ],
      ),
    );

    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'digital7',
      // Scaffold Background: Deepest dark gray
      scaffoldBackgroundColor: const Color(0xFF121212),
      primaryColor: _primaryColor,
      colorScheme: ColorScheme.dark(
        brightness: Brightness.dark,
        primary: _primaryColor,
        secondary: _secondaryColor,
        error: const Color(0xFFFF8A80), // Softer dark error
        // Surface: Slightly lighter dark gray for cards/surfaces
        surface: const Color(0xFF1E1E1E),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle:
            textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),

      // Text Input Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2B2B33), // Darker fill color than surface
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
        labelStyle: textTheme.bodyLarge?.copyWith(color: Colors.white70),
        hintStyle: textTheme.bodyMedium?.copyWith(color: Colors.white38),
      ),

      textTheme: updatedTextTheme, // Use the updated theme with score glow

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          textStyle:
              textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          elevation: 4, // Added elevation
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryColor,
          side: BorderSide(color: _primaryColor, width: 1.5),
          textStyle:
              textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),

      // Card Theme (for the team panels)
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 4, // Increased elevation for definition
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Snackbar Theme
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF333333),
        contentTextStyle: TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
