import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_palette.dart';
import '../../foundations/app_spacing.dart';

/// `form-toggle` — track **48×24**; inner thumb **24×18**, inset **3** vertical / **4** horizontal.
/// Off: thumb **left**; on: thumb **right**.
///
/// **Light:** track `#DCE1E6` / `#141E46`; thumb `#141E46` / `#DCE1E6`.
/// **Dark:** track `#2E343D` / `#7C86AE`; thumb `#7C86AE` / `#2E343D`.
///
/// Disabled: **40%** opacity when [onChanged] is null.
class TripClipFormToggle extends StatelessWidget {
  const TripClipFormToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  static const double trackWidth = 48;
  static const double trackHeight = 24;

  static const double thumbWidth = 24;
  static const double thumbHeight = 18;

  /// Vertical / horizontal padding of thumb inside the track.
  static const double padVertical = 3;
  static const double padHorizontal = 4;

  static const double _thumbLeftOff = padHorizontal;
  static const double _thumbLeftOn =
      trackWidth - padHorizontal - thumbWidth; // 20

  static const Color labelColorLight = Color(0xFF141E46);
  static const Color labelColorDark = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color trackColor;
    final Color thumbColor;
    if (isDark) {
      trackColor =
          value ? TripClipPalette.tertiary300 : TripClipPalette.neutral850;
      thumbColor =
          value ? TripClipPalette.neutral850 : TripClipPalette.tertiary300;
    } else {
      trackColor =
          value ? TripClipPalette.tertiary500 : TripClipPalette.neutral200;
      thumbColor =
          value ? TripClipPalette.neutral200 : TripClipPalette.tertiary500;
    }

    Widget toggle = Semantics(
      toggled: value,
      enabled: enabled,
      label: label,
      child: GestureDetector(
        onTap: enabled ? () => onChanged!(!value) : null,
        child: SizedBox(
          width: trackWidth,
          height: trackHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(trackHeight / 2),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: trackWidth,
                  height: trackHeight,
                  color: trackColor,
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  left: value ? _thumbLeftOn : _thumbLeftOff,
                  top: padVertical,
                  width: thumbWidth,
                  height: thumbHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: thumbColor,
                      borderRadius: BorderRadius.circular(thumbHeight / 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!enabled) {
      toggle = Opacity(opacity: 0.4, child: toggle);
    }

    if (label != null && label!.trim().isNotEmpty) {
      final labelStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 16,
            height: 24 / 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            color: isDark ? labelColorDark : labelColorLight,
          );
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(label!.trim(), style: labelStyle),
          ),
          const SizedBox(width: AppSpacing.sm),
          toggle,
        ],
      );
    }

    return toggle;
  }
}
