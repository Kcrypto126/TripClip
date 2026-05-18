import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../app/theme/trip_clip_palette.dart';

class TripClipMapPriceMarkerBitmap {
  TripClipMapPriceMarkerBitmap._();

  static const Color _background = TripClipPalette.secondary500;
  static const Color _foreground = Color(0xFFFFFFFF);

  static Future<BitmapDescriptor> build({
    required String priceLabel,
    String? flexibleLabel,
    required double devicePixelRatio,
  }) async {
    const padH = 8.0;
    const padV = 4.0;
    const radius = 4.0;

    final priceStyle = TextStyle(
      color: _foreground,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 26 / 20,
    );
    final flexStyle = TextStyle(
      color: _foreground,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 18 / 12,
    );

    final pricePainter = TextPainter(
      text: TextSpan(text: priceLabel, style: priceStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    TextPainter? flexPainter;
    if (flexibleLabel != null && flexibleLabel.isNotEmpty) {
      flexPainter = TextPainter(
        text: TextSpan(text: flexibleLabel, style: flexStyle),
        textDirection: TextDirection.ltr,
      )..layout();
    }

    final innerW = math.max(
      pricePainter.width,
      flexPainter?.width ?? 0,
    );
    final innerH = pricePainter.height +
        (flexPainter == null ? 0 : 2 + flexPainter.height);

    final logicalW = innerW + padH * 2;
    final logicalH = innerH + padV * 2;

    final wPx = (logicalW * devicePixelRatio).ceil();
    final hPx = (logicalH * devicePixelRatio).ceil();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.scale(devicePixelRatio);

    final rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, logicalW, logicalH),
      const Radius.circular(radius),
    );
    canvas.drawRRect(rRect, Paint()..color = _background);

    var y = padV;
    pricePainter.paint(
      canvas,
      Offset(padH + (innerW - pricePainter.width) / 2, y),
    );
    y += pricePainter.height;
    if (flexPainter != null) {
      y += 2;
      flexPainter.paint(
        canvas,
        Offset(padH + (innerW - flexPainter.width) / 2, y),
      );
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(wPx, hPx);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(
      bytes!.buffer.asUint8List(),
      width: logicalW,
      height: logicalH,
      bitmapScaling: MapBitmapScaling.auto,
    );
  }
}
