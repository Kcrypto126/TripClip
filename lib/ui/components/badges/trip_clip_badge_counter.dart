import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_palette.dart';

/// `badge-counter` — circular count; diameter fits label + **4px** padding on all sides.
class TripClipBadgeCounter extends StatelessWidget {
  const TripClipBadgeCounter({
    super.key,
    required this.count,
    this.hideWhenZero = true,
    this.maxCount = 99,
  });

  /// Shown as a digit, or `"{maxCount}+"` when above [maxCount].
  final int count;

  /// When true and [count] `<= 0`, returns [SizedBox.shrink].
  final bool hideWhenZero;

  final int maxCount;

  static const Color _background = TripClipPalette.secondary500;
  static const Color _foreground = Color(0xFFFFFFFF);
  static const double _padding = 4;

  String get _label {
    final n = count < 0 ? 0 : count;
    if (n > maxCount) return '$maxCount+';
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    if (hideWhenZero && count <= 0) {
      return const SizedBox.shrink();
    }

    final label = _label;
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          height: 1,
          color: _foreground,
        );

    final tp = TextPainter(
      text: TextSpan(text: label, style: style),
      textDirection: Directionality.of(context),
      maxLines: 1,
    )..layout();

    final side = math.max(tp.width, tp.height) + 2 * _padding;

    return SizedBox(
      width: side,
      height: side,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: _background,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: style,
          ),
        ),
      ),
    );
  }
}
