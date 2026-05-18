import 'package:flutter/material.dart';

import '../../../../ui/components/pages/trip_clip_content_page_scaffold.dart';

class TripClipPrivacyPolicyPage extends StatelessWidget {
  const TripClipPrivacyPolicyPage({super.key});

  static const _sectionGap = 40.0;

  @override
  Widget build(BuildContext context) {
    return TripClipContentPageScaffold(
      appBarTitle: 'Privacy Policy',
      heading: 'Privacy Policy',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          const TripClipContentSection(
            heading: '1. Introduction',
            body:
                'TripClip ("we", "our", "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our platform.',
          ),
          const SizedBox(height: _sectionGap),
          const TripClipContentSection(
            heading: '2. Information We Collect',
            body: 'We collect information that you provide directly to us, including:',
            bullets: [
              'Name, email address, phone number, and date of birth',
              'Payment information (processed securely through our payment provider)',
              'Identity verification documents (driver licence, passport, or proof of age card)',
              'Profile photo and selfie for verification purposes',
              'Bank account details for payment withdrawals',
              'Delivery addresses and location data',
            ],
          ),
          const SizedBox(height: _sectionGap),
          const TripClipContentSection(
            heading: '3. How We Use Your Information',
            body: 'We use the information we collect to:',
            bullets: [
              'Provide, maintain, and improve our services',
              'Verify your identity and prevent fraud',
              'Process transactions and send transaction notifications',
              'Facilitate communication between Senders and Travellers',
              'Send you technical notices, updates, and support messages',
              'Respond to your comments and questions',
              'Monitor and analyse trends and usage',
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
