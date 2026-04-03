import 'package:flutter/material.dart';
import 'package:food_recognition_app/style/main_text_style.dart';

class MainTheme {
  static AppBarTheme get _appBarTheme =>
      AppBarTheme(toolbarTextStyle: _textTheme.titleMedium);

  static TextTheme get _textTheme => TextTheme(
    displayLarge: MainTextStyle.displayLarge,
    displayMedium: MainTextStyle.displayMedium,
    displaySmall: MainTextStyle.displaySmall,
    headlineLarge: MainTextStyle.headlineLarge,
    headlineMedium: MainTextStyle.headlineMedium,
    headlineSmall: MainTextStyle.headlineSmall,
    titleLarge: MainTextStyle.titleLarge,
    titleMedium: MainTextStyle.titleMedium,
    titleSmall: MainTextStyle.titleSmall,
    labelLarge: MainTextStyle.labelLarge,
    labelMedium: MainTextStyle.labelMedium,
    labelSmall: MainTextStyle.labelSmall,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: Color.fromARGB(255, 150, 230, 150),
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }
}
