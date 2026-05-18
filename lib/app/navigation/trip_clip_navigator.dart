import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../ui/components/trip_clip_page_loading.dart';

const bool _pageTransferLoadingEnabled = false;

abstract final class TripClipShellNavRoutes {
  static const String tripsTabStack = 'tripclip.shell.trips';
  static const String parcelsTabStack = 'tripclip.shell.parcels';
  static const String accountTabStack = 'tripclip.shell.account';

  static const int tripsTabIndex = 1;
  static const int parcelsTabIndex = 2;
  static const int accountTabIndex = 4;
}

String? tripClipShellNavRouteNameForTabIndex(int tabIndex) {
  return switch (tabIndex) {
    TripClipShellNavRoutes.tripsTabIndex => TripClipShellNavRoutes.tripsTabStack,
    TripClipShellNavRoutes.parcelsTabIndex =>
      TripClipShellNavRoutes.parcelsTabStack,
    TripClipShellNavRoutes.accountTabIndex =>
      TripClipShellNavRoutes.accountTabStack,
    _ => null,
  };
}

int? tripClipShellRouteHighlightTabIndex(String? routeName) {
  if (routeName == TripClipShellNavRoutes.tripsTabStack) {
    return TripClipShellNavRoutes.tripsTabIndex;
  }
  if (routeName == TripClipShellNavRoutes.parcelsTabStack) {
    return TripClipShellNavRoutes.parcelsTabIndex;
  }
  if (routeName == TripClipShellNavRoutes.accountTabStack) {
    return TripClipShellNavRoutes.accountTabIndex;
  }
  return null;
}

Future<T?> tripClipPushWithPageLoading<T extends Object?>(
  BuildContext context,
  Future<T?> Function() push, {
  bool useLoading = true,
}) async {
  if (!_pageTransferLoadingEnabled || !useLoading) {
    return push();
  }
  if (!context.mounted) {
    return null;
  }
  showTripClipPageLoading(context);
  try {
    await SchedulerBinding.instance.endOfFrame;
    if (!context.mounted) {
      tryDismissTripClipPageLoading();
      return null;
    }
    final future = push();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tryDismissTripClipPageLoading();
    });
    return future;
  } catch (e) {
    tryDismissTripClipPageLoading();
    rethrow;
  }
}

Future<T?> tripClipPushMaterialPage<T extends Object?>(
  BuildContext context,
  Widget child, {
  RouteSettings? settings,
  bool useLoading = true,

  int? shellNavHighlightTabIndex,
}) {
  final RouteSettings effectiveSettings;
  if (shellNavHighlightTabIndex != null) {
    final name = tripClipShellNavRouteNameForTabIndex(shellNavHighlightTabIndex);
    assert(
      name != null,
      'shellNavHighlightTabIndex must be 1 (Trips), 2 (Parcels), or 4 (Account)',
    );
    effectiveSettings = RouteSettings(
      name: name,
      arguments: settings?.arguments,
    );
  } else {
    effectiveSettings = settings ?? const RouteSettings();
  }

  return tripClipPushWithPageLoading<T>(
    context,
    () => Navigator.of(context).push<T>(
      MaterialPageRoute<T>(
        settings: effectiveSettings,
        builder: (_) => child,
      ),
    ),
    useLoading: useLoading,
  );
}
