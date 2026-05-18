import 'package:flutter/material.dart';
import '../../app/theme/trip_clip_colors.dart';
import 'trip_clip_modal_sheet.dart';
import 'trip_clip_sheet_layout.dart';

void showTripClipTermsOfServiceSheet(BuildContext context) {
  TripClipModalSheet.show<void>(
    context,
    builder: (_) => const TripClipTermsOfServiceSheet(),
  );
}

class TripClipTermsOfServiceSheet extends StatelessWidget {
  const TripClipTermsOfServiceSheet({super.key});

  static const _sectionGap = 40.0;
  static const _headingBodyGap = 12.0;
  static const _bodyPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return TripClipTermsStyleSheet(
      title: 'Terms of Service',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(_bodyPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: context.tripClipColors.heading,
                  ),
            ),
            const SizedBox(height: _sectionGap),
            _TermsSection(
              heading: '1. Acceptance of Terms',
              body:
                  'By accessing and using TripClip ("the Service"), you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
            ),
            const SizedBox(height: _sectionGap),
            _TermsSection(
              heading: '2. Use License',
              body:
                  'Permission is granted to temporarily use the TripClip platform for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:',
              bullets: const [
                'Modify or copy the materials',
                'Use the materials for any commercial purpose or for any public display',
                'Attempt to reverse engineer any software contained within TripClip',
                'Remove any copyright or other proprietary notations from the materials',
              ],
            ),
            const SizedBox(height: _sectionGap),
            _TermsSection(
              heading: '3. User Accounts',
              body:
                  'When you create an account with us, you must provide us with information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account on our Service.',
            ),
            const SizedBox(height: 24),
            Text(
              'Last updated: 1 November 2024',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: context.tripClipColors.textSubtle,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection({
    required this.heading,
    required this.body,
    this.bullets,
  });

  final String heading;
  final String body;
  final List<String>? bullets;

  @override
  Widget build(BuildContext context) {
    final bulletLines = bullets;
    final sectionColor = context.tripClipColors.textBase;
    final t = Theme.of(context).textTheme;
    final headingStyle = t.headlineMedium!.copyWith(color: sectionColor);
    final bodyStyle = t.bodyMedium!.copyWith(color: sectionColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading, style: headingStyle),
        const SizedBox(height: TripClipTermsOfServiceSheet._headingBodyGap),
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
