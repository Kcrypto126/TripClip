import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'trip_clip_colors.dart';

/// Rubik typescale from TripClip design (sizes / line heights in px).
TextTheme buildTripClipTextTheme(TripClipColors semantic) {
  TextStyle rubik({
    required double size,
    required double lineHeight,
    required FontWeight weight,
    required Color color,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.rubik(
      fontSize: size,
      height: lineHeight / size,
      fontWeight: weight,
      color: color,
      decoration: decoration,
    );
  }

  final Color body = semantic.textBase;
  final Color subtle = semantic.textSubtle;
  final Color headingColor = semantic.heading;

  return TextTheme(
    displayLarge: rubik(
      size: 60,
      lineHeight: 64,
      weight: FontWeight.w600,
      color: headingColor,
    ),
    displayMedium: rubik(
      size: 42,
      lineHeight: 48,
      weight: FontWeight.w600,
      color: headingColor,
    ),
    displaySmall: rubik(
      size: 36,
      lineHeight: 40,
      weight: FontWeight.w600,
      color: headingColor,
    ),
    headlineLarge: rubik(
      size: 28,
      lineHeight: 32,
      weight: FontWeight.w600,
      color: headingColor,
    ),
    headlineMedium: rubik(
      size: 22,
      lineHeight: 26,
      weight: FontWeight.w600,
      color: headingColor,
    ),
    headlineSmall: rubik(
      size: 18,
      lineHeight: 22,
      weight: FontWeight.w600,
      color: headingColor,
    ),
    titleLarge: rubik(
      size: 16,
      lineHeight: 20,
      weight: FontWeight.w600,
      color: headingColor,
    ),
    titleMedium: rubik(
      size: 14,
      lineHeight: 16,
      weight: FontWeight.w600,
      color: headingColor,
    ),
    titleSmall: rubik(
      size: 12,
      lineHeight: 14,
      weight: FontWeight.w600,
      color: headingColor,
    ),
    labelLarge: rubik(
      size: 16,
      lineHeight: 24,
      weight: FontWeight.w700,
      color: body,
    ),
    bodyLarge: rubik(
      size: 20,
      lineHeight: 26,
      weight: FontWeight.w400,
      color: body,
    ),
    bodyMedium: rubik(
      size: 16,
      lineHeight: 24,
      weight: FontWeight.w400,
      color: body,
    ),
    bodySmall: rubik(
      size: 14,
      lineHeight: 20,
      weight: FontWeight.w400,
      color: body,
    ),
    labelMedium: rubik(
      size: 12,
      lineHeight: 18,
      weight: FontWeight.w400,
      color: body,
    ),
    labelSmall: rubik(
      size: 12,
      lineHeight: 18,
      weight: FontWeight.w400,
      color: subtle,
    ),
  );
}

/// Named helpers for body strong / link / subheading.
class TripClipTextStyles {
  TripClipTextStyles._(this._theme, this._semantic);

  factory TripClipTextStyles.of(BuildContext context) {
    return TripClipTextStyles._(
      Theme.of(context).textTheme,
      context.tripClipColors,
    );
  }

  final TextTheme _theme;
  final TripClipColors _semantic;

  TextStyle get bodyLgStrong => _theme.bodyLarge!.copyWith(
        fontWeight: FontWeight.w600,
        color: _semantic.textBase,
      );

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

  TextStyle get subheading => GoogleFonts.rubik(
        fontSize: 11,
        height: 14 / 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: _semantic.textSubtle,
      );
}
