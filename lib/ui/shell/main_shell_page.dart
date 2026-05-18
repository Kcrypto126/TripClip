import 'package:flutter/material.dart';

import '../../app/navigation/trip_clip_navigator.dart';
import '../../app/theme/trip_clip_colors.dart';
import '../components/trip_clip_bottom_nav_bar.dart';
import '../../screens/account/presentation/account_tab_page.dart';
import '../../screens/activity/presentation/activity_tab_page.dart';
import '../../screens/home/presentation/home_tab_page.dart';
import '../../screens/parcels/presentation/parcels_tab_page.dart';
import '../../screens/trips/presentation/trips_tab_page.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key, this.initialTabIndex = 0})
    : assert(initialTabIndex >= 0 && initialTabIndex <= 4);

  static const int parcelsTabIndex = 2;

  static const int accountTabIndex = 4;

  final int initialTabIndex;

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  final GlobalKey<NavigatorState> _bodyNavKey = GlobalKey<NavigatorState>();
  bool _bodyCanPop = false;
  int? _shellHighlightTabIndex;
  late int _index;

  int? get _bottomNavSelectedIndex {
    if (!_bodyCanPop) return _index;
    return _shellHighlightTabIndex ?? _index;
  }

  @override
  void initState() {
    super.initState();
    _index = widget.initialTabIndex.clamp(0, 4);
  }

  @override
  void didUpdateWidget(covariant MainShellPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTabIndex != widget.initialTabIndex) {
      _index = widget.initialTabIndex.clamp(0, 4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tripClipColors.pageBackground,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Navigator(
          key: _bodyNavKey,
          observers: [
            _BodyNavObserver(
              onShellStackChanged:
                  ({required bool canPop, required int? highlightTabIndex}) {
                if (_bodyCanPop == canPop &&
                    _shellHighlightTabIndex == highlightTabIndex) {
                  return;
                }
                setState(() {
                  _bodyCanPop = canPop;
                  _shellHighlightTabIndex = highlightTabIndex;
                });
              },
            ),
          ],
          onGenerateRoute: (settings) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (context) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _tabBody(),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: TripClipBottomNavBar(
        currentIndex: _index,
        selectedIndex: _bottomNavSelectedIndex,
        onDestinationSelected: (i) {
          _bodyNavKey.currentState?.popUntil((r) => r.isFirst);
          setState(() => _index = i);
        },
        activityBadgeCount: ActivityTabPage.parcelsCount,
      ),
    );
  }

  Widget _tabBody() {
    return switch (_index) {
      0 => const HomeTabPage(key: ValueKey('home')),
      1 => const TripsTabPage(key: ValueKey('trips')),
      2 => const ParcelsTabPage(key: ValueKey('parcels')),
      3 => const ActivityTabPage(key: ValueKey('activity')),
      4 => AccountTabPage(key: const ValueKey('account')),
      _ => const HomeTabPage(key: ValueKey('home')),
    };
  }
}

class _BodyNavObserver extends NavigatorObserver {
  _BodyNavObserver({required this.onShellStackChanged});

  final void Function({required bool canPop, required int? highlightTabIndex})
      onShellStackChanged;

  final List<int?> _shellHighlightStack = [];

  void _emit() {
    final canPop = navigator?.canPop() ?? false;
    final highlightTabIndex =
        _shellHighlightStack.isEmpty ? null : _shellHighlightStack.last;
    onShellStackChanged(
      canPop: canPop,
      highlightTabIndex: highlightTabIndex,
    );
  }

  int? _routeHighlightTabIndex(Route<dynamic> route) =>
      tripClipShellRouteHighlightTabIndex(route.settings.name);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _shellHighlightStack.add(_routeHighlightTabIndex(route));
    _emit();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_shellHighlightStack.isNotEmpty) {
      _shellHighlightStack.removeLast();
    }
    super.didPop(route, previousRoute);
    _emit();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _emit();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (_shellHighlightStack.isNotEmpty) {
      _shellHighlightStack.removeLast();
    }
    if (newRoute != null) {
      _shellHighlightStack.add(_routeHighlightTabIndex(newRoute));
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _emit();
  }
}
