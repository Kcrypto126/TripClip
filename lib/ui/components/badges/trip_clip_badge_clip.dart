import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_palette.dart';

class TripClipBadgeClip extends StatelessWidget {
  const TripClipBadgeClip({
    super.key,
    required this.label,
    this.flexibleLabel,
  });

  final String label;
  final String? flexibleLabel;

  static const Color _background = TripClipPalette.secondary500;
  static const Color _foreground = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 26 / 20,
                  letterSpacing: 0,
                  color: _foreground,
                ),
          ),
          if (flexibleLabel != null) ...[
            const SizedBox(height: 2),
            Text(
              flexibleLabel!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 18 / 12,
                    letterSpacing: 0,
                    color: _foreground,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
