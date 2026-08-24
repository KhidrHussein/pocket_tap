import 'dart:ui';
import 'package:flutter/material.dart';
class PocketTapTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      primaryColor: Colors.white,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        onPrimary: Colors.black,
        secondary: Colors.white,
        surface: Colors.black,
      ),
      fontFamily: 'SpaceGrotesk',
      textTheme: ThemeData.dark().textTheme.copyWith(
        displayLarge: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        displayMedium: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        bodyLarge: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: const BeveledRectangleBorder(),
          minimumSize: const Size(double.infinity, 60),
          textStyle: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      primaryColor: Colors.black,
      colorScheme: const ColorScheme.light(
        primary: Colors.black,
        onPrimary: Colors.white,
        secondary: Colors.black,
        surface: Colors.white,
      ),
      fontFamily: 'SpaceGrotesk',
      textTheme: ThemeData.light().textTheme.copyWith(
        displayLarge: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        displayMedium: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        bodyLarge: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: const BeveledRectangleBorder(),
          minimumSize: const Size(double.infinity, 60),
          textStyle: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
