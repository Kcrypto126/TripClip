import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'trip_clip_colors.dart';
import 'trip_clip_palette.dart';
import 'trip_clip_text_theme.dart';

abstract final class TripClipTheme {
  static ThemeData light() {
    final semantic = TripClipColors.light;
    final textTheme = buildTripClipTextTheme(semantic);
    final colorScheme = ColorScheme.light(
      primary: TripClipPalette.primary500,
      onPrimary: semantic.textFixedOnPrimary,
      secondary: TripClipPalette.secondary500,
      onSecondary: Colors.white,
      surface: semantic.surfaceBackground,
      onSurface: semantic.textBase,
      error: TripClipPalette.error500,
      onError: Colors.white,
      outline: semantic.borderSubtle,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: GoogleFonts.rubik().fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: semantic.pageBackground,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: semantic.pageBackground,
        foregroundColor: semantic.textBase,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: semantic.pageBackground,
        indicatorColor: TripClipPalette.primary50,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelSmall?.copyWith(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12,
            color: selected
                ? TripClipPalette.primary500
                : semantic.textSubtle,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? TripClipPalette.primary500 : semantic.iconBase,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: semantic.surfaceBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: semantic.borderSubtle),
        ),
      ),
      dividerTheme: DividerThemeData(color: semantic.borderSubtle),
      extensions: <ThemeExtension<dynamic>>[TripClipColors.light],
    );
  }

  static ThemeData dark() {
    final semantic = TripClipColors.dark;
    final textTheme = buildTripClipTextTheme(semantic);
    final page = TripClipPalette.darkPageBackground;
    final colorScheme = ColorScheme.dark(
      primary: TripClipPalette.primary500,
      onPrimary: semantic.textFixedOnPrimary,
      secondary: TripClipPalette.secondary500,
      onSecondary: Colors.white,
      surface: page,
      onSurface: semantic.textBase,
      surfaceDim: page,
      surfaceBright: page,
      surfaceContainerLowest: page,
      surfaceContainerLow: page,
      surfaceContainer: page,
      surfaceContainerHigh: page,
      surfaceContainerHighest: page,
      error: TripClipPalette.error500,
      onError: Colors.white,
      outline: semantic.borderSubtle,
      surfaceTint: Colors.transparent,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      applyElevationOverlayColor: false,
      fontFamily: GoogleFonts.rubik().fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: page,
      canvasColor: page,
      cardColor: semantic.surfaceBackground,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: semantic.pageBackground,
        foregroundColor: semantic.textBase,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: semantic.pageBackground,
        indicatorColor: TripClipPalette.primary900.withValues(alpha: 0.35),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelSmall?.copyWith(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12,
            color: selected
                ? TripClipPalette.primary500
                : semantic.textSubtle,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? TripClipPalette.primary500 : semantic.iconBase,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: semantic.surfaceBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: semantic.borderSubtle),
        ),
      ),
      dividerTheme: DividerThemeData(color: semantic.borderSubtle),
      extensions: <ThemeExtension<dynamic>>[TripClipColors.dark],
    );
  }
}
