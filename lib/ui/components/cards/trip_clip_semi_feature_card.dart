import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/trip_clip_palette.dart';
import '../badges/trip_clip_badge_clip.dart';
import '../trip_clip_avatar.dart';
import 'trip_clip_card_divider.dart';
import 'trip_clip_card_shadows.dart';

class TripClipSemiFeatureCard extends StatelessWidget {
  const TripClipSemiFeatureCard({
    super.key,
    this.image = const AssetImage('assets/images/pump.png'),
    required this.heading,
    required this.badgeLabel,
    this.badgeFlexibleLabel,
    required this.userName,
    this.ratingText,
    this.verified = true,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.itemsText,
    required this.weightText,
    required this.footerDateText,
  });

  final ImageProvider<Object> image;

  final String heading;

  final String badgeLabel;
  final String? badgeFlexibleLabel;

  final String userName;
  final String? ratingText;
  final bool verified;

  final String pickupLocation;
  final String deliveryLocation;

  final String itemsText;
  final String weightText;
  final String footerDateText;

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

  static Widget _verifiedAvatar({
    required bool verified,
    required Color badgeFill,
  }) {
    return SizedBox(
      width: TripClipAvatarSize.s32.px,
      height: TripClipAvatarSize.s32.px,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const TripClipAvatar(size: TripClipAvatarSize.s32),
          if (verified)
            PositionedDirectional(
              end: -4,
              bottom: 1,
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/verify.svg',
                  width: 16,
                  height: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

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
    final verifyColor = light
        ? TripClipPalette.secondary500
        : TripClipPalette.secondary400;

    final ratingTextColor = light
        ? TripClipPalette.neutral600
        : TripClipPalette.neutral300;

    final sectionTextColor = light ? TripClipPalette.tertiary500 : Colors.white;
    final footerTextColor = ratingTextColor;

    // [PageView] etc. can pass a tall max height; shrink-wrap so padding stays even.
    return Align(
      alignment: Alignment.topCenter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: TripClipCardShadows.whenLight(light),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      heading,
                      style: _rubik(
                        size: 22,
                        lineHeight: 26,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 120,
                      height: 90,
                      child: Image(image: image, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PICKUP',
                          style: _rubik(
                            size: 12,
                            lineHeight: 14,
                            weight: FontWeight.w500,
                            color: ratingTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _IconText(
                          iconAsset: 'assets/icons/location.svg',
                          iconColor: otherIconColor,
                          text: pickupLocation,
                          textColor: sectionTextColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'DELIVERY',
                          style: _rubik(
                            size: 12,
                            lineHeight: 14,
                            weight: FontWeight.w500,
                            color: ratingTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _IconText(
                          iconAsset: 'assets/icons/location.svg',
                          iconColor: otherIconColor,
                          text: deliveryLocation,
                          textColor: sectionTextColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              TripClipCardDivider(color: dividerColor),
              Row(
                children: [
                  _verifiedAvatar(verified: verified, badgeFill: verifyColor),
                  const SizedBox(width: 12),
                  _IconText(
                    iconAsset: 'assets/icons/package.svg',
                    iconColor: otherIconColor,
                    text: itemsText,
                    textColor: sectionTextColor,
                  ),
                  const SizedBox(width: 12),
                  _IconText(
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
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  const _IconText({
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth.isFinite ? constraints.maxWidth : 180;
        final textMaxW = (maxW - 16 - 4).clamp(0, maxW);

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
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: textMaxW.toDouble()),
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
      },
    );
  }
}
