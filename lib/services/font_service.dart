import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontService {
  static TextTheme getSafeTextTheme(BuildContext context) {
    try {
      // Try to load Google Fonts
      return GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
      ).apply(bodyColor: Colors.white, displayColor: Colors.white);
    } catch (e) {
      print('Error loading Google Fonts, using fallback: $e');
      // Fallback to system font with similar styling
      return Theme.of(context).textTheme
          .apply(bodyColor: Colors.white, displayColor: Colors.white)
          .copyWith(
            // Apply similar weight and styling to match Poppins
            displayLarge: const TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            displayMedium: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            displaySmall: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            headlineLarge: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            headlineMedium: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            headlineSmall: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            titleLarge: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            titleMedium: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            titleSmall: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            bodyLarge: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            bodyMedium: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            bodySmall: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            labelLarge: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            labelMedium: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            labelSmall: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          );
    }
  }

  static TextStyle getSafeTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    try {
      return GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Colors.white,
      );
    } catch (e) {
      print('Error loading Google Fonts style, using fallback: $e');
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Colors.white,
      );
    }
  }
}
