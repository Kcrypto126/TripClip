import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_colors.dart';
import '../foundations/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.bordered = true,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;

  /// When false, removes the outline (full-bleed panels).
  final bool bordered;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.tripClipColors;
    final card = Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: bordered
            ? BorderSide(color: colors.borderSubtle)
            : BorderSide.none,
      ),
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) return card;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: card,
    );
  }
}
