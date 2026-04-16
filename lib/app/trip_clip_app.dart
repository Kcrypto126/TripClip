import 'package:flutter/material.dart';

import '../screens/loading/presentation/trip_clip_start_loading_page.dart';
import '../ui/shell/main_shell_page.dart';
import 'theme/trip_clip_theme.dart';

class TripClipApp extends StatefulWidget {
  const TripClipApp({super.key});

  @override
  State<TripClipApp> createState() => _TripClipAppState();
}

class _TripClipAppState extends State<TripClipApp> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _showStartLoading = true;

  void _applyThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  void _onStartLoadingFinished() {
    if (!mounted) return;
    setState(() => _showStartLoading = false);
  }

  void _replayStartLoading() {
    if (!mounted) return;
    setState(() => _showStartLoading = true);
  }

  @override
  Widget build(BuildContext context) {
    return TripClipAppScope(
      themeMode: _themeMode,
      applyThemeMode: _applyThemeMode,
      replayStartLoading: _replayStartLoading,
      child: MaterialApp(
        title: 'TripClip',
        theme: TripClipTheme.light(),
        darkTheme: TripClipTheme.dark(),
        themeMode: _themeMode,
        builder: (context, child) {
          final bg = Theme.of(context).scaffoldBackgroundColor;
          return ColoredBox(color: bg, child: child ?? const SizedBox.shrink());
        },
        home: _showStartLoading
            ? TripClipStartLoadingPage(onFinished: _onStartLoadingFinished)
            : const MainShellPage(),
      ),
    );
  }
}

class TripClipAppScope extends InheritedWidget {
  const TripClipAppScope({
    super.key,
    required this.themeMode,
    required this.applyThemeMode,
    required this.replayStartLoading,
    required super.child,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> applyThemeMode;

  /// Shows the boot SVG sequence again, then returns to [MainShellPage].
  final VoidCallback replayStartLoading;

  static TripClipAppScope of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<TripClipAppScope>();
    assert(scope != null, 'TripClipAppScope not found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(TripClipAppScope oldWidget) {
    return oldWidget.themeMode != themeMode ||
        oldWidget.applyThemeMode != applyThemeMode ||
        oldWidget.replayStartLoading != replayStartLoading;
  }
}
