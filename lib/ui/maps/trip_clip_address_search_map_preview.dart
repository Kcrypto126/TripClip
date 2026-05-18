import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'trip_clip_demo_address_latlng.dart';

/// Embedded map for address flows: centers on the resolved demo location for
/// [addressLine], otherwise a default Melbourne overview.
class TripClipAddressSearchMapPreview extends StatefulWidget {
  const TripClipAddressSearchMapPreview({
    super.key,
    required this.addressLine,
    required this.border,
    required this.fill,
  });

  final String addressLine;
  final Color border;
  final Color fill;

  @override
  State<TripClipAddressSearchMapPreview> createState() =>
      _TripClipAddressSearchMapPreviewState();
}

class _TripClipAddressSearchMapPreviewState
    extends State<TripClipAddressSearchMapPreview> {
  static const LatLng _defaultCenter = LatLng(-37.8136, 144.9631);
  static const double _defaultZoom = 12;
  static const double _pinZoom = 15;

  GoogleMapController? _controller;

  @override
  void didUpdateWidget(covariant TripClipAddressSearchMapPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.addressLine != widget.addressLine) {
      _moveCameraToCurrentAddress(animated: true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController c) {
    _controller = c;
    _moveCameraToCurrentAddress(animated: false);
  }

  void _moveCameraToCurrentAddress({required bool animated}) {
    final c = _controller;
    if (c == null) return;
    final explicit = tripClipDemoLatLngForAddressLine(widget.addressLine);
    final target = explicit ?? _defaultCenter;
    final zoom = explicit != null ? _pinZoom : _defaultZoom;
    final update = CameraUpdate.newCameraPosition(
      CameraPosition(target: target, zoom: zoom),
    );
    if (animated) {
      c.animateCamera(update);
    } else {
      c.moveCamera(update);
    }
  }

  @override
  Widget build(BuildContext context) {
    final explicit = tripClipDemoLatLngForAddressLine(widget.addressLine);
    final cameraTarget = explicit ?? _defaultCenter;
    final zoom = explicit != null ? _pinZoom : _defaultZoom;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: widget.fill,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: widget.border, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: cameraTarget,
          zoom: zoom,
        ),
        onMapCreated: _onMapCreated,
        markers: explicit == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('trip_clip_address_search'),
                  position: explicit,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure,
                  ),
                ),
              },
        compassEnabled: false,
        mapToolbarEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        buildingsEnabled: true,
        trafficEnabled: false,
        indoorViewEnabled: false,
        mapType: MapType.normal,
      ),
    );
  }
}
