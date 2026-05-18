import 'package:flutter/material.dart';

import '../../../../app/navigation/trip_clip_navigator.dart';
import '../../../../app/theme/trip_clip_colors.dart';
import '../../../../ui/components/buttons/trip_clip_button.dart';
import '../../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../../ui/components/pages/trip_clip_content_page_scaffold.dart';
import 'trip_clip_contact_page.dart';

class TripClipSafetyGuidelinesPage extends StatelessWidget {
  const TripClipSafetyGuidelinesPage({super.key});

  static const _sectionGap = 40.0;

  @override
  Widget build(BuildContext context) {
    return TripClipContentPageScaffold(
      appBarTitle: 'Help & Support',
      heading: 'Safety Guidelines',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          _ReportCard(
            onContactSupport: () {
              tripClipPushMaterialPage<void>(
                context,
                const TripClipContactPage(),
                shellNavHighlightTabIndex:
                    TripClipShellNavRoutes.accountTabIndex,
              );
            },
          ),
          const SizedBox(height: _sectionGap),
          const TripClipContentBodyText(
            'Your safety is our priority. Follow these guidelines to stay safe when using TripClip.',
          ),
          const SizedBox(height: _sectionGap),
          const TripClipContentSection(
            heading: 'Verify identity',
            body: 'You have to verify your identity.',
            bullets: [
              'All users on TripClip must complete ID verification before sending or delivering parcels.',
              'Check the person\'s profile and rating before accepting a job.',
              'Look for the verified badge on user profiles.',
              'Report suspicious behaviour immediately to our support team.',
            ],
          ),
          const SizedBox(height: _sectionGap),
          const TripClipContentSection(
            heading: 'Prohibited items',
            body: 'Never accept parcels containing:',
            bullets: [
              'Weapons or explosives',
              'Illegal substances',
              'Hazardous materials',
              'Perishable food items',
              'Live animals',
            ],
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.onContactSupport});

  final VoidCallback onContactSupport;

  @override
  Widget build(BuildContext context) {
    final bg = context.tripClipColors.heading;

    final t = Theme.of(context).textTheme;
    final titleStyle = t.headlineSmall!.copyWith(color: Colors.white);
    final bodyStyle = t.bodyMedium!.copyWith(color: Colors.white);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Report safety concerns', style: titleStyle),
          const SizedBox(height: 8),
          Text(
            'If you experience or witness unsafe behaviour, please contact us immediately.',
            style: bodyStyle,
          ),
          const SizedBox(height: 24),
          TripClipButton(
            variant: TripClipButtonVariant.primaryAlternative,
            expanded: true,
            label: 'Contact support',
            onPressed: onContactSupport,
          ),
        ],
      ),
    );
  }
}
