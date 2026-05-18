import 'package:flutter/material.dart';

import '../screens/account/presentation/id_verification/trip_clip_verify_success_loading_page.dart';
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
  int _shellInitialTabIndex = 0;

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

  void _enterMainShell({int initialTabIndex = 0}) {
    if (!mounted) return;
    setState(() {
      _isLoggedIn = true;
      _bootPhase = _BootPhase.shell;
      _shellInitialTabIndex = initialTabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TripClipAppScope(
      themeMode: _themeMode,
      applyThemeMode: _applyThemeMode,
      replayStartLoading: _replayStartLoading,
      isLoggedIn: _isLoggedIn,
      setLoggedIn: _setLoggedIn,
      goToMainShell: _enterMainShell,
      child: MaterialApp(
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
          _BootPhase.loading => TripClipVerifySuccessLoadingPage(
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
            onLoggedIn: () => _enterMainShell(initialTabIndex: 0),
          ),
          _BootPhase.shell => MainShellPage(
            key: ValueKey<int>(_shellInitialTabIndex),
            initialTabIndex: _shellInitialTabIndex,
          ),
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

  final VoidCallback replayStartLoading;

  final bool isLoggedIn;
  final ValueChanged<bool> setLoggedIn;

  final void Function({int initialTabIndex}) goToMainShell;

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
