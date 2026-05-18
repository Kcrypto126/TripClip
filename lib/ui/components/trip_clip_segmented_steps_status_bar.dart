import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_colors.dart';
import 'trip_clip_step_bar_chevron_button.dart';
import 'trip_clip_steps_status_bar.dart';

class TripClipSegmentedStepsStatusBar extends StatelessWidget {
  const TripClipSegmentedStepsStatusBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onStepChanged,
    this.onExitAtFirstStep,
    this.chevronColor,
    this.trackColor,
    this.fillColor = _fillColor,
    this.chevronMaterialColor,
  }) : assert(totalSteps >= 1);

  final int currentStep;
  final int totalSteps;
  final ValueChanged<int>? onStepChanged;
  final VoidCallback? onExitAtFirstStep;
  final Color? chevronColor;
  final Color? trackColor;
  final Color fillColor;

  final Color? chevronMaterialColor;

  static const Color _fillColor = Color(0xFFFA782D);

  static const double _barWidth = 220;
  static const double _segmentHeight = 8;
  static const double _segmentGap = 2;

  void _handleChevronLeftTap() {
    final s = TripClipStepsStatusBar.clampStep(
      currentStep,
      totalSteps: totalSteps,
    );
    if (s > 0) {
      onStepChanged?.call(s - 1);
    } else {
      onExitAtFirstStep?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = chevronColor ?? context.tripClipColors.textBase;
    final resolvedTrack =
        trackColor ?? context.tripClipColors.borderSubtle;
    final clamped = TripClipStepsStatusBar.clampStep(
      currentStep,
      totalSteps: totalSteps,
    );

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
                  final maxW = constraints.maxWidth;
                  final w = maxW.isFinite && maxW > 0
                      ? math.min(_barWidth, maxW)
                      : _barWidth;
                  return Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: w,
                      height: _segmentHeight,
                      child: Row(
                        children: List.generate(totalSteps, (i) {
                          final active = i <= clamped;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(
                                start: i > 0 ? _segmentGap : 0,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: ColoredBox(
                                  color: active ? fillColor : resolvedTrack,
                                  child: const SizedBox.expand(),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: TripClipStepBarChevronButton.tapSize),
          ],
        ),
      ),
    );
  }
}
