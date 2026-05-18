import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../badges/trip_clip_badge_clip.dart';
import '../trip_clip_avatar.dart';
import 'trip_clip_card_divider.dart';
import 'trip_clip_card_shadows.dart';

class TripClipSemiFeatureCard extends StatelessWidget {
  const TripClipSemiFeatureCard({
    super.key,
    this.image = const NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/pump.webp'),
    required this.heading,
    required this.badgeLabel,
    this.badgeFlexibleLabel,
    this.avatarUrl,
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

  final String? avatarUrl;
  final bool verified;

  final String pickupLocation;
  final String deliveryLocation;

  final String itemsText;
  final String weightText;
  final String footerDateText;

  static Widget _verifiedAvatar({
    required bool verified,
    required Color badgeFill,
    ImageProvider<Object>? avatarImage,
  }) {
    return SizedBox(
      width: TripClipAvatarSize.s32.px,
      height: TripClipAvatarSize.s32.px,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          TripClipAvatar(size: TripClipAvatarSize.s32, image: avatarImage),
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

  static ImageProvider<Object>? _resolveAvatarImage(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) return null;

    if (value.startsWith('assets/')) {
      return AssetImage(value);
    }

    final uri = Uri.tryParse(value);
    final scheme = uri?.scheme.toLowerCase();
    if (scheme == 'http' || scheme == 'https') {
      return NetworkImage(value);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final light = Theme.of(context).brightness == Brightness.light;

    final avatarImage = _resolveAvatarImage(avatarUrl);

    final bg = light ? TripClipPalette.neutral100 : TripClipPalette.neutral900;
    final headingColor = context.tripClipColors.heading;
    final dividerColor = context.tripClipColors.borderSubtle;

    final iconBase = context.tripClipColors.textSubtle;
    final otherIconColor = iconBase;
    final verifyColor = light
        ? TripClipPalette.secondary500
        : TripClipPalette.secondary400;

    final ratingTextColor = context.tripClipColors.textSubtle;

    final sectionTextColor = context.tripClipColors.textBase;
    final footerTextColor = ratingTextColor;

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
                      style: t.headlineMedium!.copyWith(color: headingColor),
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
                      child: Image(
                        image: image,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const DecoratedBox(
                            decoration: BoxDecoration(
                              color: TripClipPalette.neutral850,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const DecoratedBox(
                            decoration: BoxDecoration(
                              color: TripClipPalette.neutral850,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PICKUP',
                          style: t.titleSmall!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: ratingTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _IconText(
                          iconAsset: 'assets/icons/location.svg',
                          iconColor: otherIconColor,
                          text: pickupLocation,
                          textColor: sectionTextColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'DELIVERY',
                          style: t.titleSmall!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: ratingTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
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
                  _verifiedAvatar(
                    verified: verified,
                    badgeFill: verifyColor,
                    avatarImage: avatarImage,
                  ),
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
                    style: t.labelMedium!.copyWith(color: footerTextColor),
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
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: textColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
