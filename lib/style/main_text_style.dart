import 'package:flutter/widgets.dart';

class MainTextStyle {
  static final TextStyle manrope = TextStyle(fontFamily: 'Manrope');

  /// displayLarge Text Style
  static TextStyle displayLarge = manrope.copyWith(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    height: 1.11,
    letterSpacing: -2,
  );

  /// displayMedium Text Style
  static TextStyle displayMedium = manrope.copyWith(
    fontSize: 45,
    fontWeight: FontWeight.w600,
    height: 1.17,
  );

  /// displaySmall Text Style
  static TextStyle displaySmall = manrope.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w500,
    height: 1.25,
    letterSpacing: -1,
  );

  /// headlineLarge Text Style
  static TextStyle headlineLarge = manrope.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: -1,
  );

  /// headlineMedium Text Style
  static TextStyle headlineMedium = manrope.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: -1,
  );

  /// headlineMedium Text Style
  static TextStyle headlineSmall = manrope.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: -1,
  );

  /// titleLarge Text Style
  static TextStyle titleLarge = manrope.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 1.2,
  );

  /// titleMedium Text Style
  static TextStyle titleMedium = manrope.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 1.2,
  );

  /// titleSmall Text Style
  static TextStyle titleSmall = manrope.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.2,
    letterSpacing: 1.2,
  );

  /// bodyLargeBold Text Style
  static TextStyle bodyLargeBold = manrope.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.56,
  );

  /// bodyLargeMedium Text Style
  static TextStyle bodyLargeMedium = manrope.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.56,
  );

  /// bodyLargeRegular Text Style
  static TextStyle bodyLargeRegular = manrope.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w200,
    height: 1.56,
  );

  /// labelLarge Text Style
  static TextStyle labelLarge = manrope.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.71,
    letterSpacing: 1.3,
  );

  /// labelMedium Text Style
  static TextStyle labelMedium = manrope.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w200,
    height: 1.4,
    letterSpacing: 1.3,
  );

  /// labelSmall Text Style
  static TextStyle labelSmall = manrope.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w900,
    height: 1.2,
    letterSpacing: 1.3,
  );
}
