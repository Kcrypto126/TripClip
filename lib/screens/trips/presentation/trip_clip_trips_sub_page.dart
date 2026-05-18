import 'package:flutter/material.dart';

import '../../../app/navigation/trip_clip_navigator.dart';
import '../../../ui/components/cards/trip_clip_feature_card.dart';
import 'trip_clip_trips_drill_shell.dart';
import 'sort_filter/trip_clip_trips_filter.dart';
import 'sort_filter/trip_clip_trips_filter_sheet.dart';
import 'trip_clip_trips_map_page.dart';
import 'trip_clip_trips_scope_args.dart';
import 'trip_clip_trips_semi_list_page.dart';
import 'sort_filter/trip_clip_trips_sort.dart';
import 'sort_filter/trip_clip_trips_sort_sheet.dart';

class TripClipTripsSubPage extends StatefulWidget {
  const TripClipTripsSubPage({super.key, required this.args});

  final TripClipTripsScopeArgs args;

  @override
  State<TripClipTripsSubPage> createState() => _TripClipTripsSubPageState();
}

class _TripClipTripsSubPageState extends State<TripClipTripsSubPage> {
  static final List<ImageProvider<Object>> _kCardImages = [
    const NetworkImage(
      'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/pump.webp',
    ),
    const NetworkImage(
      'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/guitar.webp',
    ),
    const NetworkImage(
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
      surface: TripClipTripsFilterListSurface.featureCards,
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

  @override
  Widget build(BuildContext context) {
    final sorted = tripClipSortListRows(
      TripClipTripsSortableListRow.featureDefaults,
      _sort,
    );
    final rows = tripClipFilterListRows(sorted, _filter, semi: false);

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
                  if (i != 0) const SizedBox(height: 24),
                  _buildFeatureCard(context, rows[i]),
                ],
              ],
            ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    TripClipTripsSortableListRow row,
  ) {
    final badgeLabel = '\$${row.priceSortValue.toInt()}';
    final badgeFlexible = row.flexibleOffer ? 'Flexible' : null;
    final ratingText =
        '${row.ratingSortValue.toStringAsFixed(1)} (${12 + row.stableId * 3})';

    return TripClipFeatureCard(
      images: _kCardImages,
      heading: 'Heading',
      badgeLabel: badgeLabel,
      badgeFlexibleLabel: badgeFlexible,
      avatarUrl:
          'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/john-doe.webp',
      userName: 'User Name',
      ratingText: ratingText,
      verified: true,
      pickupLocation: 'Suburb XXX XXXX',
      pickupDate: 'Today',
      pickupTime: 'Afternoon',
      deliveryLocation: 'Suburb XXX XXXX',
      deliveryDate: 'Tomorrow',
      deliveryTime: 'XXam-XXpm',
      itemsText: row.stableId == 1 ? '1 Items' : 'X Items',
      weightText: 'XX kg',
      footerDateText: 'Xxx XX, 2026',
      onTap: () {
        tripClipPushMaterialPage<void>(
          context,
          TripClipTripsSemiListPage(args: widget.args),
          shellNavHighlightTabIndex: TripClipShellNavRoutes.tripsTabIndex,
        );
      },
    );
  }
}
