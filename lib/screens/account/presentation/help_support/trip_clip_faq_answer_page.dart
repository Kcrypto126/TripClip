import 'package:flutter/material.dart';

import '../../../../app/theme/trip_clip_colors.dart';
import '../../../../ui/components/pages/trip_clip_content_page_scaffold.dart';

class TripClipFaqAnswer {
  const TripClipFaqAnswer({
    required this.question,
    this.paragraphs = const [],
    this.sectionTitle,
    this.numberedSteps = const [],
  });

  final String question;
  final List<String> paragraphs;
  final String? sectionTitle;
  final List<String> numberedSteps;
}

class TripClipFaqAnswerPage extends StatelessWidget {
  const TripClipFaqAnswerPage({super.key, required this.answer});

  final TripClipFaqAnswer answer;

  @override
  Widget build(BuildContext context) {
    final sectionColor = context.tripClipColors.textBase;

    final t = Theme.of(context).textTheme;
    final bodyStyle = t.bodyMedium!.copyWith(color: sectionColor);
    final sectionHeadingStyle = t.headlineSmall!.copyWith(color: sectionColor);

    return TripClipContentPageScaffold(
      appBarTitle: 'FAQs',
      heading: answer.question,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          for (final p in answer.paragraphs) ...[
            Text(p, style: bodyStyle),
            const SizedBox(height: 16),
          ],
          if (answer.sectionTitle != null) ...[
            Text(answer.sectionTitle!, style: sectionHeadingStyle),
            const SizedBox(height: 16),
          ],
          if (answer.numberedSteps.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < answer.numberedSteps.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text('${i + 1}. ${answer.numberedSteps[i]}',
                        style: bodyStyle),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

