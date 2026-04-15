import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_colors.dart';
import '../components/trip_clip_bottom_nav_bar.dart';
import '../../screens/account/presentation/account_tab_page.dart';
import '../../screens/activity/presentation/activity_tab_page.dart';
import '../../screens/home/presentation/home_tab_page.dart';
import '../../screens/parcels/presentation/parcels_tab_page.dart';
import '../../screens/trips/presentation/trips_tab_page.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _index = 0;
  final GlobalKey<NavigatorState> _bodyNavKey = GlobalKey<NavigatorState>();
  bool _bodyCanPop = false;

  static const _activity = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tripClipColors.pageBackground,
      body: SafeArea(
        top: _index != 0,
        bottom: false,
        child: Navigator(
          key: _bodyNavKey,
          observers: [
            _BodyNavObserver(
              onCanPopChanged: (canPop) {
                if (_bodyCanPop == canPop) return;
                setState(() => _bodyCanPop = canPop);
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
        selectedIndex: _bodyCanPop ? null : _index,
        onDestinationSelected: (i) {
          _bodyNavKey.currentState?.popUntil((r) => r.isFirst);
          setState(() => _index = i);
        },
        activityBadgeCount: _activity,
      ),
    );
  }

  Widget _tabBody() {
    return switch (_index) {
      0 => const HomeTabPage(key: ValueKey('home')),
      1 => const TripsTabPage(key: ValueKey('trips')),
      2 => const ParcelsTabPage(key: ValueKey('parcels')),
      3 => const ActivityTabPage(key: ValueKey('activity')),
      4 => const AccountTabPage(key: ValueKey('account')),
      _ => const HomeTabPage(key: ValueKey('home')),
    };
  }
}

class _BodyNavObserver extends NavigatorObserver {
  _BodyNavObserver({required this.onCanPopChanged});

  final ValueChanged<bool> onCanPopChanged;

  void _emit() => onCanPopChanged(navigator?.canPop() ?? false);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _emit();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
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
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _emit();
  }
}
