import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_palette.dart';

/// Placeholder logo mark from brand dots (replace with SVG/asset when ready).
class TripClipLogoMark extends StatelessWidget {
  const TripClipLogoMark({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _dot(TripClipPalette.primary500)),
                Expanded(child: _dot(TripClipPalette.secondary500)),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _dot(TripClipPalette.accent500)),
                Expanded(child: _dot(TripClipPalette.tertiary400)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Padding(
      padding: EdgeInsets.all(size * 0.06),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
