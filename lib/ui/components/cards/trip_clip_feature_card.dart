import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../badges/trip_clip_badge_clip.dart';
import '../trip_clip_avatar.dart';
import 'trip_clip_card_divider.dart';
import 'trip_clip_card_shadows.dart';

class TripClipFeatureCard extends StatefulWidget {
  const TripClipFeatureCard({
    super.key,
    this.images = const [NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/pump.webp')],
    required this.heading,
    required this.badgeLabel,
    this.badgeFlexibleLabel,
    this.avatarUrl,
    required this.userName,
    required this.ratingText,
    this.verified = true,
    required this.pickupLocation,
    required this.pickupDate,
    required this.pickupTime,
    required this.deliveryLocation,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.itemsText,
    required this.weightText,
    required this.footerDateText,
    this.onTap,
  });

  final List<ImageProvider<Object>> images;

  final String heading;

  final String badgeLabel;
  final String? badgeFlexibleLabel;

  final String? avatarUrl;
  final String userName;
  final String ratingText;
  final bool verified;

  final String pickupLocation;
  final String pickupDate;
  final String pickupTime;

  final String deliveryLocation;
  final String deliveryDate;
  final String deliveryTime;

  final String itemsText;
  final String weightText;
  final String footerDateText;

  final VoidCallback? onTap;

  @override
  State<TripClipFeatureCard> createState() => _TripClipFeatureCardState();
}

class _TripClipFeatureCardState extends State<TripClipFeatureCard> {
  late final PageController _controller;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    final images = widget.images.isEmpty
        ? const <ImageProvider<Object>>[NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/pump.webp')]
        : widget.images;

    final avatarImage = _resolveAvatarImage(widget.avatarUrl);

    final bg = light ? TripClipPalette.neutral100 : TripClipPalette.neutral900;
    final headingColor = context.tripClipColors.heading;
    final dividerColor = context.tripClipColors.borderSubtle;

    final iconBase = context.tripClipColors.textSubtle;
    final ratingStarColor = iconBase;
    final otherIconColor = iconBase;
    final verifyColor = light
        ? TripClipPalette.secondary500
        : TripClipPalette.secondary400;

    final userNameColor = context.tripClipColors.heading;
    final ratingTextColor = context.tripClipColors.textSubtle;

    final sectionTextColor = context.tripClipColors.textBase;
    final footerTextColor = ratingTextColor;

    Widget card = DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: TripClipCardShadows.whenLight(light),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FeatureImageCarousel(
            controller: _controller,
            images: images,
            onPageChanged: (i) => setState(() => _page = i),
          ),
          _ImageNavigationDots(
            count: images.length,
            activeIndex: _page,
            onDotPressed: (i) => _controller.animateToPage(
              i,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.heading,
                        style: t.headlineMedium!.copyWith(color: headingColor),
                      ),
                    ),
                    const SizedBox(width: 12),
                    TripClipBadgeClip(
                      label: widget.badgeLabel,
                      flexibleLabel: widget.badgeFlexibleLabel,
                    ),
                  ],
                ),
                TripClipCardDivider(color: dividerColor),
                Row(
                  children: [
                    TripClipAvatar(
                      size: TripClipAvatarSize.s32,
                      image: avatarImage,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodySmall!.copyWith(color: userNameColor),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _svgIcon(
                      'assets/icons/rating-star.svg',
                      color: ratingStarColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.ratingText,
                      style: t.bodySmall!.copyWith(color: ratingTextColor),
                    ),
                    if (widget.verified) ...[
                      const SizedBox(width: 8),
                      _svgIcon('assets/icons/verify.svg', color: verifyColor),
                    ],
                  ],
                ),
                TripClipCardDivider(color: dividerColor),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _PickupDeliveryBlock(
                        title: 'PICKUP',
                        titleColor: ratingTextColor,
                        textColor: sectionTextColor,
                        iconColor: otherIconColor,
                        rightPadding: 12,
                        location: widget.pickupLocation,
                        date: widget.pickupDate,
                        time: widget.pickupTime,
                        showLeftBorder: false,
                        leftBorderColor: dividerColor,
                      ),
                    ),
                    Expanded(
                      child: _PickupDeliveryBlock(
                        title: 'DELIVERY',
                        titleColor: ratingTextColor,
                        textColor: sectionTextColor,
                        iconColor: otherIconColor,
                        leftPadding: 12,
                        location: widget.deliveryLocation,
                        date: widget.deliveryDate,
                        time: widget.deliveryTime,
                        showLeftBorder: true,
                        leftBorderColor: dividerColor,
                      ),
                    ),
                  ],
                ),
                TripClipCardDivider(color: dividerColor),
                Row(
                  children: [
                    _IconText(
                      iconAsset: 'assets/icons/package.svg',
                      iconColor: otherIconColor,
                      text: widget.itemsText,
                      textColor: sectionTextColor,
                    ),
                    const SizedBox(width: 12),
                    _IconText(
                      iconAsset: 'assets/icons/weight.svg',
                      iconColor: otherIconColor,
                      text: widget.weightText,
                      textColor: sectionTextColor,
                    ),
                    const Spacer(),
                    Text(
                      widget.footerDateText,
                      style: t.labelMedium!.copyWith(color: footerTextColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (widget.onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          splashFactory: NoSplash.splashFactory,
          child: card,
        ),
      );
    }
    return card;
  }

  static Widget _svgIcon(String asset, {required Color color}) {
    return SvgPicture.asset(
      asset,
      width: 16,
      height: 16,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

class _FeatureImageCarousel extends StatelessWidget {
  const _FeatureImageCarousel({
    required this.controller,
    required this.images,
    required this.onPageChanged,
  });

  final PageController controller;
  final List<ImageProvider<Object>> images;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 271,
        child: PageView.builder(
          controller: controller,
          itemCount: images.length,
          onPageChanged: onPageChanged,
          itemBuilder: (context, index) {
            return Image(
              image: images[index],
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const DecoratedBox(
                  decoration: BoxDecoration(color: TripClipPalette.neutral850),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const DecoratedBox(
                  decoration: BoxDecoration(color: TripClipPalette.neutral850),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ImageNavigationDots extends StatelessWidget {
  const _ImageNavigationDots({
    required this.count,
    required this.activeIndex,
    required this.onDotPressed,
  });

  final int count;
  final int activeIndex;
  final ValueChanged<int> onDotPressed;

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final dotColor = light
        ? TripClipPalette.neutral500
        : TripClipPalette.neutral700;

    return Padding(
      // Spec: 12px gap between image and nav dots.
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (i) {
          final active = i == activeIndex;
          return Padding(
            padding: EdgeInsetsDirectional.only(end: i == count - 1 ? 0 : 4),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () => onDotPressed(i),
                borderRadius: BorderRadius.circular(999),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  width: active ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: dotColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _PickupDeliveryBlock extends StatelessWidget {
  const _PickupDeliveryBlock({
    required this.title,
    required this.titleColor,
    required this.textColor,
    required this.iconColor,
    required this.location,
    required this.date,
    required this.time,
    required this.showLeftBorder,
    required this.leftBorderColor,
    this.leftPadding = 0,
    this.rightPadding = 0,
  });

  final String title;
  final Color titleColor;
  final Color textColor;
  final Color iconColor;
  final String location;
  final String date;
  final String time;
  final bool showLeftBorder;
  final Color leftBorderColor;
  final double leftPadding;
  final double rightPadding;

  @override
  Widget build(BuildContext context) {
    final capStyle = Theme.of(context).textTheme.titleSmall!.copyWith(
          fontWeight: FontWeight.w500,
          color: titleColor,
        );
    final child = Padding(
      padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: capStyle,
          ),
          const SizedBox(height: 8),
          _IconText(
            iconAsset: 'assets/icons/location.svg',
            iconColor: iconColor,
            text: location,
            textColor: textColor,
          ),
          const SizedBox(height: 4),
          _IconText(
            iconAsset: 'assets/icons/calendar.svg',
            iconColor: iconColor,
            text: date,
            textColor: textColor,
          ),
          const SizedBox(height: 4),
          _IconText(
            iconAsset: 'assets/icons/clock.svg',
            iconColor: iconColor,
            text: time,
            textColor: textColor,
          ),
        ],
      ),
    );

    if (!showLeftBorder) return child;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: BorderDirectional(
          start: BorderSide(color: leftBorderColor, width: 1),
        ),
      ),
      child: child,
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
        // This widget is used inside Rows that may be unconstrained along the
        // horizontal axis (e.g. footer). Avoid flex children.
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
