import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Resolves [addressLine] to a point for the static demo dataset used by
/// [showTripClipPickupAddressSearchSheet]. Keep keys in sync with that sheet's
/// favourites and search pool strings.
LatLng? tripClipDemoLatLngForAddressLine(String addressLine) {
  final k = _normalizeAddressKey(addressLine);
  if (k.isEmpty) return null;
  return _demoLatLngByKey[k];
}

String _normalizeAddressKey(String raw) =>
    raw.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

/// Approximate coordinates for demo / mock addresses (Victoria, Australia).
final Map<String, LatLng> _demoLatLngByKey = {
  for (final e in _demoAddressLatLngEntries) _normalizeAddressKey(e.$1): e.$2,
};

const _demoAddressLatLngEntries = <(String, LatLng)>[
  ('7 Something Street, St Kilda VIC 3182', LatLng(-37.8679, 144.9782)),
  ('100 Collins Street, Melbourne VIC 3000', LatLng(-37.8152, 144.9660)),
  ('2 Ocean Road, Lorne VIC 3232', LatLng(-38.5362, 143.9724)),
  ('3 Hanover Street, Fitzroy VIC, Australia', LatLng(-37.8006, 144.9784)),
  ('3 Hanover Street, Fitzroy VIC 3065', LatLng(-37.8006, 144.9784)),
  ('120 Spencer Street, Melbourne VIC 3000', LatLng(-37.8182, 144.9530)),
  ('1 Bourke Street, Melbourne VIC 3000', LatLng(-37.8132, 144.9653)),
  ('45 High Street, Prahran VIC 3181', LatLng(-37.8504, 144.9912)),
];
