import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/navigation/trip_clip_navigator.dart';
import '../../../app/theme/trip_clip_colors.dart';
import '../../../ui/components/cards/trip_clip_heading_card.dart';
import '../../../ui/components/forms/trip_clip_atom_input.dart';
import '../search/trip_clip_trip_search.dart';
import 'trip_clip_trips_scope_args.dart';
import 'trip_clip_trips_sub_page.dart';

class TripsTabPage extends StatefulWidget {
  const TripsTabPage({super.key});

  @override
  State<TripsTabPage> createState() => _TripsTabPageState();
}

class _TripsTabPageState extends State<TripsTabPage> {
  static const double _bodyPadding = 16;
  static const double _carouselItemGap = 8;
  static const double _tripCardWidth = 200;
  static const double _carouselCardShadowMargin = 0;
  static const double _tripCarouselHeight = 150 + 2 * _carouselCardShadowMargin;

  final TextEditingController _searchController = TextEditingController();

  PageController _recommendedController = PageController();
  PageController _within5Controller = PageController();
  PageController _within25Controller = PageController();
  PageController _within50Controller = PageController();
  PageController _melbourneController = PageController();
  PageController _australiaController = PageController();
  PageController _sydneyController = PageController();

  double? _tripViewportFraction;

  int _recommendedIndex = 0;
  int _within5Index = 0;
  int _within25Index = 0;
  int _within50Index = 0;
  int _melbourneIndex = 0;
  int _australiaIndex = 0;
  int _sydneyIndex = 0;

  bool get _hasSearchQuery => _searchController.text.trim().isNotEmpty;

  bool _shouldShowTripsSection(List<_TripCardData> visible) =>
      !_hasSearchQuery || visible.isNotEmpty;

  bool get _hasAnyTripSearchHit {
    if (!_hasSearchQuery) return true;
    return _visibleTrips(_recommended).isNotEmpty ||
        _visibleTrips(_within5km).isNotEmpty ||
        _visibleTrips(_within25km).isNotEmpty ||
        _visibleTrips(_within50km).isNotEmpty ||
        _visibleTrips(_melbourne).isNotEmpty ||
        _visibleTrips(_australia).isNotEmpty ||
        _visibleTrips(_sydney).isNotEmpty;
  }

  Widget _noTripsSearchHitPlaceholder(BuildContext context) {
    final subtle = context.tripClipColors.textBase.withValues(alpha: 0.55);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          'No trips match your search',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: subtle),
        ),
      ),
    );
  }

  List<Widget> _tripSectionWidgets() {
    final out = <Widget>[];

    void appendSection(Widget section) {
      if (out.isNotEmpty) {
        out.add(const SizedBox(height: 40));
      }
      out.add(section);
    }

    void addIfVisible({
      required String title,
      required List<_TripCardData> source,
      required PageController controller,
      required int index,
      required ValueChanged<int> onIndexChanged,
    }) {
      final visible = _visibleTrips(source);
      if (!_shouldShowTripsSection(visible)) return;
      appendSection(
        _section(
          title: title,
          trips: visible,
          controller: controller,
          index: index,
          onIndexChanged: onIndexChanged,
        ),
      );
    }

    addIfVisible(
      title: 'Recommended',
      source: _recommended,
      controller: _recommendedController,
      index: _recommendedIndex,
      onIndexChanged: (i) => setState(() => _recommendedIndex = i),
    );
    addIfVisible(
      title: 'Within 5km',
      source: _within5km,
      controller: _within5Controller,
      index: _within5Index,
      onIndexChanged: (i) => setState(() => _within5Index = i),
    );
    addIfVisible(
      title: 'Within 25km',
      source: _within25km,
      controller: _within25Controller,
      index: _within25Index,
      onIndexChanged: (i) => setState(() => _within25Index = i),
    );
    addIfVisible(
      title: 'Trips within 50km',
      source: _within50km,
      controller: _within50Controller,
      index: _within50Index,
      onIndexChanged: (i) => setState(() => _within50Index = i),
    );
    addIfVisible(
      title: 'Melbourne',
      source: _melbourne,
      controller: _melbourneController,
      index: _melbourneIndex,
      onIndexChanged: (i) => setState(() => _melbourneIndex = i),
    );
    addIfVisible(
      title: 'Australia',
      source: _australia,
      controller: _australiaController,
      index: _australiaIndex,
      onIndexChanged: (i) => setState(() => _australiaIndex = i),
    );
    addIfVisible(
      title: 'Sydney',
      source: _sydney,
      controller: _sydneyController,
      index: _sydneyIndex,
      onIndexChanged: (i) => setState(() => _sydneyIndex = i),
    );

    return out;
  }

  List<_TripCardData> _visibleTrips(List<_TripCardData> source) {
    final q = _searchController.text;
    return source
        .where((t) => tripClipTripSearchMatches(q, t.heading, t.body))
        .toList(growable: false);
  }

  static int _clampCarouselIndex(int index, int length) {
    if (length <= 0) return 0;
    return index.clamp(0, length - 1);
  }

  void _syncTripCarouselsToSearch() {
    final vr = _visibleTrips(_recommended);
    final v5 = _visibleTrips(_within5km);
    final v25 = _visibleTrips(_within25km);
    final v50 = _visibleTrips(_within50km);
    final vm = _visibleTrips(_melbourne);
    final va = _visibleTrips(_australia);
    final vs = _visibleTrips(_sydney);

    setState(() {
      _recommendedIndex = _clampCarouselIndex(_recommendedIndex, vr.length);
      _within5Index = _clampCarouselIndex(_within5Index, v5.length);
      _within25Index = _clampCarouselIndex(_within25Index, v25.length);
      _within50Index = _clampCarouselIndex(_within50Index, v50.length);
      _melbourneIndex = _clampCarouselIndex(_melbourneIndex, vm.length);
      _australiaIndex = _clampCarouselIndex(_australiaIndex, va.length);
      _sydneyIndex = _clampCarouselIndex(_sydneyIndex, vs.length);
    });

    void jump(PageController c, int page, int len) {
      if (len <= 0 || !c.hasClients) return;
      final target = page.clamp(0, len - 1);
      if ((c.page ?? c.initialPage.toDouble()).round() != target) {
        c.jumpToPage(target);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      jump(_recommendedController, _recommendedIndex, vr.length);
      jump(_within5Controller, _within5Index, v5.length);
      jump(_within25Controller, _within25Index, v25.length);
      jump(_within50Controller, _within50Index, v50.length);
      jump(_melbourneController, _melbourneIndex, vm.length);
      jump(_australiaController, _australiaIndex, va.length);
      jump(_sydneyController, _sydneyIndex, vs.length);
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_syncTripCarouselsToSearch);
  }

  final List<_TripCardData> _recommended = const [
    _TripCardData(
      heading: 'Melbourne CBD',
      body: '150 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/melbourne.webp'),
      isFavorite: true,
    ),
    _TripCardData(
      heading: 'Fitzroy',
      body: '10 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/fitzroy.webp'),
      isFavorite: true,
    ),
    _TripCardData(
      heading: 'Sydney CBD',
      body: '56 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/sydney.webp'),
      isFavorite: false,
    ),
    _TripCardData(
      heading: 'Adelaide',
      body: '75 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/adelaide.webp'),
      isFavorite: false,
    ),
  ];

  final List<_TripCardData> _within5km = const [
    _TripCardData(
      heading: 'Dandenong South',
      body: '17 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/dandenong.webp'),
      isFavorite: false,
    ),
    _TripCardData(
      heading: 'Hallam',
      body: '25 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/hallam.webp'),
      isFavorite: false,
    ),
    _TripCardData(
      heading: 'Adelaide',
      body: '75 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/adelaide.webp'),
      isFavorite: false,
    ),
  ];

  final List<_TripCardData> _within25km = const [
    _TripCardData(
      heading: 'Melbourne CBD',
      body: '150 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/melbourne.webp'),
      isFavorite: true,
    ),
    _TripCardData(
      heading: 'Fitzroy',
      body: '10 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/fitzroy.webp'),
      isFavorite: true,
    ),
    _TripCardData(
      heading: 'Adelaide',
      body: '75 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/adelaide.webp'),
      isFavorite: false,
    ),
  ];

  final List<_TripCardData> _within50km = const [
    _TripCardData(
      heading: 'Tullamarine',
      body: '56 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/hallam.webp'),
      isFavorite: false,
    ),
    _TripCardData(
      heading: 'Melton',
      body: '12 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/inner-west.webp'),
      isFavorite: false,
    ),
    _TripCardData(
      heading: 'Adelaide',
      body: '75 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/adelaide.webp'),
      isFavorite: false,
    ),
  ];

  final List<_TripCardData> _melbourne = const [
    _TripCardData(
      heading: 'Melbourne CBD',
      body: '16 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/melbourne.webp'),
      isFavorite: true,
    ),
    _TripCardData(
      heading: 'Inner North',
      body: '17 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/inner-west.webp'),
      isFavorite: false,
    ),
    _TripCardData(
      heading: 'Fitzroy',
      body: '10 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/fitzroy.webp'),
      isFavorite: true,
    ),
  ];

  final List<_TripCardData> _australia = const [
    _TripCardData(
      heading: 'Melbourne CBD',
      body: '150 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/melbourne.webp'),
      isFavorite: true,
    ),
    _TripCardData(
      heading: 'Sydney',
      body: '265 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/sydney.webp'),
      isFavorite: false,
    ),
    _TripCardData(
      heading: 'Adelaide',
      body: '75 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/adelaide.webp'),
      isFavorite: false,
    ),
  ];

  final List<_TripCardData> _sydney = const [
    _TripCardData(
      heading: 'Sydney CBD',
      body: '56 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/sydney.webp'),
      isFavorite: false,
    ),
    _TripCardData(
      heading: 'Eastern Suburbs',
      body: '2 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/inner-west.webp'),
      isFavorite: false,
    ),
    _TripCardData(
      heading: 'Fitzroy',
      body: '10 Trips',
      image: NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/fitzroy.webp'),
      isFavorite: true,
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewportW =
        MediaQuery.sizeOf(context).width - 2 * _bodyPadding;
    if (viewportW <= 0) return;

    final desiredTrips =
        ((_tripCardWidth + _carouselItemGap) / viewportW).clamp(0.0, 1.0);
    if (_tripViewportFraction == null ||
        (_tripViewportFraction! - desiredTrips).abs() >= 0.001) {
      _tripViewportFraction = desiredTrips;

      void replaceController({
        required PageController current,
        required int page,
        required ValueChanged<PageController> set,
      }) {
        final old = current;
        set(
          PageController(
            initialPage: page,
            viewportFraction: desiredTrips,
          ),
        );
        old.dispose();
      }

      replaceController(
        current: _recommendedController,
        page: _recommendedIndex,
        set: (c) => _recommendedController = c,
      );
      replaceController(
        current: _within5Controller,
        page: _within5Index,
        set: (c) => _within5Controller = c,
      );
      replaceController(
        current: _within25Controller,
        page: _within25Index,
        set: (c) => _within25Controller = c,
      );
      replaceController(
        current: _within50Controller,
        page: _within50Index,
        set: (c) => _within50Controller = c,
      );
      replaceController(
        current: _melbourneController,
        page: _melbourneIndex,
        set: (c) => _melbourneController = c,
      );
      replaceController(
        current: _australiaController,
        page: _australiaIndex,
        set: (c) => _australiaController = c,
      );
      replaceController(
        current: _sydneyController,
        page: _sydneyIndex,
        set: (c) => _sydneyController = c,
      );
    }
  }

  void _previous(PageController controller, int index) {
    if (controller.hasClients) {
      if (controller.position.pixels <= 0.5) return;
    } else if (index <= 0) {
      return;
    }
    controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _next(PageController controller, int index, int total) {
    if (total <= 0) return;
    if (controller.hasClients) {
      if (controller.position.pixels >=
          controller.position.maxScrollExtent - 0.5) {
        return;
      }
    } else if (index >= total - 1) {
      return;
    }
    controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  bool _canGoPrevious(PageController controller, int index) {
    if (controller.hasClients) {
      return controller.position.pixels > 0.5;
    }
    return index > 0;
  }

  bool _canGoNext(PageController controller, int index, int total) {
    if (total <= 0) return false;
    if (controller.hasClients) {
      return controller.position.pixels < controller.position.maxScrollExtent - 0.5;
    }
    return index < total - 1;
  }

  void _openTripsListForScope(String scopeTitle, int tripCount) {
    tripClipPushMaterialPage<void>(
      context,
      TripClipTripsSubPage(
        args: TripClipTripsScopeArgs(
          scopeTitle: scopeTitle,
          tripCount: tripCount,
        ),
      ),
      shellNavHighlightTabIndex: TripClipShellNavRoutes.tripsTabIndex,
    );
  }

  Widget _tripCarousel({
    required PageController controller,
    required int index,
    required ValueChanged<int> onPageChanged,
    required List<_TripCardData> trips,
  }) {
    return SizedBox(
      height: _tripCarouselHeight,
      child: trips.isEmpty
          ? const SizedBox.shrink()
          : Padding(
              padding: EdgeInsetsDirectional.only(
                start: index < 1 ? _bodyPadding : 0,
                end: index < 1 ? 0 : _bodyPadding,
              ),
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (_) {
                  if (!controller.hasClients) {
                    if (mounted) setState(() {});
                    return false;
                  }
                  final maxScroll = controller.position.maxScrollExtent;
                  final pixels = controller.position.pixels;
                  final atRightEdge = pixels >= maxScroll - 0.5;
                  final settledIndex = atRightEdge
                      ? trips.length - 1
                      : (controller.page ?? index.toDouble())
                          .round()
                          .clamp(0, trips.length - 1);
                  if (settledIndex != index) {
                    onPageChanged(settledIndex);
                    return false;
                  }
                  if (mounted) setState(() {});
                  return false;
                },
                child: PageView.builder(
                  clipBehavior: Clip.none,
                  controller: controller,
                  padEnds: false,
                  onPageChanged: onPageChanged,
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
                        onTap: () => _openTripsListForScope(
                          t.heading,
                          tripClipTripCountFromBody(t.body),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  Widget _section({
    required String title,
    required List<_TripCardData> trips,
    required PageController controller,
    required int index,
    required ValueChanged<int> onIndexChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(_bodyPadding, 0, 10, 0),
          child: _CarouselSectionHeader(
            title: title,
            onPrevious: () => _previous(controller, index),
            onNext: () => _next(controller, index, trips.length),
            canGoPrevious: _canGoPrevious(controller, index),
            canGoNext: _canGoNext(controller, index, trips.length),
          ),
        ),
        const SizedBox(height: 8),
        _tripCarousel(
          controller: controller,
          index: index,
          onPageChanged: onIndexChanged,
          trips: trips,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_syncTripCarouselsToSearch);
    _recommendedController.dispose();
    _within5Controller.dispose();
    _within25Controller.dispose();
    _within50Controller.dispose();
    _melbourneController.dispose();
    _australiaController.dispose();
    _sydneyController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerBorder = context.tripClipColors.borderSubtle;
    final headerStyle = Theme.of(context).textTheme.headlineLarge!.copyWith(
          color: context.tripClipColors.heading,
        );

    return Scaffold(
      backgroundColor: context.tripClipColors.pageBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 44,
              padding: const EdgeInsets.only(left: _bodyPadding),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: headerBorder, width: 1),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Text('Trips', style: headerStyle),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: _bodyPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: _bodyPadding,
                      ),
                      child: TripClipAtomInput(
                        controller: _searchController,
                        hintText: 'Search Trips',
                        showTrailing: false,
                        showLeading: true,
                        leadingIconAsset: 'assets/icons/search.svg',
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (_hasSearchQuery && !_hasAnyTripSearchHit)
                      _noTripsSearchHitPlaceholder(context),
                    ..._tripSectionWidgets(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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

    final titleStyle = Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: titleColor,
        );

    return Row(
      children: [
        Expanded(
          child: Text(title, style: titleStyle),
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
