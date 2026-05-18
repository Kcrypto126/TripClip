import 'package:flutter/material.dart';
class TripClipOnboardingFeatureSection extends StatelessWidget {
  const TripClipOnboardingFeatureSection({
    super.key,
    required this.imageAsset,
    required this.heading,
    required this.description,
    required this.imageCircular,
  });

  final String imageAsset;
  final String heading;
  final String description;

  final bool imageCircular;

  static const double imageSize = 280;
  static const Color _borderColor = Color(0xFF64BEF0);
  static const double _borderWidth = 1.5;

  static const double imageToHeadingGap = 80;
  static const double headingToBodyGap = 16;

  static const double sectionTopPadding = 65;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final headingStyle = t.displayMedium!.copyWith(color: Colors.white);
    final bodyStyle = t.bodyLarge!.copyWith(color: Colors.white);

    return Padding(
      padding: const EdgeInsets.only(top: sectionTopPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _FramedFeatureImage(asset: imageAsset, circular: imageCircular),
          const SizedBox(height: imageToHeadingGap),
          Text(heading, textAlign: TextAlign.center, style: headingStyle),
          const SizedBox(height: headingToBodyGap),
          Text(description, textAlign: TextAlign.center, style: bodyStyle),
        ],
      ),
    );
  }
}

class _FramedFeatureImage extends StatelessWidget {
  const _FramedFeatureImage({required this.asset, required this.circular});

  final String asset;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    final radius = circular
        ? TripClipOnboardingFeatureSection.imageSize / 2
        : 16.0;

    return Container(
      width: TripClipOnboardingFeatureSection.imageSize,
      height: TripClipOnboardingFeatureSection.imageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: TripClipOnboardingFeatureSection._borderColor,
          width: TripClipOnboardingFeatureSection._borderWidth,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          asset,
          width: TripClipOnboardingFeatureSection.imageSize,
          height: TripClipOnboardingFeatureSection.imageSize,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
