import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/trip_clip_palette.dart';
import '../badges/trip_clip_badge_clip.dart';
import '../badges/trip_clip_badge_status.dart';
import 'trip_clip_card_divider.dart';

/// Result card: status + progress, heading + price badge, locations, footer stats.
/// Styling matches [TripClipFeatureCard] / [TripClipSemiFeatureCard] (surface,
/// shadow, dividers, badge clip, icon colors).
class TripClipResultCard extends StatelessWidget {
  const TripClipResultCard({
    super.key,
    this.statusLabel = 'Success',
    this.progress = 0.35,
    required this.heading,
    required this.badgeLabel,
    this.badgeFlexibleLabel,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.itemsText,
    required this.weightText,
    required this.footerDateText,
  }) : assert(progress >= 0 && progress <= 1);

  final String statusLabel;

  /// 0…1 orange fill on the progress track.
  final double progress;

  final String heading;
  final String badgeLabel;
  final String? badgeFlexibleLabel;

  final String pickupLocation;
  final String deliveryLocation;

  final String itemsText;
  final String weightText;
  final String footerDateText;

  static const double _progressHeight = 8;

  static TextStyle _rubik({
    required double size,
    required double lineHeight,
    required FontWeight weight,
    required Color color,
    double letterSpacing = 0,
  }) => GoogleFonts.rubik(
    fontSize: size,
    height: lineHeight / size,
    fontWeight: weight,
    letterSpacing: letterSpacing,
    color: color,
  );

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;

    final bg = light ? TripClipPalette.neutral100 : TripClipPalette.neutral900;
    final headingColor = light
        ? TripClipPalette.primary500
        : TripClipPalette.primary400;
    final dividerColor = light
        ? TripClipPalette.neutral200
        : TripClipPalette.neutral850;

    final iconBase = light
        ? TripClipPalette.neutral600
        : TripClipPalette.neutral300;
    final otherIconColor = iconBase;
    final ratingTextColor = light
        ? TripClipPalette.neutral600
        : TripClipPalette.neutral300;
    final sectionTextColor = light ? TripClipPalette.tertiary500 : Colors.white;
    final footerTextColor = ratingTextColor;

    final trackColor = light
        ? TripClipPalette.neutral200
        : TripClipPalette.neutral850;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: light
            ? [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
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
                tone: TripClipBadgeStatusTone.success,
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
                    style: _rubik(
                      size: 18,
                      lineHeight: 22,
                      weight: FontWeight.w600,
                      color: headingColor,
                    ),
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
                  style: _rubik(
                    size: 12,
                    lineHeight: 18,
                    weight: FontWeight.w400,
                    color: footerTextColor,
                  ),
                ),
              ],
            ),
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
            style: GoogleFonts.rubik(
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
              color: textColor,
            ),
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
          style: GoogleFonts.rubik(
            fontSize: 14,
            height: 20 / 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
