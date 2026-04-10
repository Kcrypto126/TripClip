import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_palette.dart';
import '../../foundations/app_spacing.dart';

/// `form-radio` — **24px** circle with **2px** outer padding, **8px** gap to label, **16/24** w400.
///
/// Selected: **1px** outer border, **#EFF2F5** / **#1F242B** ring, **2px** inset, inner dot **#141E46** / **#7C86AE**.
/// Disabled: entire row at **40%** opacity (same pattern as [TripClipFormInput]).
class TripClipFormRadio<T> extends StatelessWidget {
  const TripClipFormRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String label;

  static const double _iconSize = 24;
  static const double _outerPadding = 2;
  static const double _selectedInnerInset = 2;

  /// Light mode label (`#141E46`).
  static const Color labelColorLight = Color(0xFF141E46);

  /// Dark mode label (`#FFFFFF`).
  static const Color labelColorDark = Color(0xFFFFFFFF);

  bool get _selected => groupValue == value;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final labelStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: isDark ? labelColorDark : labelColorLight,
        );

    Widget row = Semantics(
      label: label,
      enabled: enabled,
      selected: _selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => onChanged!(value) : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _TripClipRadioIcon(
              selected: _selected,
              isDark: isDark,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(label, style: labelStyle),
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

class _TripClipRadioIcon extends StatelessWidget {
  const _TripClipRadioIcon({
    required this.selected,
    required this.isDark,
  });

  final bool selected;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Widget core;
    if (selected) {
      final borderColor =
          isDark ? TripClipPalette.tertiary300 : TripClipPalette.tertiary500;
      final ringFill =
          isDark ? TripClipPalette.neutral900 : TripClipPalette.neutral100;
      final innerColor =
          isDark ? TripClipPalette.tertiary300 : TripClipPalette.tertiary500;

      core = Container(
        width: TripClipFormRadio._iconSize,
        height: TripClipFormRadio._iconSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ringFill,
          border: Border.all(color: borderColor, width: 1),
        ),
        padding: const EdgeInsets.all(TripClipFormRadio._selectedInnerInset),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: innerColor,
          ),
        ),
      );
    } else {
      final borderColor =
          isDark ? TripClipPalette.neutral700 : TripClipPalette.neutral500;
      final bg =
          isDark ? TripClipPalette.darkPageBackground : Colors.white;

      core = Container(
        width: TripClipFormRadio._iconSize,
        height: TripClipFormRadio._iconSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bg,
          border: Border.all(color: borderColor, width: 1),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(TripClipFormRadio._outerPadding),
      child: core,
    );
  }
}
