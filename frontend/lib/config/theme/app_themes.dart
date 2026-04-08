import 'package:flutter/material.dart';

/* ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Muli',
    appBarTheme: appBarTheme()
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Color(0XFF8B8B8B)),
    titleTextStyle: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
  );
} */

const _kPrimaryColor = Color(0xFF0052FF);
const _kSecondaryColor = Color(0xFFFF5A1F);
const _kTertiaryColor = Color(0xFF7C3AED);
const _kNeutralColor = Color(0xFF73739E);

ThemeData theme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFFBFBFF),
    fontFamily: 'Epilogue',
    primaryColor: _kPrimaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _kPrimaryColor,
      primary: _kPrimaryColor,
      secondary: _kSecondaryColor,
      tertiary: _kTertiaryColor,
      surface: const Color(0xFFF9FAFC),
    ),
    appBarTheme: appBarTheme(),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      bodyMedium: TextStyle(color: Color(0xFF3C3C3C)),
    ),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: _kPrimaryColor),
    titleTextStyle: TextStyle(
      color: _kPrimaryColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ),
  );
}
