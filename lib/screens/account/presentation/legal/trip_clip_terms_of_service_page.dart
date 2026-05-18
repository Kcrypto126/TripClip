import 'package:flutter/material.dart';

import '../../../../ui/components/pages/trip_clip_content_page_scaffold.dart';

class TripClipTermsOfServicePage extends StatelessWidget {
  const TripClipTermsOfServicePage({super.key});

  static const _sectionGap = 40.0;

  @override
  Widget build(BuildContext context) {
    return TripClipContentPageScaffold(
      appBarTitle: 'Terms of Service',
      heading: 'Terms of Service',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          const TripClipContentSection(
            heading: '1. Acceptance of Terms',
            body:
                'By accessing and using TripClip ("the Service"), you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
          ),
          const SizedBox(height: _sectionGap),
          const TripClipContentSection(
            heading: '2. Use License',
            body:
                'Permission is granted to temporarily use the TripClip platform for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:',
            bullets: [
              'Modify or copy the materials',
              'Use the materials for any commercial purpose or for any public display',
              'Attempt to reverse engineer any software contained within TripClip',
              'Remove any copyright or other proprietary notations from the materials',
            ],
          ),
          const SizedBox(height: _sectionGap),
          const TripClipContentSection(
            heading: '3. User Accounts',
            body:
                'When you create an account with us, you must provide us with information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account on our Service.',
          ),
          const SizedBox(height: 24),
          Builder(
            builder: (context) => tripClipFooterText(
              context,
              'Last updated: 1 November 2024',
            ),
          ),
        ],
      ),
    );
  }
}

