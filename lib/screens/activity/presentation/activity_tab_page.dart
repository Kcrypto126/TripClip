import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../ui/components/badges/trip_clip_badge_status.dart';
import '../../../ui/components/cards/trip_clip_result_card.dart';
import '../../../ui/components/forms/trip_clip_atom_input.dart';

class ActivityTabPage extends StatefulWidget {
  const ActivityTabPage({super.key});

  static const double _bodyPadding = 16;
  static const double _sectionGap = 40;
  static const double _headingToContent = 8;

  static int get parcelsCount =>
      _kActiveParcelData.length + _kPastParcelData.length;

  @override
  State<ActivityTabPage> createState() => _ActivityTabPageState();
}

class _ActivityTabPageState extends State<ActivityTabPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _query => _searchController.text;

  bool get _hasSearchQuery => _query.trim().isNotEmpty;

  List<_ActivityParcelData> get _filteredActive => _kActiveParcelData
      .where((p) => _activityParcelMatches(p, _query))
      .toList();

  List<_ActivityParcelData> get _filteredPast => _kPastParcelData
      .where((p) => _activityParcelMatches(p, _query))
      .toList();

  Widget _buildParcelListColumn(List<_ActivityParcelData> items) {
    if (items.isEmpty) {
      return Text(
        _hasSearchQuery ? 'No matching parcels' : 'No parcels',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.tripClipColors.textSubtle,
            ),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i != 0) const SizedBox(height: 16),
          items[i].toCard(),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerBorder = context.tripClipColors.borderSubtle;
    final headerStyle = Theme.of(context)
        .textTheme
        .headlineLarge!
        .copyWith(color: context.tripClipColors.heading);

    final sectionHeading = Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: context.tripClipColors.textBase,
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
              padding: const EdgeInsets.only(left: ActivityTabPage._bodyPadding),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: headerBorder, width: 1),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Text('Activity', style: headerStyle),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                ActivityTabPage._bodyPadding,
                ActivityTabPage._bodyPadding,
                ActivityTabPage._bodyPadding,
                0,
              ),
              child: TripClipAtomInput(
                controller: _searchController,
                hintText: 'Search Activity',
                showTrailing: false,
                showLeading: true,
                leadingIconAsset: 'assets/icons/search.svg',
                textInputAction: TextInputAction.search,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  ActivityTabPage._bodyPadding,
                  ActivityTabPage._sectionGap,
                  ActivityTabPage._bodyPadding,
                  16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Section(
                      heading: 'Clips Earned',
                      headingStyle: sectionHeading,
                      child: const _ClipsEarnedCard(
                        pendingCents: 25000,
                        earnedCents: 62500,
                      ),
                    ),
                    const SizedBox(height: ActivityTabPage._sectionGap),
                    _Section(
                      heading: 'Active Parcels',
                      headingStyle: sectionHeading,
                      child: _buildParcelListColumn(_filteredActive),
                    ),
                    const SizedBox(height: ActivityTabPage._sectionGap),
                    _Section(
                      heading: 'Past Parcels',
                      headingStyle: sectionHeading,
                      child: _buildParcelListColumn(_filteredPast),
                    ),
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

bool _activityParcelMatches(_ActivityParcelData p, String rawQuery) {
  final q = rawQuery.trim().toLowerCase();
  if (q.isEmpty) return true;

  final badgeLower = p.badgeLabel.toLowerCase();
  final digitsOnly = p.badgeLabel.replaceAll(RegExp(r'[^\d]'), '');

  final haystack = [
    p.statusLabel,
    p.heading,
    p.pickupLocation,
    p.deliveryLocation,
    badgeLower,
    if (digitsOnly.isNotEmpty) digitsOnly,
  ].join(' ').toLowerCase();

  return haystack.contains(q);
}

class _Section extends StatelessWidget {
  const _Section({
    required this.heading,
    required this.headingStyle,
    required this.child,
  });

  final String heading;
  final TextStyle headingStyle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(heading, style: headingStyle),
        const SizedBox(height: ActivityTabPage._headingToContent),
        child,
      ],
    );
  }
}

class _ClipsEarnedCard extends StatelessWidget {
  const _ClipsEarnedCard({
    required this.pendingCents,
    required this.earnedCents,
  });

  final int pendingCents;
  final int earnedCents;

  static String _formatDollars(int cents) => '\$${(cents ~/ 100).toString()}';

  @override
  Widget build(BuildContext context) {
    final bg = context.tripClipColors.heading;
    final light = Theme.of(context).brightness == Brightness.light;
    const dividerLight = Color(0xFFDCE1E6);
    const dividerDark = Color(0xFF2E343D);
    final dividerColor = light ? dividerLight : dividerDark;

    final t = Theme.of(context).textTheme;
    final typeStyle = t.bodyMedium!.copyWith(color: Colors.white);
    final valueStyle =
        t.bodyLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.w600);

    final total = pendingCents + earnedCents;

    Widget line(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(child: Text(label, style: typeStyle)),
            Text(value, style: valueStyle),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          line('Pending Clips', _formatDollars(pendingCents)),
          Container(height: 1, color: dividerColor),
          line('Clips Earned', _formatDollars(earnedCents)),
          Container(height: 1, color: dividerColor),
          line('Total Clips', _formatDollars(total)),
          Container(height: 1, color: dividerColor),
        ],
      ),
    );
  }
}

class _ActivityParcelData {
  const _ActivityParcelData({
    required this.statusLabel,
    required this.statusTone,
    required this.progress,
    required this.heading,
    required this.badgeLabel,
    required this.pickupLocation,
    required this.deliveryLocation,
  });

  final String statusLabel;
  final TripClipBadgeStatusTone statusTone;
  final double progress;
  final String heading;
  final String badgeLabel;
  final String pickupLocation;
  final String deliveryLocation;

  TripClipResultCard toCard() {
    return TripClipResultCard(
      statusLabel: statusLabel,
      statusTone: statusTone,
      progress: progress,
      heading: heading,
      badgeLabel: badgeLabel,
      pickupLocation: pickupLocation,
      deliveryLocation: deliveryLocation,
      itemsText: ' ',
      weightText: ' ',
      footerDateText: ' ',
      showMetaFooter: false,
    );
  }
}

const List<_ActivityParcelData> _kActiveParcelData = [
  _ActivityParcelData(
    statusLabel: 'Pickup Failed',
    statusTone: TripClipBadgeStatusTone.danger,
    progress: 0.35,
    heading: 'Ukulele Kit & Vintage Guitar',
    badgeLabel: r'$xxx',
    pickupLocation: 'Suburb XXX XXXX',
    deliveryLocation: 'Suburb XXX XXXX',
  ),
  _ActivityParcelData(
    statusLabel: 'Awaiting Collection',
    statusTone: TripClipBadgeStatusTone.warning,
    progress: 1.0,
    heading: 'Heading',
    badgeLabel: r'$xxx',
    pickupLocation: 'Suburb XXX XXXX',
    deliveryLocation: 'Suburb XXX XXXX',
  ),
];

const List<_ActivityParcelData> _kPastParcelData = [
  _ActivityParcelData(
    statusLabel: 'Delivered',
    statusTone: TripClipBadgeStatusTone.success,
    progress: 1.0,
    heading: 'Garden Supplies',
    badgeLabel: r'$900',
    pickupLocation: 'Richmond VIC 3121',
    deliveryLocation: 'Ringwood VIC 3134',
  ),
  _ActivityParcelData(
    statusLabel: 'Delivered',
    statusTone: TripClipBadgeStatusTone.success,
    progress: 1.0,
    heading: 'Drum Kit and Keyboards',
    badgeLabel: r'$75',
    pickupLocation: 'Richmond VIC 3121',
    deliveryLocation: 'Melbourne VIC 3000',
  ),
  _ActivityParcelData(
    statusLabel: 'Delivered',
    statusTone: TripClipBadgeStatusTone.success,
    progress: 1.0,
    heading: 'Car Parts',
    badgeLabel: r'$1000',
    pickupLocation: 'Fitzroy VIC 3065',
    deliveryLocation: 'Sydney NSW 2000',
  ),
  _ActivityParcelData(
    statusLabel: 'Delivered',
    statusTone: TripClipBadgeStatusTone.success,
    progress: 1.0,
    heading:
        'Long name goes here that goes over three lines so we can see how it looks',
    badgeLabel: r'$45',
    pickupLocation: 'Surfers Paradise QLD',
    deliveryLocation: 'Brisbane QLD 4000',
  ),
  _ActivityParcelData(
    statusLabel: 'Cancelled',
    statusTone: TripClipBadgeStatusTone.neutral,
    progress: 0.0,
    heading: 'Short name',
    badgeLabel: r'$xxx',
    pickupLocation: 'Surfers Paradise QLD',
    deliveryLocation: 'Brisbane QLD 4000',
  ),
];
