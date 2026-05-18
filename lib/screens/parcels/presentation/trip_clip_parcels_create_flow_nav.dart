import 'package:flutter/material.dart';

import 'trip_clip_parcels_create_delivery_page.dart';
import 'trip_clip_parcels_create_items_page.dart';
import 'trip_clip_parcels_create_models.dart';
import 'trip_clip_parcels_create_pickup_page.dart';
import 'trip_clip_parcels_create_recipient_page.dart';
import 'trip_clip_parcels_create_scope.dart';
import 'trip_clip_parcels_create_trip_name_page.dart';
import 'trip_clip_parcels_item_details_form.dart';
import 'trip_clip_parcels_item_details_page.dart';

/// What to edit from the create summary. Use [itemIndex] only for [item].
enum ParcelsCreateFromSummary {
  tripName,
  pickup,
  delivery,
  recipient,
  items,
  item,
}

/// Pushes a create flow step with return-to-summary behavior. Avoids a
/// summary ↔ clip import cycle.
void pushParcelsCreateEditFromSummary(
  BuildContext context,
  ParcelsCreateFromSummary which, {
  int itemIndex = 0,
}) {
  const args = ParcelsCreatePageArgs(returnToSummary: true);
  final settings = const RouteSettings(arguments: args);

  switch (which) {
    case ParcelsCreateFromSummary.tripName:
      pushTripClipParcelsCreateRoute<void>(
        context,
        const TripClipParcelsCreateTripNamePage(),
        settings: settings,
      );
    case ParcelsCreateFromSummary.pickup:
      pushTripClipParcelsCreateRoute<void>(
        context,
        const TripClipParcelsCreatePickupPage(),
        settings: settings,
      );
    case ParcelsCreateFromSummary.delivery:
      pushTripClipParcelsCreateRoute<void>(
        context,
        const TripClipParcelsCreateDeliveryPage(),
        settings: settings,
      );
    case ParcelsCreateFromSummary.recipient:
      pushTripClipParcelsCreateRoute<void>(
        context,
        const TripClipParcelsCreateRecipientPage(),
        settings: settings,
      );
    case ParcelsCreateFromSummary.items:
      pushTripClipParcelsCreateRoute<void>(
        context,
        const TripClipParcelsCreateItemsPage(),
        settings: settings,
      );
    case ParcelsCreateFromSummary.item:
      final scope = TripClipParcelsCreateScope.of(context);
      final total = scope.draft.itemCount;
      if (total <= 0) return;
      final safe = itemIndex.clamp(0, total - 1);
      pushTripClipParcelsCreateRoute<void>(
        context,
        TripClipParcelsItemDetailsPage(
          itemIndex: safe,
          totalItems: total,
          controllers: TripClipParcelsItemDetailsControllers.fromDraft(
            scope.itemOrNull(safe),
          ),
        ),
        settings: settings,
      );
  }
}
