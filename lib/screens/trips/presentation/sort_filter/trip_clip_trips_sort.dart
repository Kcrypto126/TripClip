import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';

enum TripClipTripsSortOption {
  bestMatch,
  bestValue,
  highestClip,
  lowestClip,
  flexibleClip,
  soonestDeparture,
  newestTrips,
  oldestTrips,
  highestRatedSenders,
  lowestRatedSenders,
}

class TripClipTripsSortableListRow {
  const TripClipTripsSortableListRow({
    required this.stableId,
    required this.priceSortValue,
    required this.clipSortValue,
    required this.daysUntilDeparture,
    required this.tripAgeDays,
    required this.ratingSortValue,
    required this.flexibleOffer,
  });

  final int stableId;
  final double priceSortValue;
  final int clipSortValue;
  final int daysUntilDeparture;
  final int tripAgeDays;
  final double ratingSortValue;
  final bool flexibleOffer;

  static const List<TripClipTripsSortableListRow> featureDefaults = [
    TripClipTripsSortableListRow(
      stableId: 0,
      priceSortValue: 250,
      clipSortValue: 2,
      daysUntilDeparture: 0,
      tripAgeDays: 3,
      ratingSortValue: 4.9,
      flexibleOffer: true,
    ),
    TripClipTripsSortableListRow(
      stableId: 1,
      priceSortValue: 120,
      clipSortValue: 1,
      daysUntilDeparture: 1,
      tripAgeDays: 10,
      ratingSortValue: 4.2,
      flexibleOffer: false,
    ),
    TripClipTripsSortableListRow(
      stableId: 2,
      priceSortValue: 450,
      clipSortValue: 4,
      daysUntilDeparture: 2,
      tripAgeDays: 1,
      ratingSortValue: 4.7,
      flexibleOffer: false,
    ),
  ];

  static List<TripClipTripsSortableListRow> semiDefaults() => [
        const TripClipTripsSortableListRow(
          stableId: 0,
          priceSortValue: 250,
          clipSortValue: 3,
          daysUntilDeparture: 0,
          tripAgeDays: 2,
          ratingSortValue: 4.8,
          flexibleOffer: true,
        ),
        const TripClipTripsSortableListRow(
          stableId: 1,
          priceSortValue: 90,
          clipSortValue: 1,
          daysUntilDeparture: 3,
          tripAgeDays: 14,
          ratingSortValue: 3.9,
          flexibleOffer: false,
        ),
        const TripClipTripsSortableListRow(
          stableId: 2,
          priceSortValue: 310,
          clipSortValue: 4,
          daysUntilDeparture: 1,
          tripAgeDays: 5,
          ratingSortValue: 4.5,
          flexibleOffer: false,
        ),
        const TripClipTripsSortableListRow(
          stableId: 3,
          priceSortValue: 60,
          clipSortValue: 0,
          daysUntilDeparture: 5,
          tripAgeDays: 30,
          ratingSortValue: 4.0,
          flexibleOffer: false,
        ),
        const TripClipTripsSortableListRow(
          stableId: 4,
          priceSortValue: 500,
          clipSortValue: 5,
          daysUntilDeparture: 0,
          tripAgeDays: 0,
          ratingSortValue: 4.95,
          flexibleOffer: true,
        ),
        const TripClipTripsSortableListRow(
          stableId: 5,
          priceSortValue: 175,
          clipSortValue: 2,
          daysUntilDeparture: 2,
          tripAgeDays: 7,
          ratingSortValue: 4.3,
          flexibleOffer: true,
        ),
        const TripClipTripsSortableListRow(
          stableId: 6,
          priceSortValue: 400,
          clipSortValue: 3,
          daysUntilDeparture: 4,
          tripAgeDays: 20,
          ratingSortValue: 3.5,
          flexibleOffer: false,
        ),
      ];
}

class TripClipTripsSortableMapOffer {
  const TripClipTripsSortableMapOffer({
    required this.mapOfferId,
    required this.priceLabel,
    this.flexibleLabel,
    required this.position,
    required this.priceSortValue,
    required this.clipSortValue,
    required this.daysUntilDeparture,
    required this.tripAgeDays,
    required this.ratingSortValue,
    required this.flexibleOffer,
    required this.areaLabel,
    required this.mockDistanceKm,
    required this.parcelType,
    required this.sizeCode,
    required this.itemWeightKg,
  });

  final int mapOfferId;

  final String priceLabel;
  final String? flexibleLabel;
  final LatLng position;
  final double priceSortValue;
  final int clipSortValue;
  final int daysUntilDeparture;
  final int tripAgeDays;
  final double ratingSortValue;
  final bool flexibleOffer;

  final String areaLabel;
  final double mockDistanceKm;
  final String parcelType;
  final String sizeCode;
  final double itemWeightKg;

  static const List<TripClipTripsSortableMapOffer> defaults = [
    TripClipTripsSortableMapOffer(
      mapOfferId: 1,
      priceLabel: r'$40',
      flexibleLabel: null,
      position: LatLng(-37.7995, 144.976),
      priceSortValue: 40,
      clipSortValue: 1,
      daysUntilDeparture: 2,
      tripAgeDays: 6,
      ratingSortValue: 4.1,
      flexibleOffer: false,
      areaLabel: 'fitzroy vic',
      mockDistanceKm: 7,
      parcelType: 'Box',
      sizeCode: 'SM',
      itemWeightKg: 3,
    ),
    TripClipTripsSortableMapOffer(
      mapOfferId: 2,
      priceLabel: r'$25',
      flexibleLabel: null,
      position: LatLng(-37.7978, 144.979),
      priceSortValue: 25,
      clipSortValue: 0,
      daysUntilDeparture: 4,
      tripAgeDays: 12,
      ratingSortValue: 3.8,
      flexibleOffer: false,
      areaLabel: 'collingwood vic',
      mockDistanceKm: 28,
      parcelType: 'Envelope',
      sizeCode: 'XS',
      itemWeightKg: 1,
    ),
    TripClipTripsSortableMapOffer(
      mapOfferId: 3,
      priceLabel: r'$99',
      flexibleLabel: null,
      position: LatLng(-37.8002, 144.981),
      priceSortValue: 99,
      clipSortValue: 2,
      daysUntilDeparture: 1,
      tripAgeDays: 2,
      ratingSortValue: 4.6,
      flexibleOffer: false,
      areaLabel: 'carlton vic',
      mockDistanceKm: 11,
      parcelType: 'Satchel',
      sizeCode: 'MD',
      itemWeightKg: 7,
    ),
    TripClipTripsSortableMapOffer(
      mapOfferId: 4,
      priceLabel: r'$750',
      flexibleLabel: null,
      position: LatLng(-37.7965, 144.977),
      priceSortValue: 750,
      clipSortValue: 5,
      daysUntilDeparture: 0,
      tripAgeDays: 1,
      ratingSortValue: 4.9,
      flexibleOffer: false,
      areaLabel: 'cbd melbourne',
      mockDistanceKm: 15,
      parcelType: 'Bulky',
      sizeCode: 'XL',
      itemWeightKg: 45,
    ),
    TripClipTripsSortableMapOffer(
      mapOfferId: 5,
      priceLabel: r'$175',
      flexibleLabel: 'Flexible',
      position: LatLng(-37.7980, 144.982),
      priceSortValue: 175,
      clipSortValue: 3,
      daysUntilDeparture: 0,
      tripAgeDays: 4,
      ratingSortValue: 4.4,
      flexibleOffer: true,
      areaLabel: 'fitzroy vic australia',
      mockDistanceKm: 5,
      parcelType: 'Box',
      sizeCode: 'SM',
      itemWeightKg: 21,
    ),
    TripClipTripsSortableMapOffer(
      mapOfferId: 6,
      priceLabel: r'$55',
      flexibleLabel: null,
      position: LatLng(-37.8010, 144.978),
      priceSortValue: 55,
      clipSortValue: 1,
      daysUntilDeparture: 3,
      tripAgeDays: 8,
      ratingSortValue: 4.0,
      flexibleOffer: false,
      areaLabel: 'northcote vic',
      mockDistanceKm: 33,
      parcelType: 'Fragile',
      sizeCode: 'LG',
      itemWeightKg: 12,
    ),
    TripClipTripsSortableMapOffer(
      mapOfferId: 7,
      priceLabel: r'$120',
      flexibleLabel: null,
      position: LatLng(-37.7972, 144.9815),
      priceSortValue: 120,
      clipSortValue: 2,
      daysUntilDeparture: 1,
      tripAgeDays: 0,
      ratingSortValue: 4.7,
      flexibleOffer: false,
      areaLabel: 'richmond vic',
      mockDistanceKm: 20,
      parcelType: 'Perishable',
      sizeCode: 'MD',
      itemWeightKg: 9,
    ),
  ];
}

int _cmpNum(double a, double b, bool ascending) {
  final c = a.compareTo(b);
  return ascending ? c : -c;
}

int _cmpInt(int a, int b, bool ascending) {
  final c = a.compareTo(b);
  return ascending ? c : -c;
}

List<TripClipTripsSortableListRow> tripClipSortListRows(
  List<TripClipTripsSortableListRow> rows,
  TripClipTripsSortOption option,
) {
  final out = [...rows];
  switch (option) {
    case TripClipTripsSortOption.bestMatch:
      out.sort((a, b) => a.stableId.compareTo(b.stableId));
    case TripClipTripsSortOption.bestValue:
      out.sort((a, b) => _cmpNum(a.priceSortValue, b.priceSortValue, true));
    case TripClipTripsSortOption.highestClip:
      out.sort((a, b) => _cmpInt(a.clipSortValue, b.clipSortValue, false));
    case TripClipTripsSortOption.lowestClip:
      out.sort((a, b) => _cmpInt(a.clipSortValue, b.clipSortValue, true));
    case TripClipTripsSortOption.flexibleClip:
      out.sort((a, b) {
        if (a.flexibleOffer != b.flexibleOffer) {
          if (a.flexibleOffer) return -1;
          return 1;
        }
        return _cmpInt(a.clipSortValue, b.clipSortValue, false);
      });
    case TripClipTripsSortOption.soonestDeparture:
      out.sort((a, b) => _cmpInt(a.daysUntilDeparture, b.daysUntilDeparture, true));
    case TripClipTripsSortOption.newestTrips:
      out.sort((a, b) => _cmpInt(a.tripAgeDays, b.tripAgeDays, true));
    case TripClipTripsSortOption.oldestTrips:
      out.sort((a, b) => _cmpInt(a.tripAgeDays, b.tripAgeDays, false));
    case TripClipTripsSortOption.highestRatedSenders:
      out.sort((a, b) => _cmpNum(a.ratingSortValue, b.ratingSortValue, false));
    case TripClipTripsSortOption.lowestRatedSenders:
      out.sort((a, b) => _cmpNum(a.ratingSortValue, b.ratingSortValue, true));
  }
  return out;
}

List<TripClipTripsSortableMapOffer> tripClipSortMapOffers(
  List<TripClipTripsSortableMapOffer> offers,
  TripClipTripsSortOption option,
) {
  final out = [...offers];
  switch (option) {
    case TripClipTripsSortOption.bestMatch:
      out.sort((a, b) {
        final la = a.position.latitude + a.position.longitude;
        final lb = b.position.latitude + b.position.longitude;
        return la.compareTo(lb);
      });
    case TripClipTripsSortOption.bestValue:
      out.sort((a, b) => _cmpNum(a.priceSortValue, b.priceSortValue, true));
    case TripClipTripsSortOption.highestClip:
      out.sort((a, b) => _cmpInt(a.clipSortValue, b.clipSortValue, false));
    case TripClipTripsSortOption.lowestClip:
      out.sort((a, b) => _cmpInt(a.clipSortValue, b.clipSortValue, true));
    case TripClipTripsSortOption.flexibleClip:
      out.sort((a, b) {
        if (a.flexibleOffer != b.flexibleOffer) {
          if (a.flexibleOffer) return -1;
          return 1;
        }
        return _cmpInt(a.clipSortValue, b.clipSortValue, false);
      });
    case TripClipTripsSortOption.soonestDeparture:
      out.sort((a, b) => _cmpInt(a.daysUntilDeparture, b.daysUntilDeparture, true));
    case TripClipTripsSortOption.newestTrips:
      out.sort((a, b) => _cmpInt(a.tripAgeDays, b.tripAgeDays, true));
    case TripClipTripsSortOption.oldestTrips:
      out.sort((a, b) => _cmpInt(a.tripAgeDays, b.tripAgeDays, false));
    case TripClipTripsSortOption.highestRatedSenders:
      out.sort((a, b) => _cmpNum(a.ratingSortValue, b.ratingSortValue, false));
    case TripClipTripsSortOption.lowestRatedSenders:
      out.sort((a, b) => _cmpNum(a.ratingSortValue, b.ratingSortValue, true));
  }
  return out;
}

LatLng tripClipMapOffersCenter(List<TripClipTripsSortableMapOffer> offers) {
  if (offers.isEmpty) return const LatLng(-37.7985, 144.978);
  double lat = 0, lng = 0;
  for (final o in offers) {
    lat += o.position.latitude;
    lng += o.position.longitude;
  }
  final n = offers.length;
  return LatLng(lat / n, lng / n);
}

double tripClipMapOffersZoom(List<TripClipTripsSortableMapOffer> offers) {
  const singleOrCoincidentZoom = 25.0;
  const minZoom = 14.0;
  const maxZoom = 25.0;

  if (offers.length < 2) return singleOrCoincidentZoom;
  double minLat = offers.first.position.latitude;
  double maxLat = minLat;
  double minLng = offers.first.position.longitude;
  double maxLng = minLng;
  for (final o in offers) {
    minLat = math.min(minLat, o.position.latitude);
    maxLat = math.max(maxLat, o.position.latitude);
    minLng = math.min(minLng, o.position.longitude);
    maxLng = math.max(maxLng, o.position.longitude);
  }
  final span = math.max(maxLat - minLat, maxLng - minLng);
  if (span < 1e-4) return singleOrCoincidentZoom;
  final z = 21.0 - (span * 800);
  return z.clamp(minZoom, maxZoom);
}

