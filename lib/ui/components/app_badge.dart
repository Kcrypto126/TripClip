import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_colors.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.count,
    this.maxCount = 99,
  });

  final int count;
  final int maxCount;

  String get _label {
    if (count <= 0) return '';
    if (count > maxCount) return '$maxCount+';
    return '$count';
  }

  @override
  Widget build(BuildContext context) {
    if (_label.isEmpty) return const SizedBox.shrink();

    final colors = context.tripClipColors;

    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: colors.badgeBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.center,
      child: Text(
        _label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 10,
              height: 1,
              fontWeight: FontWeight.w700,
              color: colors.badgeForeground,
            ),
      ),
    );
  }
}
