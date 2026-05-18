import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../app/navigation/trip_clip_navigator.dart';
import '../../../ui/components/cards/trip_clip_semi_feature_card.dart';
import 'trip_clip_listing_page.dart';
import '../../../ui/maps/trip_clip_map_price_marker_bitmap.dart';
import 'sort_filter/trip_clip_trips_filter.dart';
import 'sort_filter/trip_clip_trips_filter_sheet.dart';
import 'sort_filter/trip_clip_trips_sort.dart';
import 'trip_clip_trips_drill_shell.dart';
import 'trip_clip_trips_map_offer_presentations.dart';
import 'trip_clip_trips_scope_args.dart';
import 'sort_filter/trip_clip_trips_sort_sheet.dart';

class TripClipTripsMapPage extends StatefulWidget {
  const TripClipTripsMapPage({super.key, required this.args});

  final TripClipTripsScopeArgs args;

  @override
  State<TripClipTripsMapPage> createState() => _TripClipTripsMapPageState();
}

class _TripClipTripsMapPageState extends State<TripClipTripsMapPage> {
  static const LatLng _fallbackCenter = LatLng(-37.7985, 144.978);

  static const double _fitBoundsPaddingPx = 72;

  TripClipTripsSortOption _sort = TripClipTripsSortOption.bestMatch;
  TripClipTripsFilterCriteria _filter = TripClipTripsFilterCriteria.cleared();
  Set<Marker> _markers = {};
  TripClipTripsSortableMapOffer? _selectedOffer;
  GoogleMapController? _mapController;

  List<TripClipTripsSortableMapOffer> get _visibleOffers {
    final sorted =
        tripClipSortMapOffers(TripClipTripsSortableMapOffer.defaults, _sort);
    return tripClipFilterMapOffers(sorted, _filter);
  }

  int get _mapViewKey => Object.hash(
        _sort.name,
        _filter.maxDistanceKm,
        _filter.clipMaxAud,
        _filter.parcelType,
        _filter.sizeCode,
        _filter.weightBand,
        _filter.maxWeightKg,
        _filter.locationText,
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMarkers());
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadMarkers() async {
    if (!mounted) return;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final sorted = _visibleOffers;

    TripClipTripsSortableMapOffer? nextSelected = _selectedOffer;
    if (nextSelected != null &&
        !sorted.any((e) => e.mapOfferId == nextSelected!.mapOfferId)) {
      nextSelected = null;
    }

    final next = <Marker>{};
    for (var i = 0; i < sorted.length; i++) {
      final p = sorted[i];
      final icon = await TripClipMapPriceMarkerBitmap.build(
        priceLabel: p.priceLabel,
        flexibleLabel: p.flexibleLabel,
        devicePixelRatio: dpr,
      );
      next.add(
        Marker(
          markerId: MarkerId('map_offer_${p.mapOfferId}'),
          position: p.position,
          icon: icon,
          anchor: const Offset(0.5, 1),
          zIndexInt: sorted.length - i,
          onTap: () => setState(() => _selectedOffer = p),
        ),
      );
    }
    if (!mounted) return;
    setState(() {
      _markers = next;
      _selectedOffer = nextSelected;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fitCameraToVisibleOffers();
    });
  }

  LatLngBounds? _latLngBoundsForOffers(List<TripClipTripsSortableMapOffer> offers) {
    if (offers.isEmpty) return null;
    var minLat = offers.first.position.latitude;
    var maxLat = minLat;
    var minLng = offers.first.position.longitude;
    var maxLng = minLng;
    for (final o in offers.skip(1)) {
      minLat = math.min(minLat, o.position.latitude);
      maxLat = math.max(maxLat, o.position.latitude);
      minLng = math.min(minLng, o.position.longitude);
      maxLng = math.max(maxLng, o.position.longitude);
    }
    const padDeg = 0.0002;
    if ((maxLat - minLat).abs() < 1e-7) {
      minLat -= padDeg;
      maxLat += padDeg;
    }
    if ((maxLng - minLng).abs() < 1e-7) {
      minLng -= padDeg;
      maxLng += padDeg;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<void> _fitCameraToVisibleOffers() async {
    final controller = _mapController;
    if (controller == null || !mounted) return;
    final offers = _visibleOffers;
    if (offers.isEmpty) return;

    if (offers.length == 1) {
      await controller.moveCamera(
        CameraUpdate.newLatLngZoom(offers.first.position, 16),
      );
      return;
    }

    final bounds = _latLngBoundsForOffers(offers);
    if (bounds == null) return;
    try {
      await controller.moveCamera(
        CameraUpdate.newLatLngBounds(bounds, _fitBoundsPaddingPx),
      );
    } catch (_) {
      await controller.moveCamera(
        CameraUpdate.newLatLngZoom(
          tripClipMapOffersCenter(offers),
          15,
        ),
      );
    }
  }

  void _pushListingForOffer(TripClipTripsSortableMapOffer offer) {
    final pres = tripClipTripsMapPresentationFor(offer);
    final heading = pres.heading.contains(' & ')
        ? pres.heading.replaceAll(' & ', ' &\n')
        : pres.heading;
    final imgs = pres.images;
    final listingImages =
        imgs.length > 3 ? imgs.sublist(0, 3) : List<ImageProvider<Object>>.from(imgs);

    final parcels = <TripClipListingParcelModel>[
      for (var i = 0; i < imgs.length; i++)
        TripClipListingParcelModel(
          indexLabel: '${i + 1}',
          title: i == 0 ? pres.heading : '${pres.heading} · part ${i + 1}',
          images: [imgs[i]],
          description:
              'Ready for collection near ${pres.pickupLocation}. Delivery toward ${pres.deliveryLocation}.',
          typeLabel: 'Parcel',
          sizeDimensions: '—',
          weightLabel: pres.weightText,
          insuranceLabel: 'Basic',
        ),
    ];

    tripClipPushMaterialPage<void>(
      context,
      TripClipListingPageComponent(
        images: listingImages,
        heading: heading,
        badgeLabel: offer.priceLabel,
        badgeFlexibleLabel: offer.flexibleLabel,
        avatarUrl: pres.avatarUrl,
        userName: pres.userName,
        ratingText: pres.ratingText,
        verified: true,
        itemsText: pres.itemsText,
        weightText: pres.weightText,
        dateText: pres.footerDateText,
        pickupBadgeLabel: 'Residential',
        pickupAddress: '${pres.pickupLocation} Australia',
        pickupDateLabel: 'Pickup Date',
        pickupTimeLabel: 'Pickup Time',
        pickupDateValue: pres.pickupDate,
        pickupTimeValue: pres.pickupTime,
        deliveryBadgeLabel: 'Business',
        deliveryAddress: '${pres.deliveryLocation} Australia',
        deliveryDateLabel: 'Delivery Date',
        deliveryTimeLabel: 'Delivery Time',
        deliveryDateValue: pres.deliveryDate,
        deliveryTimeValue: pres.deliveryTime,
        parcels: parcels,
        transportBadges: const [
          (label: 'On Foot', svgAsset: 'assets/icons/walk.svg'),
          (label: 'Bike', svgAsset: 'assets/icons/bike.svg'),
          (label: 'SM', svgAsset: 'assets/icons/package-dimensions.svg'),
          (label: 'MD', svgAsset: 'assets/icons/package-dimensions.svg'),
          (label: 'LG', svgAsset: 'assets/icons/package-dimensions.svg'),
        ],
        suitableTransportText:
            'On Foot, Bike, Small Vehicle, Medium Vehicle, Large Vehicle, Public Transport.',
      ),
      shellNavHighlightTabIndex: TripClipShellNavRoutes.tripsTabIndex,
    );
  }

  void _openSortSheet() {
    showTripClipTripsSortSheet(
      context,
      selected: _sort,
      onSelected: (v) {
        setState(() => _sort = v);
        WidgetsBinding.instance.addPostFrameCallback((_) => _loadMarkers());
      },
    );
  }

  Future<void> _openFilterSheet() async {
    final next = await showTripClipTripsFilterSheet(
      context,
      initial: _filter,
      currentSort: _sort,
      surface: TripClipTripsFilterListSurface.mapMarkers,
    );
    if (!mounted || next == null) return;
    setState(() => _filter = next);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMarkers());
  }

  @override
  Widget build(BuildContext context) {
    final sorted = _visibleOffers;
    final center = tripClipMapOffersCenter(sorted);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    TripClipTripsMapOfferPresentation? semiPres;
    if (_selectedOffer != null) {
      semiPres = tripClipTripsMapPresentationFor(_selectedOffer!);
    }

    final markerSelected = _selectedOffer != null;

    return TripClipTripsDrillShell(
      args: widget.args,
      initialSubNavIndex: 1,
      expandBodyBelowHeading: true,
      showViewNavButton: !markerSelected,
      showListNavButton: markerSelected,
      onViewPressed: () => Navigator.of(context).maybePop(),
      onListPressed: _selectedOffer == null
          ? null
          : () => _pushListingForOffer(_selectedOffer!),
      onSortPressed: _openSortSheet,
      onFilterPressed: _openFilterSheet,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: GoogleMap(
              key: ValueKey<int>(_mapViewKey),
              initialCameraPosition: CameraPosition(
                target: sorted.isEmpty ? _fallbackCenter : center,
                zoom: 14,
              ),
              markers: _markers,
              onMapCreated: (c) {
                _mapController = c;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _fitCameraToVisibleOffers();
                });
              },
              onTap: (_) => setState(() => _selectedOffer = null),
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
          if (_selectedOffer != null && semiPres != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16 + bottomInset,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _pushListingForOffer(_selectedOffer!),
                  child: TripClipSemiFeatureCard(
                    image: semiPres.images.first,
                    heading: semiPres.heading,
                    badgeLabel: _selectedOffer!.priceLabel,
                    badgeFlexibleLabel: _selectedOffer!.flexibleLabel,
                    avatarUrl: semiPres.avatarUrl,
                    verified: true,
                    pickupLocation: semiPres.pickupLocation,
                    deliveryLocation: semiPres.deliveryLocation,
                    itemsText: semiPres.itemsText,
                    weightText: semiPres.weightText,
                    footerDateText: semiPres.footerDateText,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
