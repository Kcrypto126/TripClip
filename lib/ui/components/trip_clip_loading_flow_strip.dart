import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_palette.dart';

/// Loading strip: 5 dots where the leading dot morphs into a pill and flows
/// to the right infinitely.
///
/// - Dots: **6×6**
/// - Active pill: **16×6**
/// - Light color: **#8E97A3** ([TripClipPalette.neutral500])
/// - Dark color: **#5B636F** ([TripClipPalette.neutral700])
class TripClipLoadingFlowStrip extends StatefulWidget {
  const TripClipLoadingFlowStrip({
    super.key,
    this.duration = const Duration(milliseconds: 1200),
    this.verticalPadding = 10,
  });

  /// One full cycle (from dot 0 → dot 4) duration.
  final Duration duration;

  final double verticalPadding;

  static const int dotCount = 5;
  static const double dotSize = 8;
  static const double pillWidth = 16;
  static const double gap = 6;

  static double get groupWidth =>
      dotCount * dotSize + (dotCount - 1) * gap;

  @override
  State<TripClipLoadingFlowStrip> createState() =>
      _TripClipLoadingFlowStripState();
}

class _TripClipLoadingFlowStripState extends State<TripClipLoadingFlowStrip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static Color _shapeColor(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    return light ? TripClipPalette.neutral500 : TripClipPalette.neutral700;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void didUpdateWidget(covariant TripClipLoadingFlowStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      _controller
        ..reset()
        ..repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _shapeColor(context);
    final v = widget.verticalPadding;
    final step =
        TripClipLoadingFlowStrip.dotSize + TripClipLoadingFlowStrip.gap;
    final travel = step * (TripClipLoadingFlowStrip.dotCount - 1);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: v),
      child: SizedBox(
        height: TripClipLoadingFlowStrip.dotSize,
        width: double.infinity,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = Curves.linear.transform(_controller.value);
            final x = t * travel;

            return Center(
              child: SizedBox(
                width: TripClipLoadingFlowStrip.groupWidth,
                height: TripClipLoadingFlowStrip.dotSize,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        TripClipLoadingFlowStrip.dotCount,
                        (i) => Padding(
                          padding: EdgeInsetsDirectional.only(
                            end: i == TripClipLoadingFlowStrip.dotCount - 1
                                ? 0
                                : TripClipLoadingFlowStrip.gap,
                          ),
                          child: Container(
                            width: TripClipLoadingFlowStrip.dotSize,
                            height: TripClipLoadingFlowStrip.dotSize,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      start: x,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: TripClipLoadingFlowStrip.pillWidth,
                        height: TripClipLoadingFlowStrip.dotSize,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(
                            TripClipLoadingFlowStrip.dotSize / 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
