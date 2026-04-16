import 'package:flutter/material.dart';

/// Light-mode elevation shared by TripClip card surfaces.
///
/// `#FFFFFF` at 25% opacity; a touch stronger than the minimal 4px blur.
abstract final class TripClipCardShadows {
  static const List<BoxShadow> light = [
    BoxShadow(
      color: Color(0x40FFFFFF),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static List<BoxShadow>? whenLight(bool isLight) => isLight ? light : null;
}
