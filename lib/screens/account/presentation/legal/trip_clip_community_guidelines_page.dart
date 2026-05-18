import 'package:flutter/material.dart';

import '../../../../ui/components/pages/trip_clip_content_page_scaffold.dart';

class TripClipCommunityGuidelinesPage extends StatelessWidget {
  const TripClipCommunityGuidelinesPage({super.key});

  static const _sectionGap = 40.0;

  @override
  Widget build(BuildContext context) {
    return TripClipContentPageScaffold(
      appBarTitle: 'Community Guidelines',
      heading: 'Community Guidelines',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          const TripClipContentBodyText(
            'TripClip is built on trust and community. These guidelines help '
            'ensure everyone has a safe and positive experience on our platform.',
          ),
          const SizedBox(height: _sectionGap),
          const TripClipContentSection(
            heading: '1. Be Respectful',
            body:
                'Treat everyone with respect and courtesy. Harassment, discrimination, hate speech, or abusive behaviour of any kind will not be tolerated. We\'re all here to help each other, whether you\'re sending a parcel or delivering one.',
          ),
          const SizedBox(height: _sectionGap),
          const TripClipContentSection(
            heading: '2. Be Honest',
            body: 'Honesty is essential to building trust in our community:',
            bullets: [
              'Provide accurate descriptions of parcels, including size, weight, and contents',
              'Use your real identity and photo during verification',
              'Be truthful about your availability and delivery routes',
              'Report issues promptly and accurately',
            ],
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
