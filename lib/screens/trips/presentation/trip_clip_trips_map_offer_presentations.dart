import 'package:flutter/material.dart';

import 'sort_filter/trip_clip_trips_sort.dart';

const String kTripClipMapDemoAvatarUrl =
    'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/john-doe.webp';

const String kTripClipMapDemoGuitarUrl =
    'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/guitar.webp';

const String kTripClipMapDemoPumpUrl =
    'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/pump.webp';

class TripClipTripsMapOfferPresentation {
  const TripClipTripsMapOfferPresentation({
    required this.images,
    required this.heading,
    required this.userName,
    required this.ratingText,
    this.avatarUrl = kTripClipMapDemoAvatarUrl,
    required this.pickupLocation,
    required this.pickupDate,
    required this.pickupTime,
    required this.deliveryLocation,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.itemsText,
    required this.weightText,
    required this.footerDateText,
  });

  final List<ImageProvider<Object>> images;
  final String heading;
  final String userName;
  final String ratingText;
  final String? avatarUrl;
  final String pickupLocation;
  final String pickupDate;
  final String pickupTime;
  final String deliveryLocation;
  final String deliveryDate;
  final String deliveryTime;
  final String itemsText;
  final String weightText;
  final String footerDateText;
}

const Map<int, TripClipTripsMapOfferPresentation> _kByMapOfferId = {
  1: TripClipTripsMapOfferPresentation(
    images: [
      NetworkImage(kTripClipMapDemoPumpUrl),
      NetworkImage(kTripClipMapDemoGuitarUrl),
    ],
    heading: 'Spare Ute Parts',
    userName: 'Alex Morgan',
    ratingText: '4.1 (22)',
    pickupLocation: 'Fitzroy VIC',
    pickupDate: 'Today',
    pickupTime: 'Morning',
    deliveryLocation: 'Richmond VIC',
    deliveryDate: 'Tomorrow',
    deliveryTime: '9am–12pm',
    itemsText: '3 Items',
    weightText: '12 kg',
    footerDateText: 'Jan 10, 2026',
  ),
  2: TripClipTripsMapOfferPresentation(
    images: [
      NetworkImage(kTripClipMapDemoGuitarUrl),
    ],
    heading: 'Instrument Case',
    userName: 'Sam Lee',
    ratingText: '3.8 (9)',
    pickupLocation: 'Collingwood VIC',
    pickupDate: 'Today',
    pickupTime: 'Afternoon',
    deliveryLocation: 'Brunswick VIC',
    deliveryDate: 'Feb 2, 2026',
    deliveryTime: 'Flexible',
    itemsText: '1 Item',
    weightText: '4 kg',
    footerDateText: 'Jan 8, 2026',
  ),
  3: TripClipTripsMapOfferPresentation(
    images: [
      NetworkImage(kTripClipMapDemoPumpUrl),
      NetworkImage(kTripClipMapDemoGuitarUrl),
      NetworkImage(kTripClipMapDemoPumpUrl),
    ],
    heading: 'Satchel & Books',
    userName: 'Jordan Kay',
    ratingText: '4.6 (31)',
    pickupLocation: 'Carlton VIC',
    pickupDate: 'Today',
    pickupTime: 'Evening',
    deliveryLocation: 'Parkville VIC',
    deliveryDate: 'Tomorrow',
    deliveryTime: '5pm–8pm',
    itemsText: '2 Items',
    weightText: '7 kg',
    footerDateText: 'Jan 12, 2026',
  ),
  4: TripClipTripsMapOfferPresentation(
    images: [
      NetworkImage(kTripClipMapDemoPumpUrl),
    ],
    heading: 'Warehouse Pallet',
    userName: 'Casey Wu',
    ratingText: '4.9 (48)',
    pickupLocation: 'Melbourne CBD',
    pickupDate: 'Today',
    pickupTime: 'Morning',
    deliveryLocation: 'Docklands VIC',
    deliveryDate: 'Tomorrow',
    deliveryTime: '10am–2pm',
    itemsText: '6 Items',
    weightText: '45 kg',
    footerDateText: 'Jan 11, 2026',
  ),
  5: TripClipTripsMapOfferPresentation(
    images: [
      NetworkImage(kTripClipMapDemoPumpUrl),
      NetworkImage(kTripClipMapDemoGuitarUrl),
      NetworkImage(kTripClipMapDemoPumpUrl),
      NetworkImage(kTripClipMapDemoGuitarUrl),
      NetworkImage(kTripClipMapDemoPumpUrl),
    ],
    heading: 'Ukulele Kit & Vintage Guitar',
    userName: 'John Smith',
    ratingText: '4.8 (8)',
    pickupLocation: 'Fitzroy VIC',
    pickupDate: 'Today',
    pickupTime: 'Afternoon',
    deliveryLocation: 'Ringwood North VIC',
    deliveryDate: 'Tomorrow',
    deliveryTime: 'XXam-XXpm',
    itemsText: '1 Item',
    weightText: 'XX kg',
    footerDateText: 'Jan 14, 2026',
  ),
  6: TripClipTripsMapOfferPresentation(
    images: [NetworkImage(kTripClipMapDemoGuitarUrl)],
    heading: 'Fragile Ceramics',
    userName: 'Riley Chen',
    ratingText: '4.0 (15)',
    pickupLocation: 'Northcote VIC',
    pickupDate: 'Today',
    pickupTime: 'Afternoon',
    deliveryLocation: 'Preston VIC',
    deliveryDate: 'Feb 5, 2026',
    deliveryTime: 'Flexible',
    itemsText: '2 Items',
    weightText: '12 kg',
    footerDateText: 'Jan 9, 2026',
  ),
  7: TripClipTripsMapOfferPresentation(
    images: [
      NetworkImage(kTripClipMapDemoPumpUrl),
      NetworkImage(kTripClipMapDemoGuitarUrl),
    ],
    heading: 'Perishable Box',
    userName: 'Taylor Brooks',
    ratingText: '4.7 (27)',
    pickupLocation: 'Richmond VIC',
    pickupDate: 'Today',
    pickupTime: 'Morning',
    deliveryLocation: 'South Yarra VIC',
    deliveryDate: 'Tomorrow',
    deliveryTime: '12pm–3pm',
    itemsText: '1 Item',
    weightText: '9 kg',
    footerDateText: 'Jan 13, 2026',
  ),
};

TripClipTripsMapOfferPresentation tripClipTripsMapPresentationFor(
  TripClipTripsSortableMapOffer offer,
) {
  final hit = _kByMapOfferId[offer.mapOfferId];
  if (hit != null) return hit;
  return _syntheticPresentation(offer);
}

TripClipTripsMapOfferPresentation _syntheticPresentation(
  TripClipTripsSortableMapOffer offer,
) {
  final title = '${offer.parcelType} · ${offer.areaLabel}';
  final reviews = 10 + offer.clipSortValue * 4;
  return TripClipTripsMapOfferPresentation(
    images: const [NetworkImage(kTripClipMapDemoPumpUrl)],
    heading: title,
    userName: 'TripClip member',
    ratingText:
        '${offer.ratingSortValue.toStringAsFixed(1)} ($reviews)',
    pickupLocation: offer.areaLabel,
    pickupDate: 'Today',
    pickupTime: 'Flexible',
    deliveryLocation: 'Melbourne VIC',
    deliveryDate: 'Tomorrow',
    deliveryTime: 'Flexible',
    itemsText: '1 Item',
    weightText: '${offer.itemWeightKg.toStringAsFixed(0)} kg',
    footerDateText: 'Jan 15, 2026',
  );
}
