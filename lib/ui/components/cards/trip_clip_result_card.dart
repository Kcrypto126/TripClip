import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../badges/trip_clip_badge_clip.dart';
import '../badges/trip_clip_badge_status.dart';
import 'trip_clip_card_divider.dart';
import 'trip_clip_card_shadows.dart';

class TripClipResultCard extends StatelessWidget {
  const TripClipResultCard({
    super.key,
    this.statusLabel = 'Success',
    this.statusTone = TripClipBadgeStatusTone.success,
    this.progress = 0.35,
    required this.heading,
    required this.badgeLabel,
    this.badgeFlexibleLabel,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.itemsText,
    required this.weightText,
    required this.footerDateText,
    this.showMetaFooter = true,
  }) : assert(progress >= 0 && progress <= 1);

  final String statusLabel;
  final TripClipBadgeStatusTone statusTone;

  final double progress;

  final String heading;
  final String badgeLabel;
  final String? badgeFlexibleLabel;

  final String pickupLocation;
  final String deliveryLocation;

  final String itemsText;
  final String weightText;
  final String footerDateText;
  final bool showMetaFooter;

  static const double _progressHeight = 8;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final light = Theme.of(context).brightness == Brightness.light;

    final bg = light ? TripClipPalette.neutral100 : TripClipPalette.neutral900;
    final headingColor = context.tripClipColors.heading;
    final dividerColor = context.tripClipColors.borderSubtle;

    final iconBase = context.tripClipColors.textSubtle;
    final otherIconColor = iconBase;
    final ratingTextColor = context.tripClipColors.textSubtle;
    final sectionTextColor = context.tripClipColors.textBase;
    final footerTextColor = ratingTextColor;

    final trackColor = context.tripClipColors.borderSubtle;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: TripClipCardShadows.whenLight(light),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TripClipBadgeStatus(
                label: statusLabel,
                tone: statusTone,
                showLeadingIcon: false,
                showTrailingIcon: false,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(_progressHeight / 2),
              child: SizedBox(
                height: _progressHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(color: trackColor),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: progress.clamp(0.0, 1.0),
                        heightFactor: 1,
                        child: const ColoredBox(
                          color: TripClipPalette.secondary500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    heading,
                    style: t.headlineSmall!.copyWith(color: headingColor),
                  ),
                ),
                const SizedBox(width: 12),
                TripClipBadgeClip(
                  label: badgeLabel,
                  flexibleLabel: badgeFlexibleLabel,
                ),
              ],
            ),
            TripClipCardDivider(color: dividerColor),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _LocationLine(
                    iconColor: otherIconColor,
                    text: pickupLocation,
                    textColor: sectionTextColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _LocationLine(
                    iconColor: otherIconColor,
                    text: deliveryLocation,
                    textColor: sectionTextColor,
                  ),
                ),
              ],
            ),
            if (showMetaFooter) ...[
              TripClipCardDivider(color: dividerColor),
              Row(
                children: [
                  _FooterIconText(
                    iconAsset: 'assets/icons/package.svg',
                    iconColor: otherIconColor,
                    text: itemsText,
                    textColor: sectionTextColor,
                  ),
                  const SizedBox(width: 12),
                  _FooterIconText(
                    iconAsset: 'assets/icons/weight.svg',
                    iconColor: otherIconColor,
                    text: weightText,
                    textColor: sectionTextColor,
                  ),
                  const Spacer(),
                  Text(
                    footerDateText,
                    style: t.labelMedium!.copyWith(color: footerTextColor),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LocationLine extends StatelessWidget {
  const _LocationLine({
    required this.iconColor,
    required this.text,
    required this.textColor,
  });

  final Color iconColor;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: SvgPicture.asset(
            'assets/icons/location.svg',
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: textColor),
          ),
        ),
      ],
    );
  }
}

class _FooterIconText extends StatelessWidget {
  const _FooterIconText({
    required this.iconAsset,
    required this.iconColor,
    required this.text,
    required this.textColor,
  });

  final String iconAsset;
  final Color iconColor;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconAsset,
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: textColor),
        ),
      ],
    );
  }
}
