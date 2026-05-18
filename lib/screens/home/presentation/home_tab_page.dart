import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../app/trip_clip_app.dart';
import '../../../app/navigation/trip_clip_navigator.dart';
import '../../../app/theme/trip_clip_colors.dart';
import '../../../ui/components/cards/trip_clip_heading_card.dart';
import '../../../ui/components/cards/trip_clip_semi_feature_card.dart';
import '../../../ui/components/forms/trip_clip_atom_input.dart';
import '../../../ui/components/trip_clip_home_app_bar.dart';
import '../../account/presentation/account_setting/trip_clip_notifications_page.dart';
import '../../trips/presentation/trip_clip_favourite_trips_page.dart';
import '../../trips/presentation/trip_clip_trips_scope_args.dart';
import '../../trips/presentation/trip_clip_trips_sub_page.dart';
import '../../trips/search/trip_clip_trip_search.dart';

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
  static const double _semiFeatureCardWidth = 361;

  static const double _carouselCardShadowMargin = 0;
  static const double _tripCarouselHeight = 150 + 2 * _carouselCardShadowMargin;

  double? _parcelCarouselHeight;

  final TextEditingController _searchController = TextEditingController();
  PageController _parcelPageController = PageController();
  double? _parcelViewportFraction;
  PageController _tripPageController = PageController();
  double? _tripViewportFraction;

  int _parcelPageIndex = 0;
  int _tripPageIndex = 0;

  List<_TripCardData> get _visibleTrips {
    final q = _searchController.text;
    return _trips
        .where((t) => tripClipTripSearchMatches(q, t.heading, t.body))
        .toList(growable: false);
  }

  void _onSearchChanged() {
    final trips = _visibleTrips;
    setState(() {
      if (trips.isEmpty) {
        _tripPageIndex = 0;
      } else if (_tripPageIndex >= trips.length) {
        _tripPageIndex = trips.length - 1;
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final c = _tripPageController;
      if (!c.hasClients || trips.isEmpty) return;
      final target = _tripPageIndex.clamp(0, trips.length - 1);
      if ((c.page ?? c.initialPage.toDouble()).round() != target) {
        c.jumpToPage(target);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewportW =
        MediaQuery.sizeOf(context).width - 2 * _sectionHorizontalPadding;
    if (viewportW <= 0) return;
    final desiredParcels =
        ((_semiFeatureCardWidth + _carouselItemGap) / viewportW).clamp(
          0.0,
          1.0,
        );
    if (_parcelViewportFraction == null ||
        (_parcelViewportFraction! - desiredParcels).abs() >= 0.001) {
      final old = _parcelPageController;
      final currentPage = _parcelPageIndex;
      _parcelViewportFraction = desiredParcels;
      _parcelPageController = PageController(
        initialPage: currentPage,
        viewportFraction: desiredParcels,
      );
      old.dispose();
    }

    final desiredTrips = ((_tripCardWidth + _carouselItemGap) / viewportW)
        .clamp(0.0, 1.0);
    if (_tripViewportFraction == null ||
        (_tripViewportFraction! - desiredTrips).abs() >= 0.001) {
      final old = _tripPageController;
      final currentPage = _tripPageIndex;
      _tripViewportFraction = desiredTrips;
      _tripPageController = PageController(
        initialPage: currentPage,
        viewportFraction: desiredTrips,
      );
      old.dispose();
    }
  }

  void _openTripScopeFromCard(_TripCardData t) {
    tripClipPushMaterialPage<void>(
      context,
      TripClipTripsSubPage(
        args: TripClipTripsScopeArgs(
          scopeTitle: t.heading,
          tripCount: tripClipTripCountFromBody(t.body),
        ),
      ),
      shellNavHighlightTabIndex: TripClipShellNavRoutes.tripsTabIndex,
    );
  }

  void _maybeUpdateParcelCarouselHeight(Size size) {
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
    if (_tripPageController.hasClients) {
      if (_tripPageController.position.pixels <= 0.5) return;
    } else if (_tripPageIndex <= 0) {
      return;
    }
    _tripPageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _tripNext() {
    final n = _visibleTrips.length;
    if (n == 0) return;
    if (_tripPageController.hasClients) {
      if (_tripPageController.position.pixels >=
          _tripPageController.position.maxScrollExtent - 0.5) {
        return;
      }
    } else if (_tripPageIndex >= n - 1) {
      return;
    }
    _tripPageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  bool get _tripCanGoPrevious {
    if (_tripPageController.hasClients) {
      return _tripPageController.position.pixels > 0.5;
    }
    return _tripPageIndex > 0;
  }

  bool get _tripCanGoNext {
    final n = _visibleTrips.length;
    if (n == 0) return false;
    if (_tripPageController.hasClients) {
      return _tripPageController.position.pixels <
          _tripPageController.position.maxScrollExtent - 0.5;
    }
    return _tripPageIndex < n - 1;
  }

  final List<_ParcelCardData> _parcels = const [
    _ParcelCardData(
      image: NetworkImage(
        'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/pump.webp',
      ),
      verified: true,
      avatarUrl:
          'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/john-doe.webp',
      heading: 'Spare Ute Parts',
      priceLabel: r'$50',
      pickupLocation: 'Fitzroy VIC 3065',
      deliveryLocation: 'Ringwood North VIC 3134',
      itemsText: '3 Items',
      weightText: '35 kg',
      footerDateText: 'Feb 17, 2026',
    ),
    _ParcelCardData(
      image: NetworkImage(
        'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/guitar.webp',
      ),
      verified: false,
      avatarUrl:
          'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/john-doe.webp',
      heading: 'Spare Engine Parts',
      priceLabel: r'$25',
      pickupLocation: 'Melbourne VIC 3000',
      deliveryLocation: 'South Yarra VIC 3141',
      itemsText: '1 Item',
      weightText: '10 kg',
      footerDateText: 'Feb 02, 2026',
    ),
    _ParcelCardData(
      image: NetworkImage(
        'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/pump.webp',
      ),
      verified: true,
      avatarUrl:
          'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/john-doe.webp',
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
      image: NetworkImage(
        'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/melbourne.webp',
      ),
      isFavorite: true,
    ),
    _TripCardData(
      heading: 'Fitzroy',
      body: '10 Trips',
      image: NetworkImage(
        'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/fitzroy.webp',
      ),
      isFavorite: true,
    ),
    _TripCardData(
      heading: 'Adelaide',
      body: '75 Trips',
      image: NetworkImage(
        'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/adelaide.webp',
      ),
      isFavorite: true,
    ),
  ];

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _parcelPageController.dispose();
    _tripPageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final greetingColor = context.tripClipColors.textBase;
    final greetingStyle = t.bodyMedium!.copyWith(
      fontWeight: FontWeight.w600,
      color: greetingColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TripClipHomeAppBar(
          favoritesCount: _favorites,
          notificationsCount: _notifications,
          onLogoPressed: () =>
              TripClipAppScope.of(context).replayStartLoading(),
          onFavoritesPressed: () {
            final favTrips = _trips
                .where((t) => t.isFavorite)
                .map(
                  (t) => TripClipFavouriteTripCardData(
                    heading: t.heading,
                    body: t.body,
                    image: t.image,
                  ),
                )
                .toList(growable: false);
            tripClipPushMaterialPage<void>(
              context,
              TripClipFavouriteTripsPage(trips: favTrips),
            );
          },
          onNotificationsPressed: () {
            tripClipPushMaterialPage<void>(
              context,
              const TripClipNotificationsPage(),
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
                        style: greetingStyle,
                      ),
                      const SizedBox(height: 8),
                      TripClipAtomInput(
                        controller: _searchController,
                        hintText: 'Search TripClip',
                        showTrailing: false,
                        showLeading: true,
                        leadingIconAsset: 'assets/icons/search.svg',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 10, 0),
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
                    horizontal: 0,
                  ),
                  child: Builder(
                    builder: (context) {
                      const slideW = _semiFeatureCardWidth;

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
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(
                                  start: _parcelPageIndex < _parcels.length - 1
                                      ? _sectionHorizontalPadding
                                      : 0,
                                  end: _parcelPageIndex < _parcels.length - 1
                                      ? 0
                                      : _sectionHorizontalPadding,
                                ),
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
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 10, 0),
                  child: _CarouselSectionHeader(
                    title: 'Recommend Trips',
                    onPrevious: _tripPrevious,
                    onNext: _tripNext,
                    canGoPrevious: _tripCanGoPrevious,
                    canGoNext: _tripCanGoNext,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                  ),
                  child: SizedBox(
                    height: _tripCarouselHeight,
                    child: Builder(
                      builder: (context) {
                        final trips = _visibleTrips;
                        if (trips.isEmpty) {
                          final subtle = context.tripClipColors.textBase
                              .withValues(alpha: 0.55);
                          return Center(
                            child: Text(
                              _searchController.text.trim().isEmpty
                                  ? 'No trips to show'
                                  : 'No trips match your search',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: subtle),
                            ),
                          );
                        }
                        return Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: _tripPageIndex < 1
                                ? _sectionHorizontalPadding
                                : 0,
                            end: _tripPageIndex < 1
                                ? 0
                                : _sectionHorizontalPadding,
                          ),
                          child: NotificationListener<ScrollEndNotification>(
                            onNotification: (_) {
                              if (!_tripPageController.hasClients) {
                                if (mounted) setState(() {});
                                return false;
                              }
                              final maxScroll =
                                  _tripPageController.position.maxScrollExtent;
                              final pixels = _tripPageController.position.pixels;
                              final atRightEdge = pixels >= maxScroll - 0.5;
                              final settledIndex = atRightEdge
                                  ? trips.length - 1
                                  : (_tripPageController.page ??
                                          _tripPageIndex.toDouble())
                                      .round()
                                      .clamp(0, trips.length - 1);
                              if (settledIndex != _tripPageIndex) {
                                setState(() => _tripPageIndex = settledIndex);
                                return false;
                              }
                              if (mounted) setState(() {});
                              return false;
                            },
                            child: PageView.builder(
                              clipBehavior: Clip.none,
                              controller: _tripPageController,
                              padEnds: false,
                              onPageChanged: (i) =>
                                  setState(() => _tripPageIndex = i),
                              itemCount: trips.length,
                              itemBuilder: (context, i) {
                                final t = trips[i];
                                final isLast = i == trips.length - 1;
                                return Padding(
                                  padding: EdgeInsetsDirectional.only(
                                    end: isLast ? 0 : _carouselItemGap,
                                  ),
                                  child: TripClipHeadingCard(
                                    width: _tripCardWidth,
                                    height: 150,
                                    heading: t.heading,
                                    body: t.body,
                                    backgroundImage: t.image,
                                    initialFavorite: t.isFavorite,
                                    onTap: () => _openTripScopeFromCard(t),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
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
    final titleColor = context.tripClipColors.textBase;
    final iconOn = titleColor;
    final iconOff = titleColor.withValues(alpha: 0.35);

    Widget chevronButton({
      required String asset,
      required VoidCallback onPressed,
      required bool enabled,
    }) {
      return SizedBox(
        width: 30,
        height: 30,
        child: IconButton(
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
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: titleColor,
                ),
          ),
        ),
        const SizedBox(width: 8),
        chevronButton(
          asset: 'assets/icons/chevron-left.svg',
          onPressed: onPrevious,
          enabled: canGoPrevious,
        ),
        const SizedBox(width: 8),
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
