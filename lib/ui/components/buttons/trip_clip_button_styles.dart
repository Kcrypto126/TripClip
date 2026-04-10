import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_palette.dart';
import 'trip_clip_button_models.dart';

/// Visual tokens and [ButtonStyle] factories for [TripClipButton].
abstract final class TripClipButtonStyles {
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 10,
  );

  static const double _labelFontSize = 16;
  static const double _labelLineHeight = 24;
  static const double _letterSpacingPercent = 0.02;

  static const double iconSize = 24;
  static const double iconGap = 4;

  static const double _disabledOpacity = 0.4;

  static TextStyle? labelTextStyle(ThemeData theme) {
    final base = theme.textTheme.bodyMedium;
    return base?.copyWith(
      fontSize: _labelFontSize,
      height: _labelLineHeight / _labelFontSize,
      fontWeight: FontWeight.w500,
      letterSpacing: _labelFontSize * _letterSpacingPercent,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static ButtonStyle style(
    BuildContext context,
    TripClipButtonVariant variant, {
    required bool iconOnly,
  }) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final isDark = brightness == Brightness.dark;
    final labelStyle = labelTextStyle(theme);

    final shape = iconOnly
        ? const CircleBorder()
        : const StadiumBorder();

    final padding = contentPadding;

    /// Icon-only: keep ≥48dp touch target; spec padding centers the 24dp icon.
    final minSize = iconOnly ? const Size(56, 56) : const Size(48, 44);

    final overlayClear = WidgetStateProperty.all<Color?>(Colors.transparent);

    switch (variant) {
      case TripClipButtonVariant.primary:
        final def = isDark ? TripClipPalette.primary400 : TripClipPalette.primary500;
        final pressed =
            isDark ? TripClipPalette.primary500 : TripClipPalette.primary600;

        return ButtonStyle(
          minimumSize: WidgetStateProperty.all(minSize),
          padding: WidgetStateProperty.all(padding),
          textStyle: WidgetStateProperty.all(labelStyle),
          shape: WidgetStateProperty.all(shape),
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          overlayColor: overlayClear,
          splashFactory: NoSplash.splashFactory,
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.white.withValues(alpha: _disabledOpacity);
            }
            return Colors.white;
          }),
          iconColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.white.withValues(alpha: _disabledOpacity);
            }
            return Colors.white;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return def.withValues(alpha: _disabledOpacity);
            }
            if (states.contains(WidgetState.pressed)) return pressed;
            return def;
          }),
        );

      case TripClipButtonVariant.primaryAlternative:
        const def = TripClipPalette.secondary500;
        const pressed = TripClipPalette.secondary600;

        return ButtonStyle(
          minimumSize: WidgetStateProperty.all(minSize),
          padding: WidgetStateProperty.all(padding),
          textStyle: WidgetStateProperty.all(labelStyle),
          shape: WidgetStateProperty.all(shape),
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          overlayColor: overlayClear,
          splashFactory: NoSplash.splashFactory,
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.white.withValues(alpha: _disabledOpacity);
            }
            return Colors.white;
          }),
          iconColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.white.withValues(alpha: _disabledOpacity);
            }
            return Colors.white;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return def.withValues(alpha: _disabledOpacity);
            }
            if (states.contains(WidgetState.pressed)) return pressed;
            return def;
          }),
        );

      case TripClipButtonVariant.secondary:
        if (isDark) {
          const defFg = TripClipPalette.primary400;
          const idleBg = TripClipPalette.darkPageBackground;
          const pressedBg = TripClipPalette.neutral900;

          return ButtonStyle(
            minimumSize: WidgetStateProperty.all(minSize),
            padding: WidgetStateProperty.all(padding),
            textStyle: WidgetStateProperty.all(labelStyle),
            shape: WidgetStateProperty.all(shape),
            elevation: WidgetStateProperty.all(0),
            overlayColor: overlayClear,
            splashFactory: NoSplash.splashFactory,
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return defFg.withValues(alpha: _disabledOpacity);
              }
              return defFg;
            }),
            iconColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return defFg.withValues(alpha: _disabledOpacity);
              }
              return defFg;
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return idleBg.withValues(alpha: _disabledOpacity);
              }
              if (states.contains(WidgetState.pressed)) return pressedBg;
              return idleBg;
            }),
            side: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return BorderSide(
                  color: defFg.withValues(alpha: _disabledOpacity),
                );
              }
              return const BorderSide(color: defFg);
            }),
          );
        }

        const defFg = TripClipPalette.primary500;
        const idleBg = Color(0xFFFFFFFF);
        const pressedBg = TripClipPalette.neutral100;

        return ButtonStyle(
          minimumSize: WidgetStateProperty.all(minSize),
          padding: WidgetStateProperty.all(padding),
          textStyle: WidgetStateProperty.all(labelStyle),
          shape: WidgetStateProperty.all(shape),
          elevation: WidgetStateProperty.all(0),
          overlayColor: overlayClear,
          splashFactory: NoSplash.splashFactory,
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return defFg.withValues(alpha: _disabledOpacity);
            }
            return defFg;
          }),
          iconColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return defFg.withValues(alpha: _disabledOpacity);
            }
            return defFg;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return idleBg.withValues(alpha: _disabledOpacity);
            }
            if (states.contains(WidgetState.pressed)) return pressedBg;
            return idleBg;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(color: defFg.withValues(alpha: _disabledOpacity));
            }
            return const BorderSide(color: defFg);
          }),
        );

      case TripClipButtonVariant.tertiary:
        if (isDark) {
          const defFg = TripClipPalette.primary400;

          return ButtonStyle(
            minimumSize: WidgetStateProperty.all(minSize),
            padding: WidgetStateProperty.all(padding),
            textStyle: WidgetStateProperty.all(labelStyle),
            shape: WidgetStateProperty.all(shape),
            elevation: WidgetStateProperty.all(0),
            overlayColor: overlayClear,
            splashFactory: NoSplash.splashFactory,
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return defFg.withValues(alpha: _disabledOpacity);
              }
              return defFg;
            }),
            iconColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return defFg.withValues(alpha: _disabledOpacity);
              }
              return defFg;
            }),
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            side: WidgetStateProperty.all(BorderSide.none),
          );
        }

        const defFg = TripClipPalette.primary500;
        const pressedFg = TripClipPalette.primary700;

        return ButtonStyle(
          minimumSize: WidgetStateProperty.all(minSize),
          padding: WidgetStateProperty.all(padding),
          textStyle: WidgetStateProperty.all(labelStyle),
          shape: WidgetStateProperty.all(shape),
          elevation: WidgetStateProperty.all(0),
          overlayColor: overlayClear,
          splashFactory: NoSplash.splashFactory,
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return defFg.withValues(alpha: _disabledOpacity);
            }
            if (states.contains(WidgetState.pressed)) return pressedFg;
            return defFg;
          }),
          iconColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return defFg.withValues(alpha: _disabledOpacity);
            }
            if (states.contains(WidgetState.pressed)) return pressedFg;
            return defFg;
          }),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
        );

      case TripClipButtonVariant.destructive:
        final def =
            isDark ? TripClipPalette.error400 : TripClipPalette.error500;
        final pressed =
            isDark ? TripClipPalette.error500 : TripClipPalette.error600;

        return ButtonStyle(
          minimumSize: WidgetStateProperty.all(minSize),
          padding: WidgetStateProperty.all(padding),
          textStyle: WidgetStateProperty.all(labelStyle),
          shape: WidgetStateProperty.all(shape),
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          overlayColor: overlayClear,
          splashFactory: NoSplash.splashFactory,
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.white.withValues(alpha: _disabledOpacity);
            }
            return Colors.white;
          }),
          iconColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.white.withValues(alpha: _disabledOpacity);
            }
            return Colors.white;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return def.withValues(alpha: _disabledOpacity);
            }
            if (states.contains(WidgetState.pressed)) return pressed;
            return def;
          }),
        );
    }
  }
}
