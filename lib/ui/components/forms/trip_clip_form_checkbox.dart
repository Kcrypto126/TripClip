import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../foundations/app_spacing.dart';

class TripClipFormCheckbox extends StatelessWidget {
  const TripClipFormCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.labelWidget,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  final String label;
  final Widget? labelWidget;

  static const double _iconSize = 24;
  static const double _checkIconSize = 16;
  static const double _radius = 4;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;

    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: context.tripClipColors.textBase,
    );

    Widget row = Semantics(
      label: label,
      enabled: enabled,
      checked: value,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => onChanged!(!value) : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _TripClipCheckboxIcon(value: value),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: labelWidget ?? Text(label, style: labelStyle),
                ),
              ),
            ),
          ],
     
        ),
      ),
    );

    if (!enabled) {
      row = Opacity(opacity: 0.4, child: row);
    }

    return row;
  }
}

class _TripClipCheckboxIcon extends StatelessWidget {
  const _TripClipCheckboxIcon({required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color fill;
    final Color borderColor;

    if (value) {
      if (isDark) {
        fill = TripClipPalette.tertiary300;
        borderColor = TripClipPalette.tertiary300;
      } else {
        fill = TripClipPalette.tertiary500;
        borderColor = TripClipPalette.tertiary500;
      }
    } else {
      if (isDark) {
        fill = TripClipPalette.neutral900;
        borderColor = TripClipPalette.neutral700;
      } else {
        fill = TripClipPalette.neutral100;
        borderColor = TripClipPalette.neutral500;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        width: TripClipFormCheckbox._iconSize,
        height: TripClipFormCheckbox._iconSize,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(TripClipFormCheckbox._radius),
          border: Border.all(color: borderColor, width: 1),
        ),
        alignment: Alignment.center,
        child: value
            ? Icon(
                Icons.check,
                size: TripClipFormCheckbox._checkIconSize,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
