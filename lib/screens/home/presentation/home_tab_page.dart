import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/trip_clip_app.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../../ui/components/cards/trip_clip_heading_card.dart';
import '../../../ui/components/cards/trip_clip_semi_feature_card.dart';
import '../../../ui/components/forms/trip_clip_atom_input.dart';
import '../../../ui/components/trip_clip_home_app_bar.dart';
import '../../components/presentation/components_page.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  static const int _favorites = 3;
  static const int _notifications = 9;

  static const double _sectionHorizontalPadding = 16;
  static const double _carouselItemGap = 8;
  static const double _tripCardWidth = 200;

  /// Vertical margin around carousel cards so [TripClipCardShadows] is not clipped.
  static const double _carouselCardShadowMargin = 0;

  /// [TripClipHeadingCard] is 150px tall; margins sit outside that fixed size.
  static const double _tripCarouselHeight = 150 + 2 * _carouselCardShadowMargin;

  double? _parcelCarouselHeight;

  final TextEditingController _searchController = TextEditingController();
  final PageController _parcelPageController = PageController();
  final PageController _tripPageController = PageController(
    viewportFraction: 0.62,
  );

  int _parcelPageIndex = 0;
  int _tripPageIndex = 0;

  /// Track width inside section horizontal padding (one full-width parcel slide).
  double _parcelTrackWidthFromContext(BuildContext context) =>
      MediaQuery.sizeOf(context).width - 2 * _sectionHorizontalPadding;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  void _maybeUpdateParcelCarouselHeight(Size size) {
    // Avoid setState storms; only update when it actually changes.
    final next = size.height;
    if (next <= 0) return;
    if ((_parcelCarouselHeight ?? -1).toStringAsFixed(1) ==
        next.toStringAsFixed(1)) {
      return;
    }
    if (mounted) setState(() => _parcelCarouselHeight = next);
  }

  void _parcelPrevious() {
    if (_parcelPageIndex <= 0) return;
    _parcelPageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _parcelNext() {
    if (_parcelPageIndex >= _parcels.length - 1) return;
    _parcelPageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  bool get _parcelCanGoPrevious {
    return _parcelPageIndex > 0;
  }

  bool get _parcelCanGoNext {
    return _parcelPageIndex < _parcels.length - 1;
  }

  void _tripPrevious() {
    if (_tripPageIndex <= 0) return;
    _tripPageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _tripNext() {
    if (_tripPageIndex >= _trips.length - 1) return;
    _tripPageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  bool get _tripCanGoPrevious {
    return _tripPageIndex > 0;
  }

  bool get _tripCanGoNext {
    return _tripPageIndex < _trips.length - 1;
  }

  // Static data for now (easy to replace with backend models later).
  final List<_ParcelCardData> _parcels = const [
    _ParcelCardData(
      image: AssetImage('assets/images/pump.png'),
      verified: true,
      avatarUrl: 'https://i.pravatar.cc/128?img=12',
      heading: 'Spare Ute Parts',
      priceLabel: r'$50',
      pickupLocation: 'Fitzroy VIC 3065',
      deliveryLocation: 'Ringwood North VIC 3134',
      itemsText: '3 Items',
      weightText: '35 kg',
      footerDateText: 'Feb 17, 2026',
    ),
    _ParcelCardData(
      image: AssetImage('assets/images/guitar.png'),
      verified: false,
      avatarUrl: 'https://i.pravatar.cc/128?img=25',
      heading: 'Spare Engine Parts',
      priceLabel: r'$25',
      pickupLocation: 'Melbourne VIC 3000',
      deliveryLocation: 'South Yarra VIC 3141',
      itemsText: '1 Item',
      weightText: '10 kg',
      footerDateText: 'Feb 02, 2026',
    ),
    _ParcelCardData(
      image: AssetImage('assets/images/pump.png'),
      verified: true,
      avatarUrl: 'https://i.pravatar.cc/128?img=33',
      heading: 'Spare Ute Parts',
      priceLabel: r'$50',
      pickupLocation: 'Fitzroy VIC 3065',
      deliveryLocation: 'Ringwood North VIC 3134',
      itemsText: '3 Items',
      weightText: '35 kg',
      footerDateText: 'Feb 17, 2026',
    ),
  ];

  final List<_TripCardData> _trips = const [
    _TripCardData(
      heading: 'Melbourne CBD',
      body: '150 Trips',
      image: AssetImage('assets/images/bridge.jpg'),
      isFavorite: true,
    ),
    _TripCardData(
      heading: 'Fitzroy',
      body: '10 Trips',
      image: AssetImage('assets/images/s_street.jpg'),
      isFavorite: false,
    ),
    _TripCardData(
      heading: 'Melbourne CBD',
      body: '150 Trips',
      image: AssetImage('assets/images/bridge.jpg'),
      isFavorite: true,
    ),
  ];

  @override
  void dispose() {
    _parcelPageController.dispose();
    _tripPageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

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

    final greetingColor = light ? const Color(0xFF141E46) : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TripClipHomeAppBar(
          favoritesCount: _favorites,
          notificationsCount: _notifications,
          onLogoPressed: () =>
              TripClipAppScope.of(context).replayStartLoading(),
          onNotificationsPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ComponentsPage()),
            );
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _sectionHorizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Good morning, John',
                        style: _rubik(
                          size: 16,
                          lineHeight: 24,
                          weight: FontWeight.w600,
                          letterSpacing: 0,
                          color: greetingColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TripClipAtomInput(
                        controller: _searchController,
                        hintText: 'Search TripClip',
                        showTrailing: false,
                        showLeading: true,
                        leading: SvgPicture.asset(
                          'assets/icons/search.svg',
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            light
                                ? TripClipPalette.neutral600
                                : TripClipPalette.neutral300,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _sectionHorizontalPadding,
                  ),
                  child: _CarouselSectionHeader(
                    title: 'My Parcels',
                    onPrevious: _parcelPrevious,
                    onNext: _parcelNext,
                    canGoPrevious: _parcelCanGoPrevious,
                    canGoNext: _parcelCanGoNext,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _sectionHorizontalPadding,
                  ),
                  child: Builder(
                    builder: (context) {
                      final slideW = _parcelTrackWidthFromContext(context);

                      Widget buildCard(
                        _ParcelCardData p, {
                        bool measure = false,
                      }) {
                        final child = Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: _carouselCardShadowMargin,
                          ),
                          child: TripClipSemiFeatureCard(
                            image: p.image,
                            verified: p.verified,
                            avatarUrl: p.avatarUrl,
                            heading: p.heading,
                            badgeLabel: p.priceLabel,
                            pickupLocation: p.pickupLocation,
                            deliveryLocation: p.deliveryLocation,
                            itemsText: p.itemsText,
                            weightText: p.weightText,
                            footerDateText: p.footerDateText,
                          ),
                        );
                        if (!measure) return child;
                        return _MeasureSize(
                          onChange: _maybeUpdateParcelCarouselHeight,
                          child: child,
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Offstage(
                            offstage: true,
                            child: SizedBox(
                              width: slideW,
                              child: buildCard(_parcels.first, measure: true),
                            ),
                          ),
                          if (_parcelCarouselHeight != null)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOutCubic,
                              height: _parcelCarouselHeight,
                              child: PageView.builder(
                                clipBehavior: Clip.none,
                                controller: _parcelPageController,
                                padEnds: false,
                                onPageChanged: (i) =>
                                    setState(() => _parcelPageIndex = i),
                                itemCount: _parcels.length,
                                itemBuilder: (context, i) {
                                  final p = _parcels[i];
                                  final isLast = i == _parcels.length - 1;
                                  return Padding(
                                    padding: EdgeInsetsDirectional.only(
                                      end: isLast ? 0 : _carouselItemGap,
                                    ),
                                    child: SizedBox(
                                      width: slideW,
                                      child: buildCard(p),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _sectionHorizontalPadding,
                  ),
                  child: _CarouselSectionHeader(
                    title: 'Recommend Trips',
                    onPrevious: _tripPrevious,
                    onNext: _tripNext,
                    canGoPrevious: _tripCanGoPrevious,
                    canGoNext: _tripCanGoNext,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: _tripCarouselHeight,
                  child: PageView.builder(
                    clipBehavior: Clip.none,
                    controller: _tripPageController,
                    padEnds: false,
                    onPageChanged: (i) => setState(() => _tripPageIndex = i),
                    itemCount: _trips.length,
                    itemBuilder: (context, i) {
                      final t = _trips[i];
                      final isLast = i == _trips.length - 1;
                      return Padding(
                        padding: EdgeInsetsDirectional.only(
                          start: i == 0 ? _sectionHorizontalPadding : 0,
                          end: isLast
                              ? _sectionHorizontalPadding
                              : _carouselItemGap,
                        ),
                        child: TripClipHeadingCard(
                          width: _tripCardWidth,
                          height: 150,
                          heading: t.heading,
                          body: t.body,
                          backgroundImage: t.image,
                          initialFavorite: t.isFavorite,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CarouselSectionHeader extends StatelessWidget {
  const _CarouselSectionHeader({
    required this.title,
    required this.onPrevious,
    required this.onNext,
    required this.canGoPrevious,
    required this.canGoNext,
  });

  final String title;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool canGoPrevious;
  final bool canGoNext;

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final titleColor = light ? TripClipPalette.tertiary500 : Colors.white;
    final iconOn = titleColor;
    final iconOff = titleColor.withValues(alpha: 0.35);

    Widget chevronButton({
      required String asset,
      required VoidCallback onPressed,
      required bool enabled,
    }) {
      return IconButton(
        onPressed: enabled ? onPressed : null,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        icon: SvgPicture.asset(
          asset,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            enabled ? iconOn : iconOff,
            BlendMode.srcIn,
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.rubik(
              fontSize: 22,
              height: 26 / 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
              color: titleColor,
            ),
          ),
        ),
        chevronButton(
          asset: 'assets/icons/chevron-left.svg',
          onPressed: onPrevious,
          enabled: canGoPrevious,
        ),
        chevronButton(
          asset: 'assets/icons/chevron-right.svg',
          onPressed: onNext,
          enabled: canGoNext,
        ),
      ],
    );
  }
}

class _ParcelCardData {
  const _ParcelCardData({
    required this.image,
    required this.verified,
    required this.avatarUrl,
    required this.heading,
    required this.priceLabel,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.itemsText,
    required this.weightText,
    required this.footerDateText,
  });

  final ImageProvider<Object> image;
  final bool verified;
  final String? avatarUrl;
  final String heading;
  final String priceLabel;
  final String pickupLocation;
  final String deliveryLocation;
  final String itemsText;
  final String weightText;
  final String footerDateText;
}

class _TripCardData {
  const _TripCardData({
    required this.heading,
    required this.body,
    required this.image,
    required this.isFavorite,
  });

  final String heading;
  final String body;
  final ImageProvider<Object> image;
  final bool isFavorite;
}

class _MeasureSize extends SingleChildRenderObjectWidget {
  const _MeasureSize({required this.onChange, required super.child});

  final ValueChanged<Size> onChange;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMeasureSize(onChange);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _RenderMeasureSize).onChange = onChange;
  }
}

class _RenderMeasureSize extends RenderProxyBox {
  _RenderMeasureSize(this.onChange);

  ValueChanged<Size> onChange;
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    final newSize = child?.size ?? size;
    if (_oldSize == newSize) return;
    _oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}
