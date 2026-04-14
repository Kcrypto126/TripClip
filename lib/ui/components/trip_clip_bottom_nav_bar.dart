import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/trip_clip_colors.dart';
import '../../app/theme/trip_clip_palette.dart';
import 'badges/trip_clip_badge_counter.dart';

class _TripClipNavDestinationData {
  const _TripClipNavDestinationData(
    this.label,
    this.assetDefault,
    this.assetActive, {
    this.showBadgeSlot = false,
  });

  final String label;
  final String assetDefault;
  final String assetActive;
  final bool showBadgeSlot;
}

const List<_TripClipNavDestinationData> _kDestinations = [
  _TripClipNavDestinationData(
    'Home',
    'assets/icons/home-nav.svg',
    'assets/icons/home-nav-active.svg',
  ),
  _TripClipNavDestinationData(
    'Trips',
    'assets/icons/route.svg',
    'assets/icons/route-active.svg',
  ),
  _TripClipNavDestinationData(
    'Parcels',
    'assets/icons/package.svg',
    'assets/icons/package-active.svg',
  ),
  _TripClipNavDestinationData(
    'Activity',
    'assets/icons/activity.svg',
    'assets/icons/activity-active.svg',
    showBadgeSlot: true,
  ),
  _TripClipNavDestinationData(
    'Account',
    'assets/icons/user-circle.svg',
    'assets/icons/user-circle-active.svg',
  ),
];

class TripClipBottomNavBar extends StatelessWidget {
  static const double height = 80;

  const TripClipBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    this.activityBadgeCount = 0,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  final int activityBadgeCount;

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final defaultFg =
        light ? TripClipPalette.neutral600 : TripClipPalette.neutral300;
    final activeFg =
        light ? TripClipPalette.primary500 : TripClipPalette.primary400;
    final borderColor =
        light ? TripClipPalette.neutral200 : TripClipPalette.neutral850;
    final bg = context.tripClipColors.pageBackground;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          top: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.zero,
        child: SizedBox(
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (var i = 0; i < _kDestinations.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: _TripClipBottomNavItem(
                        data: _kDestinations[i],
                        selected: currentIndex == i,
                        defaultForeground: defaultFg,
                        activeForeground: activeFg,
                        onTap: () => onDestinationSelected(i),
                        badgeCount: _kDestinations[i].showBadgeSlot
                            ? activityBadgeCount
                            : 0,
                      ),
                    ),
                  ),
              ],
            ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TripClipBottomNavItem extends StatelessWidget {
  const _TripClipBottomNavItem({
    required this.data,
    required this.selected,
    required this.defaultForeground,
    required this.activeForeground,
    required this.onTap,
    required this.badgeCount,
  });

  final _TripClipNavDestinationData data;
  final bool selected;
  final Color defaultForeground;
  final Color activeForeground;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? activeForeground : defaultForeground;
    final asset = selected ? data.assetActive : data.assetDefault;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        splashFactory: InkRipple.splashFactory,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        asset,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
                      ),
                      if (data.showBadgeSlot && badgeCount > 0)
                        Positioned(
                          top: -6,
                          right: -10,
                          child: TripClipBadgeCounter(
                            count: badgeCount,
                            hideWhenZero: true,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        letterSpacing: 0,
                        color: fg,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
