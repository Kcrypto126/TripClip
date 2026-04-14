import 'package:flutter/material.dart';

/// Horizontal rule shared by [TripClipFeatureCard], [TripClipSemiFeatureCard],
/// [TripClipResultCard], and any other card using the same chrome.
class TripClipCardDivider extends StatelessWidget {
  const TripClipCardDivider({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: color,
    );
  }
}
