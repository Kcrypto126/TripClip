import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../foundations/app_spacing.dart';

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

  static const double padVertical = 3;
  static const double padHorizontal = 4;

  static const double _thumbLeftOff = padHorizontal;
  static const double _thumbLeftOn = trackWidth - padHorizontal - thumbWidth;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color trackColor;
    final Color thumbColor;
    final subtle = context.tripClipColors.borderSubtle;
    if (isDark) {
      trackColor = value
          ? TripClipPalette.tertiary300
          : subtle;
      thumbColor = value
          ? subtle
          : TripClipPalette.tertiary300;
    } else {
      trackColor = value
          ? TripClipPalette.tertiary500
          : subtle;
      thumbColor = value
          ? subtle
          : TripClipPalette.tertiary500;
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
      final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: context.tripClipColors.textBase,
      );
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: Text(label!.trim(), style: labelStyle)),
          const SizedBox(width: AppSpacing.sm),
          toggle,
        ],
      );
    }

    return toggle;
  }
}
