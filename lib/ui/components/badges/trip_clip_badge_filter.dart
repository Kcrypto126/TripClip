import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/trip_clip_palette.dart';

class TripClipBadgeFilter extends StatelessWidget {
  const TripClipBadgeFilter({
    super.key,
    required this.label,
    this.svgAsset = 'assets/icons/house.svg',
  });

  final String label;

  final String svgAsset;

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final background =
        light ? TripClipPalette.neutral100 : TripClipPalette.neutral900;
    final borderColor =
        light ? TripClipPalette.neutral200 : TripClipPalette.neutral850;
    final foreground =
        light ? TripClipPalette.neutral600 : TripClipPalette.neutral300;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgAsset,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 18 / 12,
                  letterSpacing: 0,
                  color: foreground,
                ),
          ),
        ],
      ),
    );
  }
}
