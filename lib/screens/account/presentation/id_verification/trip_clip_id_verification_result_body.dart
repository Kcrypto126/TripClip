import 'package:flutter/material.dart';
import '../../../../app/theme/trip_clip_colors.dart';
import '../../../../ui/components/pages/trip_clip_stepped_page_scaffold.dart';

class TripClipIdVerificationResultBody extends StatelessWidget {
  const TripClipIdVerificationResultBody({super.key, required this.success});

  final bool success;

  TextStyle _bodyStyle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(color: context.tripClipColors.textBase);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1F242B) : const Color(0xFFEFF2F5);
    final body = _bodyStyle(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          success
              ? "You're all set! You can now send parcels and accept delivery jobs on TripClip."
              : 'We were unable to verify your identity. Please try again with clearer photos.',
          style: body,
        ),
        const SizedBox(height: 24),
        if (success)
          TripClipSteppedCardSection(
            backgroundColor: cardBg,
            title: "What's next?",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TripClipSteppedBulletLine(text: 'Browse available trips'),
                const TripClipSteppedBulletLine(text: 'Send your first parcel'),
                const TripClipSteppedBulletLine(text: 'Complete your profile'),
              ],
            ),
          )
        else ...[
          TripClipSteppedCardSection(
            backgroundColor: cardBg,
            title: 'Common issues:',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TripClipSteppedBulletLine(
                  text: 'Photo was blurry or out of focus',
                ),
                const TripClipSteppedBulletLine(
                  text: "ID details weren't clearly visible",
                ),
                const TripClipSteppedBulletLine(
                  text: 'Glare or shadows on the ID',
                ),
                const TripClipSteppedBulletLine(
                  text: "Selfie didn't match ID photo",
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TripClipSteppedCardSection(
            backgroundColor: cardBg,
            title: 'Still having trouble?',
            child: Text(
              "Contact support and we'll help you complete verification.",
            ),
          ),
        ],
      ],
    );
  }
}
