import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/navigation/trip_clip_navigator.dart';
import '../../../../app/theme/trip_clip_colors.dart';
import '../../../../ui/components/pages/trip_clip_content_page_scaffold.dart';
import 'trip_clip_faq_answer_page.dart';

class TripClipFaqPage extends StatelessWidget {
  const TripClipFaqPage({super.key});

  static const _sectionGap = 24.0;
  static const _cardPadding = 16.0;
  static const _cardRadius = 12.0;
  static const _rowHeight = 40.0;

  @override
  Widget build(BuildContext context) {
    void openAnswer(String question) {
      final answer = _sampleFaqAnswers[question] ??
          TripClipFaqAnswer(
            question: question,
            paragraphs: const ['Content coming soon.'],
          );
      tripClipPushMaterialPage<void>(
        context,
        TripClipFaqAnswerPage(answer: answer),
        shellNavHighlightTabIndex: TripClipShellNavRoutes.accountTabIndex,
      );
    }

    return TripClipContentPageScaffold(
      appBarTitle: 'Help & Support',
      heading: 'FAQs',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _FaqSection(
            title: 'Getting started',
            items: [
              'How do I start a send?',
              'How do I become a Traveller?',
              'How does ID verification work?',
            ],
            onTapItem: openAnswer,
          ),
          const SizedBox(height: _sectionGap),
          _FaqSection(
            title: 'Payments & rewards',
            items: [
              'How do I get paid?',
              'What is a clip?',
              'When do I receive my reward?',
            ],
            onTapItem: openAnswer,
          ),
          const SizedBox(height: _sectionGap),
          _FaqSection(
            title: 'Deliveries',
            items: [
              'Can I cancel a delivery?',
              'What if a parcel is damaged?',
              'How do I track my parcel?',
            ],
            onTapItem: openAnswer,
          ),
          const SizedBox(height: 24),
          const _VersionFooter(),
        ],
      ),
    );
  }
}

class _FaqSection extends StatelessWidget {
  const _FaqSection({
    required this.title,
    required this.items,
    required this.onTapItem,
  });

  final String title;
  final List<String> items;
  final ValueChanged<String> onTapItem;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sectionColor = context.tripClipColors.textBase;

    final headingStyle =
        Theme.of(context).textTheme.headlineMedium!.copyWith(color: sectionColor);

    final cardBg =
        isDark ? const Color(0xFF1F242B) : const Color(0xFFEFF2F5);
    final dividerColor = context.tripClipColors.borderSubtle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: headingStyle),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(TripClipFaqPage._cardPadding),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(TripClipFaqPage._cardRadius),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                _FaqRow(
                  label: items[i],
                  onTap: () => onTapItem(items[i]),
                ),
                if (i != items.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: dividerColor,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _FaqRow extends StatelessWidget {
  const _FaqRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sectionColor = context.tripClipColors.textBase;
    final rowStyle =
        Theme.of(context).textTheme.bodyMedium!.copyWith(color: sectionColor);

    final iconColor = context.tripClipColors.textSubtle;
    final iconFilter = ColorFilter.mode(iconColor, BlendMode.srcIn);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        child: SizedBox(
          height: TripClipFaqPage._rowHeight,
          child: Row(
            children: [
              Expanded(child: Text(label, style: rowStyle)),
              SvgPicture.asset(
                'assets/icons/chevron-right.svg',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                colorFilter: iconFilter,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VersionFooter extends StatelessWidget {
  const _VersionFooter();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: tripClipFooterText(context, 'TripClip v1.0.0'),
    );
  }
}

const Map<String, TripClipFaqAnswer> _sampleFaqAnswers = {
  'How do I start a send?': TripClipFaqAnswer(
    question: 'How do I start a send?',
    paragraphs: [
      'To start a send, create a new delivery and enter your pickup and drop-off details.',
      'Add the parcel size and any special handling notes so Travellers know what to expect.',
    ],
    sectionTitle: 'To start your send',
    numberedSteps: ['Insert text', 'Insert text', 'Insert text', 'Insert text'],
  ),
  'How do I become a Traveller?': TripClipFaqAnswer(
    question: 'How do I become a Traveller?',
    paragraphs: [
      'To become a Traveller, complete your profile and verify your identity.',
      'Once verified, you can browse available sends and accept deliveries that match your route.',
    ],
    sectionTitle: 'To become a Traveller',
    numberedSteps: ['Insert text', 'Insert text', 'Insert text', 'Insert text'],
  ),
  'How does ID verification work?': TripClipFaqAnswer(
    question: 'How does ID verification work?',
    paragraphs: [
      'ID verification helps keep TripClip safe for everyone by confirming your identity.',
      'You may be asked to upload an ID document and a selfie for matching.',
    ],
    sectionTitle: 'Verification steps',
    numberedSteps: ['Insert text', 'Insert text', 'Insert text', 'Insert text'],
  ),
  'How do I get paid?': TripClipFaqAnswer(
    question: 'How do I get paid?',
    paragraphs: [
      'When you complete a delivery, your reward is added to your TripClip account as "pending" until the Sender confirms the parcel was received.',
      'Once confirmed (usually within 24 hours), the reward becomes "available" and you can withdraw it to your nominated bank account at any time.',
      'Withdrawals typically take 1–3 business days to appear in your account. The minimum withdrawal amount is \$10 AUD.',
    ],
    sectionTitle: 'To withdraw your earnings',
    numberedSteps: ['Insert text', 'Insert text', 'Insert text', 'Insert text'],
  ),
  'What is a clip?': TripClipFaqAnswer(
    question: 'What is a clip?',
    paragraphs: [
      'A clip is a reward you earn for successfully completing deliveries.',
      'Clips can appear as pending until the Sender confirms delivery.',
    ],
    sectionTitle: 'About clips',
    numberedSteps: ['Insert text', 'Insert text', 'Insert text', 'Insert text'],
  ),
  'When do I receive my reward?': TripClipFaqAnswer(
    question: 'When do I receive my reward?',
    paragraphs: [
      'Rewards are typically pending until the Sender confirms receipt.',
      'After confirmation, rewards become available to withdraw.',
    ],
    sectionTitle: 'Reward timing',
    numberedSteps: ['Insert text', 'Insert text', 'Insert text', 'Insert text'],
  ),
  'Can I cancel a delivery?': TripClipFaqAnswer(
    question: 'Can I cancel a delivery?',
    paragraphs: [
      'Yes, you can cancel in certain situations depending on the delivery status.',
      'If a Traveller has already accepted, cancellation may affect your account standing.',
    ],
    sectionTitle: 'To cancel a delivery',
    numberedSteps: ['Insert text', 'Insert text', 'Insert text', 'Insert text'],
  ),
  'What if a parcel is damaged?': TripClipFaqAnswer(
    question: 'What if a parcel is damaged?',
    paragraphs: [
      'If a parcel is damaged, report it as soon as possible through Help & Support.',
      'Provide clear photos and a description of what happened.',
    ],
    sectionTitle: 'If your parcel is damaged',
    numberedSteps: ['Insert text', 'Insert text', 'Insert text', 'Insert text'],
  ),
  'How do I track my parcel?': TripClipFaqAnswer(
    question: 'How do I track my parcel?',
    paragraphs: [
      'You can track your parcel from the delivery details screen once a Traveller accepts the send.',
      'Status updates will show when the parcel is picked up and when it is delivered.',
    ],
    sectionTitle: 'To track your parcel',
    numberedSteps: ['Insert text', 'Insert text', 'Insert text', 'Insert text'],
  ),
};

