import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_palette.dart';
import '../../foundations/app_spacing.dart';

class TripClipFormSlider extends StatelessWidget {
  const TripClipFormSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.labelLeft,
    required this.labelRight,
    this.title,
    this.divisions,
  });

  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final String labelLeft;
  final String labelRight;
  final String? title;
  final int? divisions;

  static const double _radius = 8;
  static const double _trackHeight = 4;
  static const double _thumbRadius = 12;

  static const Color _textLight = Color(0xFF141E46);
  static const Color _textDark = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg =
        isDark ? TripClipPalette.neutral900 : TripClipPalette.neutral100;
    final activeTrack =
        isDark ? TripClipPalette.tertiary300 : TripClipPalette.tertiary500;
    final inactiveTrack =
        isDark ? TripClipPalette.neutral700 : TripClipPalette.neutral300;
    final thumbColor =
        isDark ? TripClipPalette.tertiary300 : TripClipPalette.tertiary500;
    final textColor = isDark ? _textDark : _textLight;

    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: textColor,
        );

    final clamped = value.clamp(min, max);

    Widget slider = SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: _trackHeight,
        activeTrackColor: activeTrack,
        inactiveTrackColor: inactiveTrack,
        thumbColor: thumbColor,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: _thumbRadius,
          elevation: 2,
          pressedElevation: 3,
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
        trackShape: const RoundedRectSliderTrackShape(),
      ),
      child: Slider(
        value: clamped,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
      ),
    );

    Widget card = Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(labelLeft, style: labelStyle),
              Text(labelRight, style: labelStyle),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          slider,
        ],
      ),
    );

    if (!enabled) {
      card = Opacity(opacity: 0.4, child: card);
    }

    if (title != null && title!.trim().isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title!.trim(), style: labelStyle),
          const SizedBox(height: AppSpacing.sm),
          card,
        ],
      );
    }

    return card;
  }
}
