import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_colors.dart';
import '../foundations/app_spacing.dart';
import 'cards/trip_clip_card_shadows.dart';

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
    final light = Theme.of(context).brightness == Brightness.light;
    final r = BorderRadius.circular(12);

    final card = Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: r,
        side: bordered
            ? BorderSide(color: colors.borderSubtle)
            : BorderSide.none,
      ),
      child: Padding(padding: padding, child: child),
    );

    final wrapped = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: r,
        boxShadow: TripClipCardShadows.whenLight(light),
      ),
      child: card,
    );

    if (onTap == null) return wrapped;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: wrapped,
    );
  }
}
