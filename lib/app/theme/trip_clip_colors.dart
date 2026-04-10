import 'package:flutter/material.dart';

import 'trip_clip_palette.dart';

/// Semantic colors consumed by widgets. Registered via [ThemeExtension].
@immutable
class TripClipColors extends ThemeExtension<TripClipColors> {
  const TripClipColors({
    required this.pageBackground,
    required this.pagePrimary,
    required this.surfaceBackground,
    required this.surfaceMuted,
    required this.textBase,
    required this.textSubtle,
    required this.textFixedOnPrimary,
    required this.iconBase,
    required this.heading,
    required this.borderSubtle,
    required this.borderBrandPrimary,
    required this.badgeBackground,
    required this.badgeForeground,
    required this.toastError,
    required this.toastWarning,
    required this.toastSuccess,
    required this.toastInfo,
  });

  final Color pageBackground;
  final Color pagePrimary;
  final Color surfaceBackground;
  final Color surfaceMuted;
  final Color textBase;
  final Color textSubtle;
  final Color textFixedOnPrimary;
  final Color iconBase;
  final Color heading;
  final Color borderSubtle;
  final Color borderBrandPrimary;
  final Color badgeBackground;
  final Color badgeForeground;
  final TripClipToastScheme toastError;
  final TripClipToastScheme toastWarning;
  final TripClipToastScheme toastSuccess;
  final TripClipToastScheme toastInfo;

  static final TripClipColors light = TripClipColors(
    pageBackground: Colors.white,
    pagePrimary: TripClipPalette.primary500,
    surfaceBackground: Colors.white,
    surfaceMuted: TripClipPalette.neutral50,
    textBase: TripClipPalette.neutral1000,
    textSubtle: TripClipPalette.neutral600,
    textFixedOnPrimary: Colors.white,
    iconBase: TripClipPalette.neutral1000,
    heading: TripClipPalette.primary500,
    borderSubtle: TripClipPalette.neutral200,
    borderBrandPrimary: TripClipPalette.primary500,
    badgeBackground: TripClipPalette.secondary500,
    badgeForeground: Colors.white,
    toastError: TripClipToastScheme.light(
      background: TripClipPalette.error50,
      border: TripClipPalette.error400,
      foreground: TripClipPalette.error800,
      iconBackground: TripClipPalette.error500,
    ),
    toastWarning: TripClipToastScheme.light(
      background: TripClipPalette.warning50,
      border: TripClipPalette.warning600,
      foreground: TripClipPalette.warning900,
      iconBackground: TripClipPalette.warning500,
    ),
    toastSuccess: TripClipToastScheme.light(
      background: TripClipPalette.success50,
      border: TripClipPalette.success600,
      foreground: TripClipPalette.success900,
      iconBackground: TripClipPalette.success600,
    ),
    toastInfo: TripClipToastScheme.light(
      background: TripClipPalette.primary50,
      border: TripClipPalette.primary400,
      foreground: TripClipPalette.primary900,
      iconBackground: TripClipPalette.primary500,
    ),
  );

  static final TripClipColors dark = TripClipColors(
    pageBackground: TripClipPalette.darkPageBackground,
    pagePrimary: TripClipPalette.primary500,
    surfaceBackground: TripClipPalette.darkPageBackground,
    surfaceMuted: TripClipPalette.darkPageBackground,
    textBase: TripClipPalette.neutral50,
    textSubtle: TripClipPalette.neutral400,
    textFixedOnPrimary: Colors.white,
    iconBase: TripClipPalette.neutral50,
    heading: TripClipPalette.accent400,
    borderSubtle: TripClipPalette.neutral850,
    borderBrandPrimary: TripClipPalette.primary500,
    badgeBackground: TripClipPalette.secondary500,
    badgeForeground: Colors.white,
    toastError: TripClipToastScheme.dark(
      background: TripClipPalette.error900.withValues(alpha: 0.55),
      border: TripClipPalette.error400,
      foreground: TripClipPalette.error200,
      iconBackground: TripClipPalette.error500,
    ),
    toastWarning: TripClipToastScheme.dark(
      background: TripClipPalette.warning900.withValues(alpha: 0.45),
      border: TripClipPalette.warning400,
      foreground: TripClipPalette.warning100,
      iconBackground: TripClipPalette.warning500,
    ),
    toastSuccess: TripClipToastScheme.dark(
      background: TripClipPalette.success900.withValues(alpha: 0.55),
      border: TripClipPalette.success400,
      foreground: TripClipPalette.success100,
      iconBackground: TripClipPalette.success500,
    ),
    toastInfo: TripClipToastScheme.dark(
      background: TripClipPalette.tertiary600,
      border: TripClipPalette.primary400,
      foreground: TripClipPalette.accent100,
      iconBackground: TripClipPalette.primary400,
    ),
  );

  @override
  TripClipColors copyWith({
    Color? pageBackground,
    Color? pagePrimary,
    Color? surfaceBackground,
    Color? surfaceMuted,
    Color? textBase,
    Color? textSubtle,
    Color? textFixedOnPrimary,
    Color? iconBase,
    Color? heading,
    Color? borderSubtle,
    Color? borderBrandPrimary,
    Color? badgeBackground,
    Color? badgeForeground,
    TripClipToastScheme? toastError,
    TripClipToastScheme? toastWarning,
    TripClipToastScheme? toastSuccess,
    TripClipToastScheme? toastInfo,
  }) {
    return TripClipColors(
      pageBackground: pageBackground ?? this.pageBackground,
      pagePrimary: pagePrimary ?? this.pagePrimary,
      surfaceBackground: surfaceBackground ?? this.surfaceBackground,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      textBase: textBase ?? this.textBase,
      textSubtle: textSubtle ?? this.textSubtle,
      textFixedOnPrimary: textFixedOnPrimary ?? this.textFixedOnPrimary,
      iconBase: iconBase ?? this.iconBase,
      heading: heading ?? this.heading,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderBrandPrimary: borderBrandPrimary ?? this.borderBrandPrimary,
      badgeBackground: badgeBackground ?? this.badgeBackground,
      badgeForeground: badgeForeground ?? this.badgeForeground,
      toastError: toastError ?? this.toastError,
      toastWarning: toastWarning ?? this.toastWarning,
      toastSuccess: toastSuccess ?? this.toastSuccess,
      toastInfo: toastInfo ?? this.toastInfo,
    );
  }

  @override
  TripClipColors lerp(ThemeExtension<TripClipColors>? other, double t) {
    if (other is! TripClipColors) return this;
    return TripClipColors(
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      pagePrimary: Color.lerp(pagePrimary, other.pagePrimary, t)!,
      surfaceBackground: Color.lerp(surfaceBackground, other.surfaceBackground, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      textBase: Color.lerp(textBase, other.textBase, t)!,
      textSubtle: Color.lerp(textSubtle, other.textSubtle, t)!,
      textFixedOnPrimary:
          Color.lerp(textFixedOnPrimary, other.textFixedOnPrimary, t)!,
      iconBase: Color.lerp(iconBase, other.iconBase, t)!,
      heading: Color.lerp(heading, other.heading, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderBrandPrimary:
          Color.lerp(borderBrandPrimary, other.borderBrandPrimary, t)!,
      badgeBackground: Color.lerp(badgeBackground, other.badgeBackground, t)!,
      badgeForeground: Color.lerp(badgeForeground, other.badgeForeground, t)!,
      toastError: toastError.lerp(other.toastError, t),
      toastWarning: toastWarning.lerp(other.toastWarning, t),
      toastSuccess: toastSuccess.lerp(other.toastSuccess, t),
      toastInfo: toastInfo.lerp(other.toastInfo, t),
    );
  }
}

@immutable
class TripClipToastScheme {
  const TripClipToastScheme({
    required this.background,
    required this.border,
    required this.foreground,
    required this.divider,
    required this.iconBackground,
    required this.iconForeground,
  });

  factory TripClipToastScheme.light({
    required Color background,
    required Color border,
    required Color foreground,
    required Color iconBackground,
    Color iconForeground = Colors.white,
  }) {
    return TripClipToastScheme(
      background: background,
      border: border,
      foreground: foreground,
      divider: foreground.withValues(alpha: 0.35),
      iconBackground: iconBackground,
      iconForeground: iconForeground,
    );
  }

  factory TripClipToastScheme.dark({
    required Color background,
    required Color border,
    required Color foreground,
    required Color iconBackground,
    Color iconForeground = Colors.white,
  }) {
    return TripClipToastScheme(
      background: background,
      border: border,
      foreground: foreground,
      divider: foreground.withValues(alpha: 0.35),
      iconBackground: iconBackground,
      iconForeground: iconForeground,
    );
  }

  final Color background;
  final Color border;
  final Color foreground;
  final Color divider;
  final Color iconBackground;
  final Color iconForeground;

  TripClipToastScheme lerp(TripClipToastScheme other, double t) {
    return TripClipToastScheme(
      background: Color.lerp(background, other.background, t)!,
      border: Color.lerp(border, other.border, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      iconBackground: Color.lerp(iconBackground, other.iconBackground, t)!,
      iconForeground: Color.lerp(iconForeground, other.iconForeground, t)!,
    );
  }
}

extension TripClipColorsX on BuildContext {
  TripClipColors get tripClipColors =>
      Theme.of(this).extension<TripClipColors>()!;
}
