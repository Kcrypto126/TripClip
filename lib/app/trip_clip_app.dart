import 'package:flutter/material.dart';

import '../ui/shell/main_shell_page.dart';
import 'theme/trip_clip_theme.dart';

class TripClipApp extends StatefulWidget {
  const TripClipApp({super.key});

  @override
  State<TripClipApp> createState() => _TripClipAppState();
}

class _TripClipAppState extends State<TripClipApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _applyThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return TripClipAppScope(
      themeMode: _themeMode,
      applyThemeMode: _applyThemeMode,
      child: MaterialApp(
        title: 'TripClip',
        theme: TripClipTheme.light(),
        darkTheme: TripClipTheme.dark(),
        themeMode: _themeMode,
        builder: (context, child) {
          final bg = Theme.of(context).scaffoldBackgroundColor;
          return ColoredBox(
            color: bg,
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: const MainShellPage(),
      ),
    );
  }
}

class TripClipAppScope extends InheritedWidget {
  const TripClipAppScope({
    super.key,
    required this.themeMode,
    required this.applyThemeMode,
    required super.child,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> applyThemeMode;

  static TripClipAppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<TripClipAppScope>();
    assert(scope != null, 'TripClipAppScope not found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(TripClipAppScope oldWidget) {
    return oldWidget.themeMode != themeMode;
  }
}
