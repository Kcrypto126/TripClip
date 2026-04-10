import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_palette.dart';
import '../foundations/app_spacing.dart';
import 'app_badge.dart';
import 'trip_clip_logo_mark.dart';

class TripClipHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TripClipHomeAppBar({
    super.key,
    this.favoritesCount = 0,
    this.notificationsCount = 0,
    this.onFavoritesPressed,
    this.onNotificationsPressed,
  });

  final int favoritesCount;
  final int notificationsCount;
  final VoidCallback? onFavoritesPressed;
  final VoidCallback? onNotificationsPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: AppSpacing.lg,
      title: Row(
        children: [
          const TripClipLogoMark(),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'TripClip',
            style: theme.textTheme.titleLarge?.copyWith(
              color: TripClipPalette.primary500,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topRight,
            children: [
              IconButton(
                onPressed: onFavoritesPressed,
                icon: const Icon(Icons.favorite_border),
              ),
              if (favoritesCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: AppBadge(count: favoritesCount),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topRight,
            children: [
              IconButton(
                onPressed: onNotificationsPressed,
                icon: const Icon(Icons.notifications_none_rounded),
              ),
              if (notificationsCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: AppBadge(count: notificationsCount),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
