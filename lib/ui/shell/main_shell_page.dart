import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_colors.dart';
import '../../app/theme/trip_clip_palette.dart';
import '../components/trip_clip_home_app_bar.dart';
import '../../screens/account/presentation/account_tab_page.dart';
import '../../screens/activity/presentation/activity_tab_page.dart';
import '../../screens/home/presentation/home_tab_page.dart';
import '../../screens/parcels/presentation/parcels_tab_page.dart';
import '../../screens/trips/presentation/trips_tab_page.dart';

/// Root frame: branded app bar, content, bottom navigation (TripClip spec).
class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _index = 0;

  static const _favorites = 3;
  static const _notifications = 9;
  static const _activity = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tripClipColors.pageBackground,
      appBar: TripClipHomeAppBar(
        favoritesCount: _favorites,
        notificationsCount: _notifications,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _tabBody(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route),
            label: 'Trips',
          ),
          const NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Parcels',
          ),
          NavigationDestination(
            icon: _badgedIcon(
              outline: Icons.assignment_outlined,
              filled: Icons.assignment,
              count: _activity,
            ),
            selectedIcon: _badgedIcon(
              outline: Icons.assignment_outlined,
              filled: Icons.assignment,
              count: _activity,
              selected: true,
            ),
            label: 'Activity',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _tabBody() {
    return switch (_index) {
      0 => const HomeTabPage(key: ValueKey('home')),
      1 => const TripsTabPage(key: ValueKey('trips')),
      2 => const ParcelsTabPage(key: ValueKey('parcels')),
      3 => const ActivityTabPage(key: ValueKey('activity')),
      _ => const AccountTabPage(key: ValueKey('account')),
    };
  }

  static Widget _badgedIcon({
    required IconData outline,
    required IconData filled,
    required int count,
    bool selected = false,
  }) {
    final icon = Icon(selected ? filled : outline);
    if (count <= 0) return icon;

    return Badge(
      label: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      backgroundColor: TripClipPalette.secondary500,
      child: icon,
    );
  }
}
