import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_colors.dart';
import 'trip_clip_step_bar_chevron_button.dart';

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
    this.chevronMaterialColor,
  }) : assert(totalSteps >= 1);

  static const int defaultTotalSteps = 5;

  final int totalSteps;

  final int currentStep;

  final bool showRightChevron;

  final ValueChanged<int>? onStepChanged;

  final VoidCallback? onExitAtFirstStep;

  final Color? chevronColor;

  final Color? trackColor;

  final Color? chevronMaterialColor;

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

  static const double _barWidth = 220;
  static const double _barHeight = 8;

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
    final iconColor = chevronColor ?? context.tripClipColors.textBase;
    final resolvedTrackColor =
        trackColor ?? context.tripClipColors.borderSubtle;
    final widthFactor = progressWidthFactor(
      currentStep,
      totalSteps: totalSteps,
    );
    final clamped = clampStep(currentStep, totalSteps: totalSteps);
    final canGoForward = clamped < totalSteps - 1;

    return SizedBox(
      width: double.infinity,
      height: TripClipStepBarChevronButton.tapSize,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TripClipStepBarChevronButton(
              asset: 'assets/icons/chevron-left.svg',
              iconColor: iconColor,
              materialColor: chevronMaterialColor,
              onTap: (onStepChanged != null || onExitAtFirstStep != null)
                  ? _handleChevronLeftTap
                  : null,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = math.min(_barWidth, constraints.maxWidth);
                  return Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_barHeight / 2),
                      child: SizedBox(
                        width: w,
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
                              width: w * widthFactor,
                              child: const ColoredBox(color: _fillColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            showRightChevron
                ? TripClipStepBarChevronButton(
                    asset: 'assets/icons/chevron-right.svg',
                    iconColor: iconColor,
                    materialColor: chevronMaterialColor,
                    alignEnd: true,
                    onTap: onStepChanged != null && canGoForward
                        ? _handleChevronRightTap
                        : null,
                  )
                : const SizedBox(width: TripClipStepBarChevronButton.tapSize),
          ],
        ),
      ),
    );
  }
}
