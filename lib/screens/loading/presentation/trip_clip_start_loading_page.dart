import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// First-launch / boot sequence: plays 11 SVG frames in order, then calls [onFinished].
class TripClipStartLoadingPage extends StatefulWidget {
  const TripClipStartLoadingPage({super.key, required this.onFinished});

  final VoidCallback onFinished;

  /// TripClip primary blue.
  static const Color backgroundColor = Color(0xFF0000D2);

  static const double iconWidth = 158;
  static const double iconHeight = 160;

  static const List<String> _framePaths = [
    'assets/icons/loading-screen1.svg',
    'assets/icons/loading-screen2.svg',
    'assets/icons/loading-screen3.svg',
    'assets/icons/loading-screen4.svg',
    'assets/icons/loading-screen5.svg',
    'assets/icons/loading-screen6.svg',
    'assets/icons/loading-screen7.svg',
    'assets/icons/loading-screen8.svg',
    'assets/icons/loading-screen9.svg',
    'assets/icons/loading-screen10.svg',
    'assets/icons/loading-screen11.svg',
  ];

  @override
  State<TripClipStartLoadingPage> createState() =>
      _TripClipStartLoadingPageState();
}

class _TripClipStartLoadingPageState extends State<TripClipStartLoadingPage> {
  int _frameIndex = 0;

  static const Duration _frameDuration = Duration(milliseconds: 200);
  static const Duration _finalHold = Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    Future.microtask(_playFrames);
  }

  Future<void> _playFrames() async {
    for (var i = 0; i < TripClipStartLoadingPage._framePaths.length; i++) {
      if (!mounted) return;
      setState(() => _frameIndex = i);
      await Future<void>.delayed(_frameDuration);
    }
    if (!mounted) return;
    await Future<void>.delayed(_finalHold);
    if (!mounted) return;
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    final path = TripClipStartLoadingPage._framePaths[_frameIndex];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: TripClipStartLoadingPage.backgroundColor,
        systemNavigationBarColor: TripClipStartLoadingPage.backgroundColor,
      ),
      child: Scaffold(
        backgroundColor: TripClipStartLoadingPage.backgroundColor,
        body: Center(
          child: SizedBox(
            width: TripClipStartLoadingPage.iconWidth,
            height: TripClipStartLoadingPage.iconHeight,
            child: SvgPicture.asset(
              path,
              width: TripClipStartLoadingPage.iconWidth,
              height: TripClipStartLoadingPage.iconHeight,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
