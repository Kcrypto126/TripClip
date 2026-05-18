import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../trip_clip_steps_status_bar.dart';

class TripClipSteppedPageScaffold extends StatelessWidget {
  const TripClipSteppedPageScaffold({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.heading,
    required this.body,
    this.bottomBar,
    this.onStepChanged,
    this.onExitAtFirstStep,
  }) : assert(totalSteps >= 1);

  final int currentStep;
  final int totalSteps;
  final String heading;
  final Widget body;
  final Widget? bottomBar;

  final ValueChanged<int>? onStepChanged;
  final VoidCallback? onExitAtFirstStep;

  @override
  Widget build(BuildContext context) {
    final pageBg = context.tripClipColors.pageBackground;
    final headingStyle = Theme.of(context).textTheme.headlineLarge!.copyWith(
          color: context.tripClipColors.heading,
        );

    return Scaffold(
      backgroundColor: pageBg,
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
            Divider(
              height: 1,
              thickness: 1,
              color: context.tripClipColors.borderSubtle,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(heading, style: headingStyle),
                    const SizedBox(height: 24),
                    body,
                  ],
                ),
              ),
            ),
            ?bottomBar,
          ],
        ),
      ),
    );
  }
}

class TripClipSteppedCardSection extends StatelessWidget {
  const TripClipSteppedCardSection({
    super.key,
    this.title,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 8,
    this.backgroundColor,
  });

  final String? title;
  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textBase = context.tripClipColors.textBase;
    final bg =
        backgroundColor ??
        (isDark ? const Color(0xFF1F242B) : const Color(0xFFEFF2F5));

    final titleStyle = Theme.of(context).textTheme.headlineSmall!.copyWith(
          color: textBase,
        );
    final bodyStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: textBase,
        );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding,
        child: DefaultTextStyle(
          style: bodyStyle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(title!, style: titleStyle),
                const SizedBox(height: 4),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class TripClipSteppedBulletLine extends StatelessWidget {
  const TripClipSteppedBulletLine({super.key, required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final s = style ?? DefaultTextStyle.of(context).style;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 8),
        Text('•  ', style: s),
        Expanded(child: Text(text, style: s)),
      ],
    );
  }
}
