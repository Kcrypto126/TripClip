import 'package:flutter/material.dart';

/// Light-mode elevation shared by TripClip card surfaces.
///
/// `#FFFFFF` at 25% opacity; a touch stronger than the minimal 4px blur.
abstract final class TripClipCardShadows {
  static const List<BoxShadow> light = [
    BoxShadow(
      color: Color.fromARGB(255, 252, 8, 8),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static List<BoxShadow>? whenLight(bool isLight) => isLight ? light : null;
}
