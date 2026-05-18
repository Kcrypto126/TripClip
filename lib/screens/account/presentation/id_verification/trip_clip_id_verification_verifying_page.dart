import 'dart:async' show unawaited;
import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/trip_clip_palette.dart';

const Color _kPageBlue = TripClipPalette.primary500;
const Color _kIconOrange = Color(0xFFFA782D);
const Color _kTitleWhite = Color(0xFFFFFFFF);

enum _TripClipVerifyPhase { loading, success, failure }

class TripClipIdVerificationVerifyingPage extends StatefulWidget {
  const TripClipIdVerificationVerifyingPage({
    super.key,
    this.idFrontPath,
    this.idBackPath,
    this.selfiePath,
    this.submitVerification,
  });

  final String? idFrontPath;
  final String? idBackPath;
  final String? selfiePath;

  final Future<bool> Function({
    required String? idFrontPath,
    required String? idBackPath,
    required String? selfiePath,
  })?
  submitVerification;

  @override
  State<TripClipIdVerificationVerifyingPage> createState() =>
      _TripClipIdVerificationVerifyingPageState();
}

Future<bool> _defaultSubmitVerification({
  required String? idFrontPath,
  required String? idBackPath,
  required String? selfiePath,
}) async {
  await Future<void>.delayed(const Duration(seconds: 5));
  assert(() {
    debugPrint(
      'ID verification upload (stub): front=$idFrontPath '
      'back=$idBackPath selfie=$selfiePath',
    );
    return true;
  }());
  return Random().nextBool();
}

class _TripClipIdVerificationVerifyingPageState
    extends State<TripClipIdVerificationVerifyingPage>
    with SingleTickerProviderStateMixin {
  static const double _iconSize = 160;
  static const double _iconTextGap = 24;

  late final AnimationController _spinController;

  _TripClipVerifyPhase _phase = _TripClipVerifyPhase.loading;

  TextStyle _titleStyleFor(BuildContext context) => Theme.of(context)
      .textTheme
      .displaySmall!
      .copyWith(color: _kTitleWhite);

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_runSubmit());
    });
  }

  Future<void> _runSubmit() async {
    final submit = widget.submitVerification ?? _defaultSubmitVerification;
    final ok = await submit(
      idFrontPath: widget.idFrontPath,
      idBackPath: widget.idBackPath,
      selfiePath: widget.selfiePath,
    );
    if (!mounted) return;
    _spinController.stop();
    setState(() {
      _phase = ok ? _TripClipVerifyPhase.success : _TripClipVerifyPhase.failure;
    });
    await Future<void>.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;
    Navigator.of(context).maybePop(ok);
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: PopScope(
        canPop: _phase != _TripClipVerifyPhase.loading,
        child: Scaffold(
          backgroundColor: _kPageBlue,
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildContent(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final titleStyle = _titleStyleFor(context);
    switch (_phase) {
      case _TripClipVerifyPhase.loading:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotationTransition(
              turns: _spinController,
              child: SvgPicture.asset(
                'assets/icons/large-loading.svg',
                width: _iconSize,
                height: _iconSize,
                fit: BoxFit.contain,
                colorFilter: const ColorFilter.mode(
                  _kIconOrange,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: _iconTextGap),
            Text(
              'Verifying your\ndetails',
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
          ],
        );
      case _TripClipVerifyPhase.success:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/large-ticket-circle.svg',
              width: _iconSize,
              height: _iconSize,
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(
                _kIconOrange,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: _iconTextGap),
            Text(
              'Verification\nsuccessful',
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
          ],
        );
      case _TripClipVerifyPhase.failure:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/large-cancel-circle.svg',
              width: _iconSize,
              height: _iconSize,
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(
                _kIconOrange,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: _iconTextGap),
            Text(
              'Verification\nfailed',
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
          ],
        );
    }
  }
}
