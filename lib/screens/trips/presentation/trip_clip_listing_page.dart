import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../app/navigation/trip_clip_navigator.dart';
import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../../ui/components/badges/trip_clip_badge_clip.dart';
import '../../../ui/components/badges/trip_clip_badge_icon_label.dart';
import '../../../ui/components/buttons/trip_clip_auxiliary_buttons.dart';
import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/cards/trip_clip_card_divider.dart';
import '../../../ui/components/cards/trip_clip_card_shadows.dart';
import '../../../ui/components/cards/trip_clip_parcel_info_card.dart';
import '../../../ui/components/forms/trip_clip_form_checkbox.dart';
import '../../../ui/components/forms/trip_clip_form_input.dart';
import '../../../ui/components/sheets/trip_clip_trips_share_sheet.dart';
import '../../../ui/components/trip_clip_avatar.dart';
import 'trip_clip_make_offer_page.dart';
import 'trip_clip_message_page.dart';

class TripClipListingParcelModel {
  const TripClipListingParcelModel({
    required this.indexLabel,
    required this.title,
    this.images = const [],
    required this.description,
    required this.typeLabel,
    required this.sizeDimensions,
    required this.weightLabel,
    required this.insuranceLabel,
  });

  final String indexLabel;
  final String title;
  final List<ImageProvider<Object>> images;
  final String description;
  final String typeLabel;
  final String sizeDimensions;
  final String weightLabel;
  final String insuranceLabel;
}

class TripClipListingPageComponent extends StatefulWidget {
  const TripClipListingPageComponent({
    super.key,
    required this.images,
    required this.heading,
    required this.badgeLabel,
    this.badgeFlexibleLabel,
    this.avatarUrl,
    required this.userName,
    required this.ratingText,
    this.verified = true,
    required this.dateText,
    required this.itemsText,
    required this.weightText,
    required this.pickupBadgeLabel,
    required this.pickupAddress,
    required this.pickupDateLabel,
    required this.pickupTimeLabel,
    required this.pickupDateValue,
    required this.pickupTimeValue,
    required this.deliveryBadgeLabel,
    required this.deliveryAddress,
    required this.deliveryDateLabel,
    required this.deliveryTimeLabel,
    required this.deliveryDateValue,
    required this.deliveryTimeValue,
    required this.parcels,
    required this.transportBadges,
    required this.suitableTransportText,
  });

  final List<ImageProvider<Object>> images;
  final String heading;
  final String badgeLabel;
  final String? badgeFlexibleLabel;

  final String? avatarUrl;
  final String userName;
  final String ratingText;
  final bool verified;

  final String dateText;
  final String itemsText;
  final String weightText;

  final String pickupBadgeLabel;
  final String pickupAddress;
  final String pickupDateLabel;
  final String pickupTimeLabel;
  final String pickupDateValue;
  final String pickupTimeValue;

  final String deliveryBadgeLabel;
  final String deliveryAddress;
  final String deliveryDateLabel;
  final String deliveryTimeLabel;
  final String deliveryDateValue;
  final String deliveryTimeValue;

  final List<TripClipListingParcelModel> parcels;
  final List<({String label, String svgAsset})> transportBadges;
  final String suitableTransportText;

  static const double _heroHeight = 295;
  static const double _mapHeight = 237;
  static const double _radius = 8;
  static const double _pagePadding = 16;
  static const double _sectionGap = 40;
  static const double _heroBodyGap = 16;

  @override
  State<TripClipListingPageComponent> createState() =>
      _TripClipListingPageComponentState();
}

class _TripClipListingPageComponentState
    extends State<TripClipListingPageComponent> {
  late final PageController _controller;
  int _page = 0;

  final TextEditingController _coupon = TextEditingController();
  bool _agreed = false;
  bool _savedActive = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _coupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBg = context.tripClipColors.pageBackground;

    final headingColor = isDark ? Colors.white : TripClipPalette.primary500;
    final sectionHeadingColor = context.tripClipColors.textBase;
    final subtleLabel = context.tripClipColors.textSubtle;
    final iconTint = context.tripClipColors.textSubtle;

    final bodyTextColor = context.tripClipColors.textBase;
    final linkColor = context.tripClipColors.heading;

    final topHeadingStyle = t.headlineLarge!.copyWith(color: headingColor);

    final sectionHeadingStyle =
        t.headlineMedium!.copyWith(color: sectionHeadingColor);

    final addressStyle = t.bodyLarge!.copyWith(color: bodyTextColor);

    final labelCapsStyle = t.titleSmall!.copyWith(
      fontWeight: FontWeight.w500,
      letterSpacing: 12 * 0.05,
      color: subtleLabel,
    );

    final valueStyle = t.bodyMedium!.copyWith(color: bodyTextColor);

    final heroImages = widget.images.isEmpty
        ? const <ImageProvider<Object>>[
            NetworkImage(
              'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/pump.webp',
            ),
          ]
        : widget.images;

    Widget sectionGap() =>
        const SizedBox(height: TripClipListingPageComponent._sectionGap);

    return Scaffold(
      backgroundColor: pageBg,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        primary: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ListingHeroCarousel(
                    controller: _controller,
                    images: heroImages,
                    height: TripClipListingPageComponent._heroHeight,
                    radius: TripClipListingPageComponent._radius,
                    onPageChanged: (i) => setState(() => _page = i),
                  ),
                  _ImageNavigationDots(
                    count: heroImages.length,
                    activeIndex: _page,
                    onDotPressed: (i) => _controller.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                    ),
                  ),
            const SizedBox(height: TripClipListingPageComponent._heroBodyGap),
            Padding(
              padding: const EdgeInsets.all(
                TripClipListingPageComponent._pagePadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TopMetaBlock(
                          headingStyle: topHeadingStyle,
                          isDark: isDark,
                          heading: widget.heading,
                          badgeLabel: widget.badgeLabel,
                          badgeFlexibleLabel: widget.badgeFlexibleLabel,
                          avatarUrl: widget.avatarUrl,
                          userName: widget.userName,
                          ratingText: widget.ratingText,
                          verified: widget.verified,
                          itemsText: widget.itemsText,
                          weightText: widget.weightText,
                          dateText: widget.dateText,
                          savedActive: _savedActive,
                          onSavedToggle: () =>
                              setState(() => _savedActive = !_savedActive),
                          onMakeOffer: () {
                            tripClipPushMaterialPage<void>(
                              context,
                              const TripClipMakeOfferPage(),
                              shellNavHighlightTabIndex: TripClipShellNavRoutes.tripsTabIndex,
                            );
                          },
                          onShare: () => showTripClipTripsShareSheet(context),
                          onMessage: () {
                            tripClipPushMaterialPage<void>(
                              context,
                              TripClipMessagePage(
                                userName: widget.userName,
                                avatarUrl: widget.avatarUrl,
                                ratingText: widget.ratingText,
                              ),
                              shellNavHighlightTabIndex: TripClipShellNavRoutes.tripsTabIndex,
                            );
                          },
                        ),
                        sectionGap(),
                        _PickupDeliverySection(
                          headingStyle: sectionHeadingStyle,
                          badgeLabel: widget.pickupBadgeLabel,
                          address: widget.pickupAddress,
                          mapHeight: TripClipListingPageComponent._mapHeight,
                          radius: TripClipListingPageComponent._radius,
                          addressStyle: addressStyle,
                          capsStyle: labelCapsStyle,
                          valueStyle: valueStyle,
                          iconTint: iconTint,
                          dateLabel: widget.pickupDateLabel,
                          timeLabel: widget.pickupTimeLabel,
                          dateValue: widget.pickupDateValue,
                          timeValue: widget.pickupTimeValue,
                          isDark: isDark,
                        ),
                        sectionGap(),
                        _PickupDeliverySection(
                          headingStyle: sectionHeadingStyle,
                          title: 'Delivery',
                          badgeLabel: widget.deliveryBadgeLabel,
                          address: widget.deliveryAddress,
                          mapHeight: TripClipListingPageComponent._mapHeight,
                          radius: TripClipListingPageComponent._radius,
                          addressStyle: addressStyle,
                          capsStyle: labelCapsStyle,
                          valueStyle: valueStyle,
                          iconTint: iconTint,
                          dateLabel: widget.deliveryDateLabel,
                          timeLabel: widget.deliveryTimeLabel,
                          dateValue: widget.deliveryDateValue,
                          timeValue: widget.deliveryTimeValue,
                          isDark: isDark,
                        ),
                        sectionGap(),
                        Column(
                          children: [
                            for (int i = 0; i < widget.parcels.length; i++) ...[
                              if (i != 0) const SizedBox(height: 16),
                              TripClipParcelInfoCard(
                                indexLabel: widget.parcels[i].indexLabel,
                                title: widget.parcels[i].title,
                                parcelImages: widget.parcels[i].images,
                                description: widget.parcels[i].description,
                                typeLabel: widget.parcels[i].typeLabel,
                                sizeDimensions:
                                    widget.parcels[i].sizeDimensions,
                                weightLabel: widget.parcels[i].weightLabel,
                                insuranceLabel:
                                    widget.parcels[i].insuranceLabel,
                              ),
                            ],
                          ],
                        ),
                        sectionGap(),
                        _TransportSection(
                          headingStyle: sectionHeadingStyle,
                          capsStyle: labelCapsStyle,
                          valueStyle: valueStyle,
                          iconTint: iconTint,
                          badges: widget.transportBadges,
                          suitableText: widget.suitableTransportText,
                        ),
                        sectionGap(),
                        _CouponSection(isDark: isDark, controller: _coupon),
                        sectionGap(),
                        _DeclarationSection(
                          isDark: isDark,
                          iconTint: iconTint,
                          linkColor: linkColor,
                          onBody: bodyTextColor,
                          agreed: _agreed,
                          onAgreedChanged: (v) =>
                              setState(() => _agreed = v),
                        ),
                        const SizedBox(height: 24),
                        _BottomButtons(
                          onPrimary: () {},
                          onMakeOffer: () {
                            tripClipPushMaterialPage<void>(
                              context,
                              const TripClipMakeOfferPage(),
                              shellNavHighlightTabIndex: TripClipShellNavRoutes.tripsTabIndex,
                            );
                          },
                        ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopMetaBlock extends StatelessWidget {
  const _TopMetaBlock({
    required this.headingStyle,
    required this.isDark,
    required this.heading,
    required this.badgeLabel,
    required this.badgeFlexibleLabel,
    required this.avatarUrl,
    required this.userName,
    required this.ratingText,
    required this.verified,
    required this.itemsText,
    required this.weightText,
    required this.dateText,
    required this.savedActive,
    required this.onSavedToggle,
    required this.onMakeOffer,
    required this.onShare,
    required this.onMessage,
  });

  final TextStyle headingStyle;
  final bool isDark;
  final String heading;
  final String badgeLabel;
  final String? badgeFlexibleLabel;

  final String? avatarUrl;
  final String userName;
  final String ratingText;
  final bool verified;

  final String itemsText;
  final String weightText;
  final String dateText;

  final bool savedActive;
  final VoidCallback onSavedToggle;
  final VoidCallback onMakeOffer;
  final VoidCallback onShare;
  final VoidCallback onMessage;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final avatarImage = _resolveAvatarImage(avatarUrl);
    final light = !isDark;

    final dividerColor = context.tripClipColors.borderSubtle;

    final iconBase = context.tripClipColors.textSubtle;
    final ratingTextColor = iconBase;
    final verifyColor = light
        ? TripClipPalette.secondary500
        : TripClipPalette.secondary400;
    final userNameColor = context.tripClipColors.heading;
    final sectionTextColor = context.tripClipColors.textBase;
    final metaTextStyle = t.bodySmall!;
    final dateStyle = t.labelMedium!.copyWith(
      fontSize: 10,
      height: 14 / 10,
      color: ratingTextColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(heading, style: headingStyle)),
            const SizedBox(width: 12),
            TripClipBadgeClip(
              label: badgeLabel,
              flexibleLabel: badgeFlexibleLabel,
            ),
          ],
        ),
        TripClipCardDivider(color: dividerColor),
        Row(
          children: [
            TripClipAvatar(size: TripClipAvatarSize.s28, image: avatarImage),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: metaTextStyle.copyWith(color: userNameColor),
              ),
            ),
            const SizedBox(width: 8),
            _svgIcon('assets/icons/rating-star.svg', color: iconBase),
            const SizedBox(width: 4),
            Text(
              ratingText,
              style: metaTextStyle.copyWith(color: ratingTextColor),
            ),
            if (verified) ...[
              const SizedBox(width: 8),
              _svgIcon('assets/icons/verify.svg', color: verifyColor),
            ],
          ],
        ),
        TripClipCardDivider(color: dividerColor),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _miniMetaRow(
                  context,
                  icon: 'assets/icons/package.svg',
                  text: itemsText,
                  iconColor: iconBase,
                  textColor: sectionTextColor,
                ),
                const SizedBox(width: 8),
                _miniMetaRow(
                  context,
                  icon: 'assets/icons/weight.svg',
                  text: weightText,
                  iconColor: iconBase,
                  textColor: sectionTextColor,
                ),
              ],
            ),
            const Spacer(),
            Text(
              dateText,
              style: dateStyle,
            ),
          ],
        ),
        const SizedBox(height: 52),
        Row(
          children: [
            Expanded(
              child: TripClipButton(
                variant: TripClipButtonVariant.primary,
                expanded: true,
                label: 'Accept Trip',
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TripClipButton(
                variant: TripClipButtonVariant.secondary,
                expanded: true,
                label: 'Make Offer',
                onPressed: onMakeOffer,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TripClipLabeledCircleActionButton(
              svgAsset: 'assets/icons/heart24.svg',
              label: 'Saved',
              selected: savedActive,
              onPressed: onSavedToggle,
            ),
            const SizedBox(width: 40),
            TripClipLabeledCircleActionButton(
              svgAsset: 'assets/icons/share.svg',
              label: 'Share',
              onPressed: onShare,
            ),
            const SizedBox(width: 40),
            TripClipLabeledCircleActionButton(
              svgAsset: 'assets/icons/chat.svg',
              label: 'Message',
              onPressed: onMessage,
            ),
            const SizedBox(width: 40),
            TripClipLabeledCircleActionButton(
              svgAsset: 'assets/icons/more-horizontal.svg',
              label: 'More',
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  static ImageProvider<Object>? _resolveAvatarImage(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) return null;
    if (value.startsWith('assets/')) return AssetImage(value);
    final uri = Uri.tryParse(value);
    final scheme = uri?.scheme.toLowerCase();
    if (scheme == 'http' || scheme == 'https') return NetworkImage(value);
    return null;
  }

  static Widget _svgIcon(String asset, {required Color color}) {
    return SvgPicture.asset(
      asset,
      width: 16,
      height: 16,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  static Widget _miniMetaRow(
    BuildContext context, {
    required String icon,
    required String text,
    required Color iconColor,
    required Color textColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          icon,
          width: 16,
          height: 16,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: textColor),
        ),
      ],
    );
  }
}

class _PickupDeliverySection extends StatelessWidget {
  const _PickupDeliverySection({
    required this.headingStyle,
    this.title = 'Pickup',
    required this.badgeLabel,
    required this.address,
    required this.mapHeight,
    required this.radius,
    required this.addressStyle,
    required this.capsStyle,
    required this.valueStyle,
    required this.iconTint,
    required this.dateLabel,
    required this.timeLabel,
    required this.dateValue,
    required this.timeValue,
    required this.isDark,
  });

  final TextStyle headingStyle;
  final String title;
  final String badgeLabel;
  final String address;

  final double mapHeight;
  final double radius;

  final TextStyle addressStyle;
  final TextStyle capsStyle;
  final TextStyle valueStyle;

  final Color iconTint;

  final String dateLabel;
  final String timeLabel;
  final String dateValue;
  final String timeValue;

  final bool isDark;

  static String _svgForLocationBadge(String label) {
    switch (label.trim().toLowerCase()) {
      case 'business':
        return 'assets/icons/apartment.svg';
      default:
        return 'assets/icons/house.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: headingStyle)),
            TripClipBadgeIconLabel(
              label: badgeLabel,
              svgAsset: _svgForLocationBadge(badgeLabel),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: SizedBox(
            height: mapHeight,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(-37.8136, 144.9631),
                zoom: 11,
              ),
              compassEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              buildingsEnabled: true,
              trafficEnabled: false,
              indoorViewEnabled: false,
              mapType: MapType.normal,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(address, style: addressStyle),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _capsValue(
                icon: 'assets/icons/calendar.svg',
                iconTint: iconTint,
                label: dateLabel,
                labelStyle: capsStyle,
                value: dateValue,
                valueStyle: valueStyle,
              ),
            ),
            Expanded(
              child: _capsValue(
                icon: 'assets/icons/clock.svg',
                iconTint: iconTint,
                label: timeLabel,
                labelStyle: capsStyle,
                value: timeValue,
                valueStyle: valueStyle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _capsValue({
    required String icon,
    required Color iconTint,
    required String label,
    required TextStyle labelStyle,
    required String value,
    required TextStyle valueStyle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(iconTint, BlendMode.srcIn),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label.toUpperCase(),
                style: labelStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: valueStyle),
      ],
    );
  }
}

class _TransportSection extends StatelessWidget {
  const _TransportSection({
    required this.headingStyle,
    required this.capsStyle,
    required this.valueStyle,
    required this.iconTint,
    required this.badges,
    required this.suitableText,
  });

  final TextStyle headingStyle;
  final TextStyle capsStyle;
  final TextStyle valueStyle;
  final Color iconTint;

  final List<({String label, String svgAsset})> badges;
  final String suitableText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Transport', style: headingStyle),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < badges.length; i++) ...[
                if (i != 0) const SizedBox(width: 8),
                TripClipBadgeIconLabel(
                  label: badges[i].label,
                  svgAsset: badges[i].svgAsset,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/car.svg',
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(iconTint, BlendMode.srcIn),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'SUITABLE TRANSPORT',
                style: capsStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(suitableText, style: valueStyle),
      ],
    );
  }
}

class _CouponSection extends StatelessWidget {
  const _CouponSection({required this.isDark, required this.controller});

  final bool isDark;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF1F242B) : const Color(0xFFEFF2F5);
    final headingStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w500,
          color: context.tripClipColors.textBase,
        );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: TripClipCardShadows.whenLight(!isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Coupon Code', style: headingStyle),
          const SizedBox(height: 8),
          TripClipFormInput(
            controller: controller,
            hintText: 'Enter Coupon Code',
          ),
          const SizedBox(height: 16),
          TripClipButton(
            variant: TripClipButtonVariant.secondary,
            expanded: true,
            label: 'Apply',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _DeclarationSection extends StatelessWidget {
  const _DeclarationSection({
    required this.isDark,
    required this.iconTint,
    required this.linkColor,
    required this.onBody,
    required this.agreed,
    required this.onAgreedChanged,
  });

  final bool isDark;
  final Color iconTint;
  final Color linkColor;
  final Color onBody;
  final bool agreed;
  final ValueChanged<bool> onAgreedChanged;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF1F242B) : const Color(0xFFEFF2F5);

    final t = Theme.of(context).textTheme;
    final headingStyle = t.headlineMedium!.copyWith(color: onBody);
    final bodyStyle = t.bodyMedium!.copyWith(color: onBody);
    final linkStyle = t.bodyMedium!.copyWith(
      color: linkColor,
      decoration: TextDecoration.underline,
      decorationColor: linkColor,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: TripClipCardShadows.whenLight(!isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/document-validation.svg',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(iconTint, BlendMode.srcIn),
              ),
              const SizedBox(width: 4),
              Expanded(child: Text('Declaration', style: headingStyle)),
              const SizedBox(width: 8),
              Text('Prohibited Items', style: linkStyle),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "By accepting this trip, you acknowledge that item details are based on the Sender’s declaration.\n\nYou understand that you must inspect the item at pickup and must not carry it if the contents differ from the listing or appear unsafe or restricted.",
            style: bodyStyle,
          ),
          const SizedBox(height: 16),
          TripClipFormCheckbox(
            value: agreed,
            onChanged: (v) => onAgreedChanged(v),
            label: 'I understand and agree',
          ),
        ],
      ),
    );
  }
}

class _BottomButtons extends StatelessWidget {
  const _BottomButtons({required this.onPrimary, required this.onMakeOffer});

  final VoidCallback onPrimary;
  final VoidCallback onMakeOffer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TripClipButton(
            variant: TripClipButtonVariant.primary,
            expanded: true,
            label: 'Accept Trip',
            onPressed: onPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TripClipButton(
            variant: TripClipButtonVariant.secondary,
            expanded: true,
            label: 'Make Offer',
            onPressed: onMakeOffer,
          ),
        ),
      ],
    );
  }
}

class _ListingHeroCarousel extends StatelessWidget {
  const _ListingHeroCarousel({
    required this.controller,
    required this.images,
    required this.height,
    required this.radius,
    required this.onPageChanged,
  });

  final PageController controller;
  final List<ImageProvider<Object>> images;
  final double height;
  final double radius;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(radius),
      ),
      child: SizedBox(
        height: height,
        width: double.infinity,
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
    final dotColor =
        light ? TripClipPalette.neutral500 : TripClipPalette.neutral700;

    return Padding(
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

