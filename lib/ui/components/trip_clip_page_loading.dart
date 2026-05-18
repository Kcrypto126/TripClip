import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_colors.dart';

class TripClipLoadingIndicator extends StatelessWidget {
  const TripClipLoadingIndicator({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: context.tripClipColors.heading,
      ),
    );
  }
}

class TripClipPageLoading extends StatelessWidget {
  const TripClipPageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      label: 'Loading',
      child: ColoredBox(
        color: isDark
            ? Colors.black.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.82),
        child: Center(
          child: TripClipLoadingIndicator(),
        ),
      ),
    );
  }
}

OverlayEntry? _pageLoadingEntry;

void showTripClipPageLoading(BuildContext context) {
  if (_pageLoadingEntry != null) {
    _pageLoadingEntry!.remove();
    _pageLoadingEntry = null;
  }
  final overlay = Overlay.of(context, rootOverlay: true);
  _pageLoadingEntry = OverlayEntry(
    builder: (ctx) {
      return Positioned.fill(
        child: Material(
          type: MaterialType.transparency,
          child: TripClipPageLoading(),
        ),
      );
    },
  );
  overlay.insert(_pageLoadingEntry!);
}

void tryDismissTripClipPageLoading() {
  if (_pageLoadingEntry == null) {
    return;
  }
  _pageLoadingEntry!.remove();
  _pageLoadingEntry = null;
}
