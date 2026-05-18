import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle tripClipRubik({
  required double fontSize,
  required double lineHeightPx,
  required FontWeight fontWeight,
  double letterSpacing = 0,
  TextDecoration? decoration,
}) {
  return GoogleFonts.rubik(
    fontSize: fontSize,
    height: lineHeightPx / fontSize,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    decoration: decoration,
  );
}

TextTheme buildTripClipTextTheme() {
  return TextTheme(
    displayLarge: tripClipRubik(
      fontSize: 60,
      lineHeightPx: 64,
      fontWeight: FontWeight.w600,
    ),
    displayMedium: tripClipRubik(
      fontSize: 42,
      lineHeightPx: 48,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: tripClipRubik(
      fontSize: 36,
      lineHeightPx: 40,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: tripClipRubik(
      fontSize: 28,
      lineHeightPx: 32,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: tripClipRubik(
      fontSize: 22,
      lineHeightPx: 26,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: tripClipRubik(
      fontSize: 18,
      lineHeightPx: 22,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: tripClipRubik(
      fontSize: 16,
      lineHeightPx: 20,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: tripClipRubik(
      fontSize: 14,
      lineHeightPx: 16,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: tripClipRubik(
      fontSize: 12,
      lineHeightPx: 14,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: tripClipRubik(
      fontSize: 20,
      lineHeightPx: 26,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: tripClipRubik(
      fontSize: 16,
      lineHeightPx: 24,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: tripClipRubik(
      fontSize: 14,
      lineHeightPx: 20,
      fontWeight: FontWeight.w400,
    ),
    labelMedium: tripClipRubik(
      fontSize: 12,
      lineHeightPx: 18,
      fontWeight: FontWeight.w400,
    ),
    labelSmall: tripClipRubik(
      fontSize: 12,
      lineHeightPx: 18,
      fontWeight: FontWeight.w400,
    ),
  );
}

class TripClipTextStyles {
  TripClipTextStyles._(this._theme);

  factory TripClipTextStyles.of(BuildContext context) {
    return TripClipTextStyles._(Theme.of(context).textTheme);
  }

  final TextTheme _theme;

  TextStyle get bodyLgStrong =>
      _theme.bodyLarge!.copyWith(fontWeight: FontWeight.w600);

  TextStyle get bodyLgLink =>
      _theme.bodyLarge!.copyWith(decoration: TextDecoration.underline);

  TextStyle get bodyMdStrong =>
      _theme.bodyMedium!.copyWith(fontWeight: FontWeight.w600);

  TextStyle get bodyMdLink =>
      _theme.bodyMedium!.copyWith(decoration: TextDecoration.underline);

  TextStyle get bodySmStrong =>
      _theme.bodySmall!.copyWith(fontWeight: FontWeight.w600);

  TextStyle get bodySmLink =>
      _theme.bodySmall!.copyWith(decoration: TextDecoration.underline);

  TextStyle get bodyXs => _theme.labelMedium!;

  TextStyle get bodyXsStrong =>
      _theme.labelMedium!.copyWith(fontWeight: FontWeight.w600);

  TextStyle get bodyXsLink => _theme.labelMedium!.copyWith(
        decoration: TextDecoration.underline,
      );

  TextStyle get subheading => tripClipRubik(
        fontSize: 11,
        lineHeightPx: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      );
}
