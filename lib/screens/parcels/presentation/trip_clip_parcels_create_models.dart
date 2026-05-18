import 'package:flutter/material.dart';

import '../../../ui/sheets/trip_clip_pickup_time_range_sheet.dart';

/// Route [settings.arguments] for "edit from summary" vs forward flow.
class ParcelsCreatePageArgs {
  const ParcelsCreatePageArgs({this.returnToSummary = false});

  final bool returnToSummary;
}

enum ParcelsAddressKind { business, residential }

extension ParcelsAddressKindX on ParcelsAddressKind {
  String get label => switch (this) {
        ParcelsAddressKind.business => 'Business',
        ParcelsAddressKind.residential => 'Residential',
      };

  String get badgeSvgAsset => switch (this) {
        ParcelsAddressKind.business => 'assets/icons/apartment.svg',
        ParcelsAddressKind.residential => 'assets/icons/house.svg',
      };
}

class ParcelsAddressDraft {
  const ParcelsAddressDraft({
    this.kind = ParcelsAddressKind.residential,
    this.searchQuery = '',
    this.manualEntry = false,
    this.line1 = '',
    this.line2 = '',
    this.suburb = '',
    this.postcode = '',
    this.state = 'VIC',
    this.country = 'Australia',
    this.notes = '',
    this.dateOptionIndex = 0,
    this.timeOptionIndex = 0,
    this.dateRange,
    this.timeRange,
  });

  final ParcelsAddressKind kind;
  final String searchQuery;
  final bool manualEntry;
  final String line1;
  final String line2;
  final String suburb;
  final String postcode;
  final String state;
  final String country;
  final String notes;

  final int dateOptionIndex;
  final int timeOptionIndex;
  final DateTimeRange? dateRange;
  final TripClipTimeRange? timeRange;

  static const int kIndexDateRange = 5;
  static const int kIndexTimeRange = 5;

  static const List<String> kDateLabels = [
    'Flexible',
    'Today',
    'Tomorrow',
    'This Week',
    'Next Week',
    'Date Range',
  ];

  static const List<String> kTimeLabels = [
    'Flexible',
    'Morning',
    'Afternoon',
    'Evening',
    'By a time...',
    'Time Range',
  ];

  String displayAddressLine() {
    if (manualEntry) {
      final parts = <String>[];
      if (line1.trim().isNotEmpty) parts.add(line1.trim());
      if (line2.trim().isNotEmpty) parts.add(line2.trim());
      if (suburb.trim().isNotEmpty) parts.add(suburb.trim());
      if (state.trim().isNotEmpty || postcode.trim().isNotEmpty) {
        final sp = <String>[];
        if (state.trim().isNotEmpty) sp.add(state.trim());
        if (postcode.trim().isNotEmpty) sp.add(postcode.trim());
        parts.add(sp.join(' '));
      }
      if (country.trim().isNotEmpty) parts.add(country.trim());
      return parts.join(', ');
    }
    return searchQuery.trim();
  }

  String displayDateLabel() {
    if (dateOptionIndex >= 0 && dateOptionIndex < kDateLabels.length) {
      if (dateOptionIndex == kIndexDateRange) {
        if (dateRange != null) {
          return _formatDateRange(dateRange!);
        }
        return kDateLabels[dateOptionIndex];
      }
      return kDateLabels[dateOptionIndex];
    }
    return '';
  }

  String displayTimeLabel(BuildContext context) {
    if (timeOptionIndex >= 0 && timeOptionIndex < kTimeLabels.length) {
      if (timeOptionIndex == kIndexTimeRange && timeRange != null) {
        return _formatTimeRangeWithLocale(context, timeRange!);
      }
      return kTimeLabels[timeOptionIndex];
    }
    return '';
  }

  static String _formatDateRange(DateTimeRange r) {
    final a = r.start;
    final b = r.end;
    String d(DateTime x) => '${x.day.toString().padLeft(2, '0')}/'
        '${x.month.toString().padLeft(2, '0')}/'
        '${x.year}';
    if (a.year == b.year && a.month == b.month && a.day == b.day) {
      return d(a);
    }
    return '${d(a)} – ${d(b)}';
  }

  static String _formatTimeRangeWithLocale(
    BuildContext context,
    TripClipTimeRange r,
  ) {
    final l = MaterialLocalizations.of(context);
    final is24h = MediaQuery.of(context).alwaysUse24HourFormat;
    final a = l.formatTimeOfDay(r.start, alwaysUse24HourFormat: is24h);
    final b = l.formatTimeOfDay(r.end, alwaysUse24HourFormat: is24h);
    return '$a – $b';
  }

  ParcelsAddressDraft copyWith({
    ParcelsAddressKind? kind,
    String? searchQuery,
    bool? manualEntry,
    String? line1,
    String? line2,
    String? suburb,
    String? postcode,
    String? state,
    String? country,
    String? notes,
    int? dateOptionIndex,
    int? timeOptionIndex,
    DateTimeRange? dateRange,
    TripClipTimeRange? timeRange,
  }) {
    return ParcelsAddressDraft(
      kind: kind ?? this.kind,
      searchQuery: searchQuery ?? this.searchQuery,
      manualEntry: manualEntry ?? this.manualEntry,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      suburb: suburb ?? this.suburb,
      postcode: postcode ?? this.postcode,
      state: state ?? this.state,
      country: country ?? this.country,
      notes: notes ?? this.notes,
      dateOptionIndex: dateOptionIndex ?? this.dateOptionIndex,
      timeOptionIndex: timeOptionIndex ?? this.timeOptionIndex,
      dateRange: dateRange ?? this.dateRange,
      timeRange: timeRange ?? this.timeRange,
    );
  }
}

class ParcelsRecipientDraft {
  const ParcelsRecipientDraft({
    this.name = '',
    this.email = '',
    this.mobile = '',
  });

  final String name;
  final String email;
  final String mobile;
}

/// One parcel item: mirrors item details form.
class ParcelsItemDraft {
  const ParcelsItemDraft({
    this.name = '',
    this.description = '',
    this.imagePaths = const [],
    this.typeSelection = 0,
    this.sizeSelection = 1,
    this.weightSelection = 0,
    this.insuranceSelection = 0,
    this.exactDimensions = '',
    this.exactWeight = '',
    this.confirmNoProhibited = false,
    this.d1 = false,
    this.d2 = false,
    this.d3 = false,
    this.d4 = false,
  });

  final String name;
  final String description;
  final List<String> imagePaths;

  final int typeSelection;
  final int sizeSelection;
  final int weightSelection;
  final int insuranceSelection;

  final String exactDimensions;
  final String exactWeight;

  final bool confirmNoProhibited;
  final bool d1;
  final bool d2;
  final bool d3;
  final bool d4;

  static const List<String> kTypeOptions = [
    'Box',
    'Envelope',
    'Satchel',
    'Fragile',
    'Perishable',
    'Bulky',
  ];
  static const List<String> kSizeOptions = ['XS', 'SM', 'MD', 'LG', 'XL'];
  static const List<String> kWeightOptions = [
    '<3kg',
    '3–10kg',
    '10–20kg',
    '20kg+',
  ];
  static const List<String> kInsuranceOptions = [
    'Basic',
    'Standard',
    'Premium',
  ];

  String typeLabel() => typeSelection < kTypeOptions.length
      ? kTypeOptions[typeSelection]
      : '';
  String sizeLabel() => sizeSelection < kSizeOptions.length
      ? kSizeOptions[sizeSelection]
      : '';
  String weightBandLabel() => weightSelection < kWeightOptions.length
      ? kWeightOptions[weightSelection]
      : '';
  String insuranceShortLabel() {
    if (insuranceSelection == 0) return 'Basic';
    if (insuranceSelection == 1) return 'Standard';
    if (insuranceSelection == 2) return 'Premium';
    return 'Basic';
  }
}

class ParcelsCreateDraft {
  const ParcelsCreateDraft({
    this.tripName = '',
    this.pickup = const ParcelsAddressDraft(),
    this.delivery = const ParcelsAddressDraft(
      kind: ParcelsAddressKind.business,
    ),
    this.recipient = const ParcelsRecipientDraft(),
    this.itemCount = 1,
    this.items = const [],
    this.clipCents,
    this.allowAlternativeClip = false,
  });

  final String tripName;
  final ParcelsAddressDraft pickup;
  final ParcelsAddressDraft delivery;
  final ParcelsRecipientDraft recipient;
  final int itemCount;
  final List<ParcelsItemDraft> items;
  final int? clipCents;
  final bool allowAlternativeClip;

  int? serviceFeeCents(int bps) {
    if (clipCents == null || clipCents! <= 0) return null;
    return (clipCents! * bps / 10000).round();
  }
}
