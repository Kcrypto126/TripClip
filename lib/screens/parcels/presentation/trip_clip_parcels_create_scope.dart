import 'package:flutter/material.dart';

import '../../../app/navigation/trip_clip_navigator.dart';
import 'trip_clip_parcels_create_controller.dart';

class TripClipParcelsCreateScope extends InheritedNotifier<TripClipParcelsCreateController> {
  const TripClipParcelsCreateScope({
    super.key,
    required TripClipParcelsCreateController super.notifier,
    required super.child,
  });

  static TripClipParcelsCreateController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<TripClipParcelsCreateScope>();
    assert(scope != null, 'TripClipParcelsCreateScope not found in context');
    return scope!.notifier!;
  }

  static TripClipParcelsCreateController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TripClipParcelsCreateScope>()
        ?.notifier;
  }
}

MaterialPageRoute<T> _parcelsCreateMaterialRoute<T extends Object?>(
  TripClipParcelsCreateController notifier,
  Widget child, {
  RouteSettings? settings,
}) {
  return MaterialPageRoute<T>(
    settings: RouteSettings(
      name: TripClipShellNavRoutes.parcelsTabStack,
      arguments: settings?.arguments,
    ),
    builder: (_) => TripClipParcelsCreateScope(
      notifier: notifier,
      child: child,
    ),
  );
}

Future<T?> pushTripClipParcelsCreateRouteRaw<T extends Object?>(
  BuildContext context,
  Widget child, {
  RouteSettings? settings,
}) {
  final notifier = TripClipParcelsCreateScope.of(context);
  return Navigator.of(context)
      .push<T>(_parcelsCreateMaterialRoute<T>(notifier, child, settings: settings));
}

Future<T?> pushTripClipParcelsCreateRoute<T extends Object?>(
  BuildContext context,
  Widget child, {
  RouteSettings? settings,
}) {
  final notifier = TripClipParcelsCreateScope.of(context);
  return tripClipPushWithPageLoading<T>(
    context,
    () => Navigator.of(context)
        .push<T>(_parcelsCreateMaterialRoute<T>(notifier, child, settings: settings)),
  );
}

class TripClipParcelsCreateScopeHost extends StatefulWidget {
  const TripClipParcelsCreateScopeHost({super.key, required this.child});

  final Widget child;

  @override
  State<TripClipParcelsCreateScopeHost> createState() =>
      _TripClipParcelsCreateScopeHostState();
}

class _TripClipParcelsCreateScopeHostState
    extends State<TripClipParcelsCreateScopeHost> {
  late final TripClipParcelsCreateController _c = TripClipParcelsCreateController();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TripClipParcelsCreateScope(notifier: _c, child: widget.child);
  }
}
