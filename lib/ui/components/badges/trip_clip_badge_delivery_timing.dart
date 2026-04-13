import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/trip_clip_palette.dart';

/// `badge-delivery-timing` — clock + label, orange pill with asymmetric corners.
class TripClipBadgeDeliveryTiming extends StatelessWidget {
  const TripClipBadgeDeliveryTiming({
    super.key,
    required this.label,
    this.svgAsset = 'assets/icons/clock.svg',
  });

  final String label;

  /// Defaults to [clock.svg] at **16×16** display size.
  final String svgAsset;

  static const Color _background = TripClipPalette.secondary500;
  static const Color _foreground = Color(0xFFFFFFFF);

  /// CSS order: top-left, top-right, bottom-right, bottom-left → `0 4px 0 12px`.
  static const BorderRadius _radius = BorderRadius.only(
    topLeft: Radius.zero,
    topRight: Radius.circular(4),
    bottomRight: Radius.zero,
    bottomLeft: Radius.circular(12),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        color: _background,
        borderRadius: _radius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgAsset,
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(
              _foreground,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  letterSpacing: 0,
                  color: _foreground,
                ),
          ),
        ],
      ),
    );
  }
}
