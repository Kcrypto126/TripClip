import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../trip_clip_title_bar.dart';

class TripClipContentPageScaffold extends StatelessWidget {
  const TripClipContentPageScaffold({
    super.key,
    required this.heading,
    required this.body,
    required this.appBarTitle,
    this.bottomBar,
  });

  final String appBarTitle;
  final String heading;
  final Widget body;

  final Widget? bottomBar;

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
            TripClipTitleBar(
              title: appBarTitle,
              includeStatusBarInset: false,
              onBack: () => Navigator.of(context).maybePop(),
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
                    const SizedBox(height: 8),
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

class TripClipContentSection extends StatelessWidget {
  const TripClipContentSection({
    super.key,
    required this.heading,
    required this.body,
    this.bullets,
  });

  static const double headingBodyGap = 8.0;

  final String heading;
  final String body;
  final List<String>? bullets;

  @override
  Widget build(BuildContext context) {
    final bulletLines = bullets;
    final sectionColor = context.tripClipColors.textBase;

    final headingStyle = Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: sectionColor,
        );
    final bodyStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: sectionColor,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading, style: headingStyle),
        const SizedBox(height: headingBodyGap),
        Text(body, style: bodyStyle),
        if (bulletLines != null && bulletLines.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...bulletLines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: bodyStyle),
                  Expanded(child: Text(line, style: bodyStyle)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class TripClipContentBodyText extends StatelessWidget {
  const TripClipContentBodyText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final sectionColor = context.tripClipColors.textBase;
    final bodyStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: sectionColor,
        );
    return Text(text, style: bodyStyle);
  }
}

Widget tripClipFooterText(BuildContext context, String value) {
  return Text(
    value,
    style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: context.tripClipColors.textSubtle,
        ),
  );
}

