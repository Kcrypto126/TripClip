import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_palette.dart';
import 'trip_clip_form_models.dart';

class _FormSemanticChrome {
  const _FormSemanticChrome({
    required this.idleFill,
    required this.idleBorder,
    required this.accentBorder,
    required this.foreground,
    required this.hintOrPlaceholder,
    required this.helper,
  });

  final Color idleFill;
  final Color idleBorder;
  final Color accentBorder;
  final Color foreground;
  final Color hintOrPlaceholder;
  final Color helper;
}

class TripClipFormFieldDecoration {
  const TripClipFormFieldDecoration({
    required this.fill,
    required this.borderColor,
    required this.borderWidth,
    required this.foreground,
    required this.hintOrPlaceholder,
    required this.label,
    required this.helper,
  });

  final Color fill;
  final Color borderColor;
  final double borderWidth;
  final Color foreground;
  final Color hintOrPlaceholder;
  final Color label;
  final Color helper;

  static const double borderThin = 1;
  static const double borderFocus = 2;

  static TripClipFormFieldDecoration field({
    required bool isDark,
    required bool enabled,
    required bool hasValue,
    required bool focused,
    required TripClipFormStatus status,
    TripClipFormDensity density = TripClipFormDensity.standard,
  }) {
    if (!enabled) {
      return _fieldDisabled(isDark: isDark, density: density);
    }

    switch (status) {
      case TripClipFormStatus.none:
        break;
      case TripClipFormStatus.error:
        return _semanticFixedField(
          isDark: isDark,
          chrome: _semanticChromeError(isDark),
        );
      case TripClipFormStatus.warning:
        return _semanticFixedField(
          isDark: isDark,
          chrome: _semanticChromeWarning(isDark),
        );
      case TripClipFormStatus.success:
        return _semanticFixedField(
          isDark: isDark,
          chrome: _semanticChromeSuccess(isDark),
        );
    }

    if (focused) {
      return _fieldFocused(isDark: isDark, density: density);
    }
    if (hasValue) {
      return _fieldActiveFilled(isDark: isDark, density: density);
    }
    return _fieldDefault(isDark: isDark, density: density);
  }

  static TripClipFormFieldDecoration _semanticFixedField({
    required bool isDark,
    required _FormSemanticChrome chrome,
  }) {
    final label = isDark ? Colors.white : TripClipPalette.tertiary500;

    return TripClipFormFieldDecoration(
      fill: chrome.idleFill,
      borderColor: chrome.idleBorder,
      borderWidth: borderThin,
      foreground: chrome.foreground,
      hintOrPlaceholder: chrome.hintOrPlaceholder,
      label: label,
      helper: chrome.helper,
    );
  }

  static _FormSemanticChrome _semanticChromeError(bool isDark) {
    if (isDark) {
      const fg = Color(0xFFFFBFB9);
      return _FormSemanticChrome(
        idleFill: const Color(0xFF5E1C16),
        idleBorder: const Color(0xFFF66659),
        accentBorder: const Color(0xFFF66659),
        foreground: fg,
        hintOrPlaceholder: const Color(0xFFFF9188),
        helper: const Color(0xFFFF9188),
      );
    }
    const fg = Color(0xFFA4332B);
    return _FormSemanticChrome(
      idleFill: const Color(0xFFFFE4E1),
      idleBorder: fg,
      accentBorder: fg,
      foreground: fg,
      hintOrPlaceholder: const Color(0xFFC33F35),
      helper: const Color(0xFFC33F35),
    );
  }

  static _FormSemanticChrome _semanticChromeWarning(bool isDark) {
    if (isDark) {
      const fg = Color(0xFFFDEEB3);
      return _FormSemanticChrome(
        idleFill: const Color(0xFF7A5207),
        idleBorder: const Color(0xFFF6CA54),
        accentBorder: const Color(0xFFF6CA54),
        foreground: fg,
        hintOrPlaceholder: const Color(0xFFFAD971),
        helper: const Color(0xFFFAD971),
      );
    }
    const fg = Color(0xFF9E6E0F);
    return _FormSemanticChrome(
      idleFill: const Color(0xFFFFF8E1),
      idleBorder: fg,
      accentBorder: fg,
      foreground: fg,
      hintOrPlaceholder: fg,
      helper: fg,
    );
  }

  static _FormSemanticChrome _semanticChromeSuccess(bool isDark) {
    if (isDark) {
      const fg = Color(0xFFB4E8CF);
      return _FormSemanticChrome(
        idleFill: const Color(0xFF0C4D35),
        idleBorder: const Color(0xFF52C890),
        accentBorder: const Color(0xFF52C890),
        foreground: fg,
        hintOrPlaceholder: const Color(0xFF86D9B3),
        helper: const Color(0xFF86D9B3),
      );
    }
    const fg = Color(0xFF1C845C);
    return _FormSemanticChrome(
      idleFill: const Color(0xFFD9F4E7),
      idleBorder: fg,
      accentBorder: fg,
      foreground: fg,
      hintOrPlaceholder: fg,
      helper: fg,
    );
  }

  static TripClipFormFieldDecoration _fieldDefault({
    required bool isDark,
    required TripClipFormDensity density,
  }) {
    if (isDark) {
      return TripClipFormFieldDecoration(
        fill: TripClipPalette.neutral900,
        borderColor: TripClipPalette.neutral700,
        borderWidth: borderThin,
        foreground: Colors.white,
        hintOrPlaceholder: TripClipPalette.neutral600,
        label: Colors.white,
        helper: TripClipPalette.neutral300,
      );
    }
    return TripClipFormFieldDecoration(
      fill: TripClipPalette.neutral100,
      borderColor: TripClipPalette.neutral500,
      borderWidth: borderThin,
      foreground: TripClipPalette.tertiary500,
      hintOrPlaceholder: TripClipPalette.neutral500,
      label: TripClipPalette.tertiary500,
      helper: TripClipPalette.neutral600,
    );
  }

  static TripClipFormFieldDecoration _fieldActiveFilled({
    required bool isDark,
    required TripClipFormDensity density,
  }) {
    if (isDark) {
      return TripClipFormFieldDecoration(
        fill: TripClipPalette.darkPageBackground,
        borderColor: TripClipPalette.primary400,
        borderWidth: borderThin,
        foreground: Colors.white,
        hintOrPlaceholder: TripClipPalette.neutral600,
        label: Colors.white,
        helper: TripClipPalette.neutral300,
      );
    }
    return TripClipFormFieldDecoration(
      fill: Colors.white,
      borderColor: TripClipPalette.primary500,
      borderWidth: borderThin,
      foreground: TripClipPalette.tertiary500,
      hintOrPlaceholder: TripClipPalette.neutral500,
      label: TripClipPalette.tertiary500,
      helper: TripClipPalette.neutral600,
    );
  }

  static TripClipFormFieldDecoration _fieldFocused({
    required bool isDark,
    required TripClipFormDensity density,
  }) {
    if (isDark) {
      return TripClipFormFieldDecoration(
        fill: TripClipPalette.darkPageBackground,
        borderColor: TripClipPalette.primary400,
        borderWidth: borderFocus,
        foreground: Colors.white,
        hintOrPlaceholder: TripClipPalette.neutral600,
        label: Colors.white,
        helper: TripClipPalette.neutral300,
      );
    }
    return TripClipFormFieldDecoration(
      fill: Colors.white,
      borderColor: TripClipPalette.primary500,
      borderWidth: borderFocus,
      foreground: TripClipPalette.tertiary500,
      hintOrPlaceholder: TripClipPalette.neutral500,
      label: TripClipPalette.tertiary500,
      helper: TripClipPalette.neutral600,
    );
  }

  static TripClipFormFieldDecoration _fieldDisabled({
    required bool isDark,
    required TripClipFormDensity density,
  }) {
    return _fieldDefault(isDark: isDark, density: density);
  }

  static TripClipFormFieldDecoration atom({
    required bool isDark,
    required bool enabled,
    required bool focused,
    required bool hasValue,
    required TripClipFormStatus status,
  }) {
    if (!enabled) {
      return _fieldDisabled(
        isDark: isDark,
        density: TripClipFormDensity.standard,
      );
    }

    switch (status) {
      case TripClipFormStatus.none:
        break;
      case TripClipFormStatus.error:
        return _semanticFixedField(
          isDark: isDark,
          chrome: _semanticChromeError(isDark),
        );
      case TripClipFormStatus.warning:
        return _semanticFixedField(
          isDark: isDark,
          chrome: _semanticChromeWarning(isDark),
        );
      case TripClipFormStatus.success:
        return _semanticFixedField(
          isDark: isDark,
          chrome: _semanticChromeSuccess(isDark),
        );
    }

    if (focused) {
      return _fieldFocused(
        isDark: isDark,
        density: TripClipFormDensity.standard,
      );
    }
    if (hasValue) {
      return _fieldActiveFilled(
        isDark: isDark,
        density: TripClipFormDensity.standard,
      );
    }
    return _fieldDefault(
      isDark: isDark,
      density: TripClipFormDensity.standard,
    );
  }

  TripClipFormFieldDecoration copyWith({
    Color? fill,
    Color? borderColor,
    double? borderWidth,
    Color? foreground,
    Color? hintOrPlaceholder,
    Color? label,
    Color? helper,
  }) {
    return TripClipFormFieldDecoration(
      fill: fill ?? this.fill,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      foreground: foreground ?? this.foreground,
      hintOrPlaceholder: hintOrPlaceholder ?? this.hintOrPlaceholder,
      label: label ?? this.label,
      helper: helper ?? this.helper,
    );
  }
}
