import 'package:flutter/material.dart';

import 'trip_clip_badge_icon_label.dart';

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
    return TripClipBadgeIconLabel(label: label, svgAsset: svgAsset);
  }
}
