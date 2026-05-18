import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../trip_clip_steps_status_bar.dart';

class TripClipSteppedTitlePageScaffold extends StatelessWidget {
  const TripClipSteppedTitlePageScaffold({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.title,
    required this.body,
    this.bottomBar,
    this.onStepChanged,
    this.onExitAtFirstStep,
    this.contentPadding = const EdgeInsets.all(16),
  }) : assert(totalSteps >= 1);

  final int currentStep;
  final int totalSteps;

  final String title;

  final Widget body;

  final Widget? bottomBar;

  final ValueChanged<int>? onStepChanged;
  final VoidCallback? onExitAtFirstStep;

  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    final pageBg = context.tripClipColors.pageBackground;
    final titleStyle = Theme.of(context).textTheme.headlineLarge!.copyWith(
          color: context.tripClipColors.heading,
        );

    return Scaffold(
      backgroundColor: pageBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TripClipStepsStatusBar(
              currentStep: currentStep,
              totalSteps: totalSteps,
              onStepChanged: onStepChanged,
              onExitAtFirstStep: onExitAtFirstStep,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text(title, style: titleStyle),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: context.tripClipColors.borderSubtle,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: contentPadding,
                child: body,
              ),
            ),
            ?bottomBar,
          ],
        ),
      ),
    );
  }
}
