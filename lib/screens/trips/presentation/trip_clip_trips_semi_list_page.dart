import 'package:flutter/material.dart';

import '../../../app/navigation/trip_clip_navigator.dart';
import '../../../ui/components/cards/trip_clip_semi_feature_card.dart';
import 'trip_clip_listing_page.dart';
import 'trip_clip_trips_drill_shell.dart';
import 'sort_filter/trip_clip_trips_filter.dart';
import 'sort_filter/trip_clip_trips_filter_sheet.dart';
import 'trip_clip_trips_map_page.dart';
import 'trip_clip_trips_scope_args.dart';
import 'sort_filter/trip_clip_trips_sort.dart';
import 'sort_filter/trip_clip_trips_sort_sheet.dart';

class TripClipTripsSemiListPage extends StatefulWidget {
  const TripClipTripsSemiListPage({super.key, required this.args});

  final TripClipTripsScopeArgs args;

  @override
  State<TripClipTripsSemiListPage> createState() =>
      _TripClipTripsSemiListPageState();
}

class _TripClipTripsSemiListPageState extends State<TripClipTripsSemiListPage> {
  static const String _kAvatarUrl =
      'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/john-doe.webp';

  static const List<ImageProvider<Object>> _kImages = [
    NetworkImage(
      'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/pump.webp',
    ),
    NetworkImage(
      'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/guitar.webp',
    ),
    NetworkImage(
      'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/pump.webp',
    ),
    NetworkImage(
      'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/guitar.webp',
    ),
    NetworkImage(
      'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/pump.webp',
    ),
    NetworkImage(
      'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/guitar.webp',
    ),
    NetworkImage(
      'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/pump.webp',
    ),
  ];

  TripClipTripsSortOption _sort = TripClipTripsSortOption.bestMatch;
  TripClipTripsFilterCriteria _filter = TripClipTripsFilterCriteria.cleared();

  Future<void> _openFilterSheet() async {
    final next = await showTripClipTripsFilterSheet(
      context,
      initial: _filter,
      currentSort: _sort,
      surface: TripClipTripsFilterListSurface.semiCards,
    );
    if (!mounted || next == null) return;
    setState(() => _filter = next);
  }

  void _openSortSheet() {
    showTripClipTripsSortSheet(
      context,
      selected: _sort,
      onSelected: (v) => setState(() => _sort = v),
    );
  }

  void _openListingForRow(TripClipTripsSortableListRow row) {
    final badgeLabel = '\$${row.priceSortValue.toInt()}';
    final badgeFlexible = row.flexibleOffer ? 'Flexible' : null;
    final gallery = _kImages.take(3).toList();
    final heroHeading = 'Trip ${row.stableId + 1}';
    final ratingText =
        '${row.ratingSortValue.toStringAsFixed(1)} (${12 + row.stableId * 3})';
    final itemsText = row.stableId == 1 ? '1 Items' : 'X Items';
    final img = _kImages[row.stableId % _kImages.length];

    tripClipPushMaterialPage<void>(
      context,
      TripClipListingPageComponent(
        images: gallery,
        heading: heroHeading,
        badgeLabel: badgeLabel,
        badgeFlexibleLabel: badgeFlexible,
        avatarUrl: _kAvatarUrl,
        userName: 'John Smith',
        ratingText: ratingText,
        verified: true,
        itemsText: itemsText,
        weightText: 'XX kg',
        dateText: 'February 3, 2026',
        pickupBadgeLabel: 'Residential',
        pickupAddress: 'Fitzroy VIC Australia',
        pickupDateLabel: 'Pickup Date',
        pickupTimeLabel: 'Pickup Time',
        pickupDateValue: 'Flexible',
        pickupTimeValue: 'Flexible',
        deliveryBadgeLabel: 'Business',
        deliveryAddress: 'Ringwood North VIC Australia',
        deliveryDateLabel: 'Delivery Date',
        deliveryTimeLabel: 'Delivery Time',
        deliveryDateValue: 'Flexible',
        deliveryTimeValue: 'Between 9am–5pm',
        parcels: [
          TripClipListingParcelModel(
            indexLabel: '1',
            title: heroHeading,
            images: [img],
            description:
                'Packed for delivery from $itemsText — confirm dimensions before pickup.',
            typeLabel: 'Box',
            sizeDimensions: '25cm W x 10cm H x 5cm D',
            weightLabel: '2.5kg',
            insuranceLabel: 'Basic',
          ),
        ],
        transportBadges: const [
          (label: 'On Foot', svgAsset: 'assets/icons/walk.svg'),
          (label: 'Bike', svgAsset: 'assets/icons/bike.svg'),
          (label: 'Car', svgAsset: 'assets/icons/car.svg'),
          (label: 'Ute', svgAsset: 'assets/icons/ute.svg'),
          (label: 'Truck', svgAsset: 'assets/icons/truck.svg'),
        ],
        suitableTransportText:
            'On Foot, Bike, Small Vehicle, Medium Vehicle, Large Vehicle, Public Transport.',
      ),
      shellNavHighlightTabIndex: TripClipShellNavRoutes.tripsTabIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sorted = tripClipSortListRows(
      TripClipTripsSortableListRow.semiDefaults(),
      _sort,
    );
    final rows = tripClipFilterListRows(sorted, _filter, semi: true);

    return TripClipTripsDrillShell(
      args: widget.args,
      showListNavButton: false,
      onMapPressed: () {
        tripClipPushMaterialPage<void>(
          context,
          TripClipTripsMapPage(args: widget.args),
          shellNavHighlightTabIndex: TripClipShellNavRoutes.tripsTabIndex,
        );
      },
      onSortPressed: _openSortSheet,
      onFilterPressed: _openFilterSheet,
      body: rows.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'No trips match your filters.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < rows.length; i++) ...[
                  if (i != 0) const SizedBox(height: 16),
                  _semiCard(rows[i]),
                ],
              ],
            ),
    );
  }

  Widget _semiCard(TripClipTripsSortableListRow row) {
    final badgeLabel = '\$${row.priceSortValue.toInt()}';
    final badgeFlexible = row.flexibleOffer ? 'Flexible' : null;
    final heading = 'Trip ${row.stableId + 1}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openListingForRow(row),
        borderRadius: BorderRadius.circular(12),
        child: TripClipSemiFeatureCard(
          image: _kImages[row.stableId % _kImages.length],
          heading: heading,
          badgeLabel: badgeLabel,
          badgeFlexibleLabel: badgeFlexible,
          avatarUrl: _kAvatarUrl,
          verified: true,
          pickupLocation: 'Suburb XXX XXXX',
          deliveryLocation: 'Suburb XXX XXXX',
          itemsText: row.stableId == 1 ? '1 Items' : 'X Items',
          weightText: 'XX kg',
          footerDateText: 'Xxx XX, 2026',
        ),
      ),
    );
  }
}
