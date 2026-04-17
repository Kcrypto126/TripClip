import 'package:flutter/material.dart';

import '../screens/loading/presentation/trip_clip_start_loading_page.dart';
import '../screens/login/presentation/trip_clip_login_page.dart';
import '../screens/onboarding/presentation/trip_clip_onboarding_splash_page.dart';
import '../screens/welcome/presentation/trip_clip_welcome_splash_page.dart';
import '../ui/shell/main_shell_page.dart';
import 'theme/trip_clip_theme.dart';

class TripClipApp extends StatefulWidget {
  const TripClipApp({super.key});

  @override
  State<TripClipApp> createState() => _TripClipAppState();
}

enum _BootPhase { loading, welcome, onboarding, login, shell }

class _TripClipAppState extends State<TripClipApp> {
  ThemeMode _themeMode = ThemeMode.system;
  _BootPhase _bootPhase = _BootPhase.loading;
  bool _isLoggedIn = false;

  void _applyThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  void _onStartLoadingFinished() {
    if (!mounted) return;
    setState(() => _bootPhase = _BootPhase.welcome);
  }

  void _onWelcomeContinue() {
    if (!mounted) return;
    setState(() => _bootPhase = _BootPhase.onboarding);
  }

  void _onOnboardingComplete() {
    if (!mounted) return;
    setState(() => _bootPhase = _BootPhase.login);
  }

  void _onOnboardingBackToWelcome() {
    if (!mounted) return;
    setState(() => _bootPhase = _BootPhase.welcome);
  }

  void _replayStartLoading() {
    if (!mounted) return;
    setState(() => _bootPhase = _BootPhase.loading);
  }

  void _setLoggedIn(bool value) {
    if (!mounted) return;
    setState(() => _isLoggedIn = value);
  }

  @override
  Widget build(BuildContext context) {
    return TripClipAppScope(
      themeMode: _themeMode,
      applyThemeMode: _applyThemeMode,
      replayStartLoading: _replayStartLoading,
      isLoggedIn: _isLoggedIn,
      setLoggedIn: _setLoggedIn,
      goToMainShell: () {
        if (!mounted) return;
        setState(() {
          _isLoggedIn = true;
          _bootPhase = _BootPhase.shell;
        });
      },
      child: MaterialApp(
        // New phase must reset the root navigator so pushed routes (e.g. create
        // account) are not left above [MainShellPage].
        key: ValueKey(_bootPhase),
        title: 'TripClip',
        theme: TripClipTheme.light(),
        darkTheme: TripClipTheme.dark(),
        themeMode: _themeMode,
        builder: (context, child) {
          final bg = Theme.of(context).scaffoldBackgroundColor;
          return ColoredBox(color: bg, child: child ?? const SizedBox.shrink());
        },
        home: switch (_bootPhase) {
          _BootPhase.loading => TripClipStartLoadingPage(
            onFinished: _onStartLoadingFinished,
          ),
          _BootPhase.welcome => TripClipWelcomeSplashPage(
            onContinue: _onWelcomeContinue,
          ),
          _BootPhase.onboarding => TripClipOnboardingSplashPage(
            onComplete: _onOnboardingComplete,
            onBackToWelcome: _onOnboardingBackToWelcome,
          ),
          _BootPhase.login => TripClipLoginPage(
            onLoggedIn: () {
              if (!mounted) return;
              setState(() {
                _isLoggedIn = true;
                _bootPhase = _BootPhase.shell;
              });
            },
          ),
          _BootPhase.shell => const MainShellPage(),
        },
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
    required this.isLoggedIn,
    required this.setLoggedIn,
    required this.goToMainShell,
    required super.child,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> applyThemeMode;

  /// Replays loading, welcome, onboarding, then [MainShellPage].
  final VoidCallback replayStartLoading;

  final bool isLoggedIn;
  final ValueChanged<bool> setLoggedIn;

  /// Marks the user signed in and shows [MainShellPage] (home tab is index 0).
  final VoidCallback goToMainShell;

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
        oldWidget.replayStartLoading != replayStartLoading ||
        oldWidget.isLoggedIn != isLoggedIn ||
        oldWidget.setLoggedIn != setLoggedIn ||
        oldWidget.goToMainShell != goToMainShell;
  }
}
