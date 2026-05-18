import 'package:flutter/foundation.dart';

import 'trip_clip_parcels_create_models.dart';

class TripClipParcelsCreateController extends ChangeNotifier {
  ParcelsCreateDraft _draft = ParcelsCreateDraft();

  ParcelsCreateDraft get draft => _draft;

  void setTripName(String v) {
    _draft = _copyDraft(tripName: v.trim());
    notifyListeners();
  }

  void setPickup(ParcelsAddressDraft v) {
    _draft = _copyDraft(pickup: v);
    notifyListeners();
  }

  void setDelivery(ParcelsAddressDraft v) {
    _draft = _copyDraft(delivery: v);
    notifyListeners();
  }

  void setRecipient(ParcelsRecipientDraft v) {
    _draft = _copyDraft(recipient: v);
    notifyListeners();
  }

  void setItemCount(int n) {
    final count = n.clamp(1, 999);
    var items = List<ParcelsItemDraft>.from(_draft.items);
    if (items.length < count) {
      items = [
        ...items,
        ...List.generate(count - items.length, (_) => ParcelsItemDraft()),
      ];
    } else if (items.length > count) {
      items = items.sublist(0, count);
    }
    _draft = _copyDraft(itemCount: count, items: items);
    notifyListeners();
  }

  void setItem(int index, ParcelsItemDraft item) {
    final items = List<ParcelsItemDraft>.from(_draft.items);
    while (items.length <= index) {
      items.add(ParcelsItemDraft());
    }
    items[index] = item;
    _draft = _copyDraft(items: items);
    notifyListeners();
  }

  ParcelsItemDraft? itemOrNull(int index) {
    if (index < 0 || index >= _draft.items.length) return null;
    return _draft.items[index];
  }

  void setClip({required int? clipCents, required bool allowAlternative}) {
    _draft = _copyDraft(
      clipCents: clipCents,
      allowAlternativeClip: allowAlternative,
    );
    notifyListeners();
  }

  ParcelsCreateDraft _copyDraft({
    String? tripName,
    ParcelsAddressDraft? pickup,
    ParcelsAddressDraft? delivery,
    ParcelsRecipientDraft? recipient,
    int? itemCount,
    List<ParcelsItemDraft>? items,
    int? clipCents,
    bool? allowAlternativeClip,
  }) {
    return ParcelsCreateDraft(
      tripName: tripName ?? _draft.tripName,
      pickup: pickup ?? _draft.pickup,
      delivery: delivery ?? _draft.delivery,
      recipient: recipient ?? _draft.recipient,
      itemCount: itemCount ?? _draft.itemCount,
      items: items ?? _draft.items,
      clipCents: clipCents ?? _draft.clipCents,
      allowAlternativeClip: allowAlternativeClip ?? _draft.allowAlternativeClip,
    );
  }
}
