import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/trip_clip_colors.dart';
import '../../app/theme/trip_clip_palette.dart';
import 'badges/trip_clip_badge_counter.dart';

class TripClipHomeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const TripClipHomeAppBar({
    super.key,
    this.favoritesCount = 0,
    this.notificationsCount = 0,
    this.onLogoPressed,
    this.onFavoritesPressed,
    this.onNotificationsPressed,
  });

  final int favoritesCount;
  final int notificationsCount;
  final VoidCallback? onLogoPressed;
  final VoidCallback? onFavoritesPressed;
  final VoidCallback? onNotificationsPressed;

  static const double toolbarHeight = 56;

  static double _statusBarHeightLogicalPx() {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return 0;
    final view = views.first;
    return view.padding.top / view.devicePixelRatio;
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + _statusBarHeightLogicalPx());

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final iconColor = light
        ? TripClipPalette.neutral600
        : TripClipPalette.neutral300;
    final logoAsset = light
        ? 'assets/icons/home-logo-light.svg'
        : 'assets/icons/home-logo-dark.svg';
    final bg = context.tripClipColors.pageBackground;
    final topInset = MediaQuery.paddingOf(context).top;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: topInset),
        Material(
          color: bg,
          child: Container(
            height: toolbarHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _HeaderLogo(logoAsset: logoAsset, onPressed: onLogoPressed),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _HomeHeaderIconButton(
                      svgAsset: 'assets/icons/heart24.svg',
                      color: iconColor,
                      badgeCount: favoritesCount,
                      onPressed: onFavoritesPressed,
                    ),
                    const SizedBox(width: 4),
                    _HomeHeaderIconButton(
                      svgAsset: 'assets/icons/bell.svg',
                      color: iconColor,
                      badgeCount: notificationsCount,
                      onPressed: onNotificationsPressed,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderLogo extends StatelessWidget {
  const _HeaderLogo({required this.logoAsset, this.onPressed});

  final String logoAsset;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final svg = SvgPicture.asset(
      logoAsset,
      width: 120,
      height: 26,
      fit: BoxFit.contain,
    );
    if (onPressed == null) return svg;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: svg,
        ),
      ),
    );
  }
}

class _HomeHeaderIconButton extends StatelessWidget {
  const _HomeHeaderIconButton({
    required this.svgAsset,
    required this.color,
    required this.badgeCount,
    this.onPressed,
  });

  final String svgAsset;
  final Color color;
  final int badgeCount;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                svgAsset,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              if (badgeCount > 0)
                Positioned(
                  top: 4,
                  right: 3,
                  child: TripClipBadgeCounter(
                    count: badgeCount,
                    hideWhenZero: true,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
