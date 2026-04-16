import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/trip_clip_palette.dart';

class TripClipStepsStatusBar extends StatelessWidget {
  const TripClipStepsStatusBar({
    super.key,
    required this.currentStep,
    this.totalSteps = defaultTotalSteps,
    this.showRightChevron = false,
    this.onStepChanged,
    this.onExitAtFirstStep,
    this.chevronColor,
    this.trackColor,
  }) : assert(totalSteps >= 1);

  static const int defaultTotalSteps = 5;

  final int totalSteps;

  final int currentStep;

  final bool showRightChevron;

  final ValueChanged<int>? onStepChanged;

  final VoidCallback? onExitAtFirstStep;

  /// When set, used instead of theme-based chevron tint (e.g. on brand backgrounds).
  final Color? chevronColor;

  /// When set, used instead of theme-based track color behind the orange progress.
  final Color? trackColor;

  static int clampStep(int step, {int totalSteps = defaultTotalSteps}) =>
      step.clamp(0, totalSteps - 1);

  static double progressWidthFactor(
    int step, {
    int totalSteps = defaultTotalSteps,
  }) {
    final s = clampStep(step, totalSteps: totalSteps);
    if (totalSteps <= 1) return 0;
    return (s / (totalSteps - 1)).clamp(0.0, 1.0);
  }

  static const Color _fillColor = Color(0xFFFA782D);

  static const Color _trackLight = TripClipPalette.neutral200;
  static const Color _trackDark = TripClipPalette.neutral850;

  static const double _barWidth = 220;
  static const double _barHeight = 8;

  static const double _chevronTapSize = 40;
  static const double _chevronIconSize = 24;

  void _handleChevronLeftTap() {
    final s = clampStep(currentStep, totalSteps: totalSteps);
    if (s > 0) {
      onStepChanged?.call(s - 1);
    } else {
      onExitAtFirstStep?.call();
    }
  }

  void _handleChevronRightTap() {
    final s = clampStep(currentStep, totalSteps: totalSteps);
    if (s < totalSteps - 1) {
      onStepChanged?.call(s + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final iconColor =
        chevronColor ?? (light ? TripClipPalette.tertiary500 : Colors.white);
    final resolvedTrackColor = trackColor ?? (light ? _trackLight : _trackDark);
    final widthFactor = progressWidthFactor(
      currentStep,
      totalSteps: totalSteps,
    );
    final clamped = clampStep(currentStep, totalSteps: totalSteps);
    final canGoForward = clamped < totalSteps - 1;

    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: _ChevronCircleButton(
                asset: 'assets/icons/chevron-left.svg',
                iconColor: iconColor,
                onTap: (onStepChanged != null || onExitAtFirstStep != null)
                    ? _handleChevronLeftTap
                    : null,
              ),
            ),
            if (showRightChevron)
              Align(
                alignment: Alignment.centerRight,
                child: _ChevronCircleButton(
                  asset: 'assets/icons/chevron-right.svg',
                  iconColor: iconColor,
                  onTap: onStepChanged != null && canGoForward
                      ? _handleChevronRightTap
                      : null,
                ),
              ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_barHeight / 2),
                child: SizedBox(
                  width: _barWidth,
                  height: _barHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.hardEdge,
                    children: [
                      ColoredBox(color: resolvedTrackColor),
                      PositionedDirectional(
                        start: 0,
                        top: 0,
                        bottom: 0,
                        width: _barWidth * widthFactor,
                        child: const ColoredBox(color: _fillColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChevronCircleButton extends StatelessWidget {
  const _ChevronCircleButton({
    required this.asset,
    required this.iconColor,
    this.onTap,
  });

  final String asset;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: TripClipStepsStatusBar._chevronTapSize,
          height: TripClipStepsStatusBar._chevronTapSize,
          child: Center(
            child: SvgPicture.asset(
              asset,
              width: TripClipStepsStatusBar._chevronIconSize,
              height: TripClipStepsStatusBar._chevronIconSize,
              alignment: Alignment.center,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
