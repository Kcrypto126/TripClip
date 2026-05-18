import 'package:flutter/foundation.dart';

import 'trip_clip_trips_sort.dart';

@immutable
class TripClipTripsFilterCriteria {
  const TripClipTripsFilterCriteria({
    required this.locationText,
    required this.maxDistanceKm,
    required this.clipMaxAud,
    required this.parcelType,
    required this.sizeCode,
    required this.weightBand,
    required this.maxWeightKg,
  });

  final String locationText;
  final double maxDistanceKm;
  final double clipMaxAud;
  final String parcelType;
  final String sizeCode;
  final String weightBand;
  final double maxWeightKg;

  static TripClipTripsFilterCriteria initial() =>
      const TripClipTripsFilterCriteria(
        locationText: 'Fitzroy VIC Australia',
        maxDistanceKm: 50,
        clipMaxAud: 50,
        parcelType: 'Box',
        sizeCode: 'SM',
        weightBand: '20kg+',
        maxWeightKg: 1000,
      );

  static TripClipTripsFilterCriteria cleared() =>
      const TripClipTripsFilterCriteria(
        locationText: '',
        maxDistanceKm: 50,
        clipMaxAud: 50,
        parcelType: '',
        sizeCode: '',
        weightBand: '',
        maxWeightKg: 1000,
      );

  TripClipTripsFilterCriteria copyWith({
    String? locationText,
    double? maxDistanceKm,
    double? clipMaxAud,
    String? parcelType,
    String? sizeCode,
    String? weightBand,
    double? maxWeightKg,
  }) {
    return TripClipTripsFilterCriteria(
      locationText: locationText ?? this.locationText,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      clipMaxAud: clipMaxAud ?? this.clipMaxAud,
      parcelType: parcelType ?? this.parcelType,
      sizeCode: sizeCode ?? this.sizeCode,
      weightBand: weightBand ?? this.weightBand,
      maxWeightKg: maxWeightKg ?? this.maxWeightKg,
    );
  }
}

typedef _ListTraits = ({
  double distanceKm,
  String areaLabel,
  String parcelType,
  String sizeCode,
  double itemKg,
});

_ListTraits _traitsFeature(TripClipTripsSortableListRow r) {
  return switch (r.stableId) {
    0 => (
        distanceKm: 6,
        areaLabel: 'fitzroy vic australia',
        parcelType: 'Box',
        sizeCode: 'SM',
        itemKg: 2.5,
      ),
    1 => (
        distanceKm: 18,
        areaLabel: 'richmond vic',
        parcelType: 'Envelope',
        sizeCode: 'MD',
        itemKg: 5,
      ),
    2 => (
        distanceKm: 42,
        areaLabel: 'dandenong vic',
        parcelType: 'Bulky',
        sizeCode: 'LG',
        itemKg: 22,
      ),
    _ => (
        distanceKm: 20,
        areaLabel: 'melbourne vic',
        parcelType: 'Box',
        sizeCode: 'MD',
        itemKg: 8,
      ),
  };
}

_ListTraits _traitsSemi(TripClipTripsSortableListRow r) {
  return switch (r.stableId) {
    0 => (
        distanceKm: 4,
        areaLabel: 'fitzroy vic',
        parcelType: 'Box',
        sizeCode: 'SM',
        itemKg: 1.5,
      ),
    1 => (
        distanceKm: 30,
        areaLabel: 'carlton vic',
        parcelType: 'Envelope',
        sizeCode: 'XS',
        itemKg: 2,
      ),
    2 => (
        distanceKm: 12,
        areaLabel: 'collingwood vic',
        parcelType: 'Satchel',
        sizeCode: 'MD',
        itemKg: 6,
      ),
    3 => (
        distanceKm: 48,
        areaLabel: 'werribee vic',
        parcelType: 'Fragile',
        sizeCode: 'LG',
        itemKg: 15,
      ),
    4 => (
        distanceKm: 8,
        areaLabel: 'fitzroy vic australia',
        parcelType: 'Box',
        sizeCode: 'XL',
        itemKg: 24,
      ),
    5 => (
        distanceKm: 22,
        areaLabel: 'prahran vic',
        parcelType: 'Perishable',
        sizeCode: 'SM',
        itemKg: 4,
      ),
    6 => (
        distanceKm: 35,
        areaLabel: 'st kilda vic',
        parcelType: 'Bulky',
        sizeCode: 'MD',
        itemKg: 18,
      ),
    _ => (
        distanceKm: 20,
        areaLabel: 'melbourne',
        parcelType: 'Box',
        sizeCode: 'MD',
        itemKg: 10,
      ),
  };
}

double tripClipFilterClipCapUsd(TripClipTripsFilterCriteria c) {
  return 30 + (c.clipMaxAud - 1) * (1500 - 30) / 49;
}

bool _weightBandContainsKg(String band, double kg) {
  return switch (band) {
    '<3kg' => kg < 3,
    '3-10kg' => kg >= 3 && kg < 10,
    '10-20kg' => kg >= 10 && kg < 20,
    '20kg+' => kg >= 20,
    _ => true,
  };
}

bool tripClipListRowMatchesFilter(
  TripClipTripsSortableListRow row,
  TripClipTripsFilterCriteria c, {
  required bool semi,
}) {
  final t = semi ? _traitsSemi(row) : _traitsFeature(row);
  final q = c.locationText.trim().toLowerCase();
  if (q.isNotEmpty && !t.areaLabel.contains(q)) {
    return false;
  }
  if (t.distanceKm > c.maxDistanceKm) return false;
  if (row.priceSortValue > tripClipFilterClipCapUsd(c)) return false;
  if (c.parcelType.isNotEmpty && t.parcelType != c.parcelType) return false;
  if (c.sizeCode.isNotEmpty && t.sizeCode != c.sizeCode) return false;
  if (c.weightBand.isNotEmpty &&
      !_weightBandContainsKg(c.weightBand, t.itemKg)) {
    return false;
  }
  if (t.itemKg > c.maxWeightKg) return false;
  return true;
}

bool tripClipMapOfferMatchesFilter(
  TripClipTripsSortableMapOffer o,
  TripClipTripsFilterCriteria c,
) {
  final q = c.locationText.trim().toLowerCase();
  if (q.isNotEmpty && !o.areaLabel.contains(q)) return false;
  if (o.mockDistanceKm > c.maxDistanceKm) return false;
  if (o.priceSortValue > tripClipFilterClipCapUsd(c)) return false;
  if (c.parcelType.isNotEmpty && o.parcelType != c.parcelType) return false;
  if (c.sizeCode.isNotEmpty && o.sizeCode != c.sizeCode) return false;
  if (c.weightBand.isNotEmpty &&
      !_weightBandContainsKg(c.weightBand, o.itemWeightKg)) {
    return false;
  }
  if (o.itemWeightKg > c.maxWeightKg) return false;
  return true;
}

List<TripClipTripsSortableListRow> tripClipFilterListRows(
  List<TripClipTripsSortableListRow> sorted,
  TripClipTripsFilterCriteria c, {
  required bool semi,
}) {
  return sorted.where((r) => tripClipListRowMatchesFilter(r, c, semi: semi)).toList();
}

List<TripClipTripsSortableMapOffer> tripClipFilterMapOffers(
  List<TripClipTripsSortableMapOffer> sorted,
  TripClipTripsFilterCriteria c,
) {
  return sorted.where((o) => tripClipMapOfferMatchesFilter(o, c)).toList();
}

int tripClipCountMatchingList(
  TripClipTripsSortOption sort,
  TripClipTripsFilterCriteria c, {
  required bool semi,
}) {
  final seed = semi
      ? TripClipTripsSortableListRow.semiDefaults()
      : TripClipTripsSortableListRow.featureDefaults;
  final sorted = tripClipSortListRows(seed, sort);
  return tripClipFilterListRows(sorted, c, semi: semi).length;
}

int tripClipCountMatchingMap(
  TripClipTripsSortOption sort,
  TripClipTripsFilterCriteria c,
) {
  final sorted = tripClipSortMapOffers(TripClipTripsSortableMapOffer.defaults, sort);
  return tripClipFilterMapOffers(sorted, c).length;
}

