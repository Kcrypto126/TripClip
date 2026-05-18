import 'package:flutter/material.dart';

abstract final class TripClipCardShadows {
  static const List<BoxShadow> light = [
    BoxShadow(color: Color(0x40FFFFFF), blurRadius: 4, offset: Offset(0, 2)),
  ];

  static List<BoxShadow>? whenLight(bool isLight) => isLight ? light : null;
}
