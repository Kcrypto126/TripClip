import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/trip_clip_colors.dart';
import '../../../../app/trip_clip_app.dart';
import '../../../../ui/components/buttons/trip_clip_button.dart';
import '../../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../../ui/components/pages/trip_clip_stepped_page_scaffold.dart';
import '../../../../ui/shell/main_shell_page.dart';
import '../help_support/trip_clip_contact_page.dart';
import 'trip_clip_id_verification_photo_id_body.dart';
import 'trip_clip_id_verification_result_body.dart';
import 'trip_clip_id_verification_selfie_body.dart';
import 'trip_clip_id_verification_verifying_page.dart';

const Color _kCardInactiveLight = Color(0xFFEFF2F5);
const Color _kCardInactiveDark = Color(0xFF1F242B);
const Color _kCardActiveLight = Color(0xFF141E46);
const Color _kCardActiveDark = Color(0xFF7C86AE);

class TripClipIdVerificationFlowPage extends StatefulWidget {
  const TripClipIdVerificationFlowPage({super.key});

  @override
  State<TripClipIdVerificationFlowPage> createState() =>
      _TripClipIdVerificationFlowPageState();
}

enum _IdDocKind { driverLicence, passport, proofOfAge }

class _TripClipIdVerificationFlowPageState
    extends State<TripClipIdVerificationFlowPage> {
  static const int _totalSteps = 6;

  int _step = 0;
  _IdDocKind _selectedDoc = _IdDocKind.driverLicence;

  String? _idFrontPhotoPath;
  String? _idBackPhotoPath;
  bool? _verificationSuccess;

  final GlobalKey<TripClipIdVerificationPhotoIdBodyState> _photoCaptureKey =
      GlobalKey<TripClipIdVerificationPhotoIdBodyState>();
  final GlobalKey<TripClipIdVerificationSelfieBodyState> _selfieCaptureKey =
      GlobalKey<TripClipIdVerificationSelfieBodyState>();

  void _setStep(int value) {
    final next = value.clamp(0, _totalSteps - 1);
    if (next == _step) return;
    setState(() => _step = next);
  }

  TextStyle _bodyStyle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(color: context.tripClipColors.textBase);
  }

  TextStyle _sectionHeadingStyle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .headlineMedium!
        .copyWith(color: context.tripClipColors.textBase);
  }

  Widget _buildIntro(BuildContext context) {
    final iconColor = context.tripClipColors.textSubtle;
    final body = _bodyStyle(context);
    final section = _sectionHeadingStyle(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SvgPicture.asset(
            'assets/icons/scan_id.svg',
            width: 160,
            height: 160,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Verifying your identity helps us protect both Senders and Travellers.',
          style: body,
        ),
        const SizedBox(height: 16),
        Text(
          'Your personal information will be encrypted and securely stored. '
          'We never share your details with other users.',
          style: body,
        ),
        const SizedBox(height: 24),
        Text("What you'll need", style: section),
        const SizedBox(height: 8),
        TripClipSteppedBulletLine(
          text:
              'Valid Australian ID (drivers licence, passport, proof of age card)',
          style: body,
        ),
        TripClipSteppedBulletLine(
          text: 'A clear photo of yourself',
          style: body,
        ),
        TripClipSteppedBulletLine(text: 'About 2-3 minutes', style: body),
      ],
    );
  }

  Widget _buildDocSelect(BuildContext context) {
    final body = _bodyStyle(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _IdDocumentCard(
          selected: _selectedDoc == _IdDocKind.driverLicence,
          iconAsset: 'assets/icons/driver_license.svg',
          title: 'Driver Licence',
          subtitle: 'Australian driver licence',
          footer: 'Front and back',
          onTap: () => setState(() => _selectedDoc = _IdDocKind.driverLicence),
        ),
        const SizedBox(height: 16),
        _IdDocumentCard(
          selected: _selectedDoc == _IdDocKind.passport,
          iconAsset: 'assets/icons/passport2.svg',
          title: 'Passport',
          subtitle: 'Australian passport',
          footer: 'Photo page',
          onTap: () => setState(() => _selectedDoc = _IdDocKind.passport),
        ),
        const SizedBox(height: 16),
        _IdDocumentCard(
          selected: _selectedDoc == _IdDocKind.proofOfAge,
          iconAsset: 'assets/icons/driver_license.svg',
          title: 'Proof of age card',
          subtitle: 'Australian proof of age card',
          footer: 'Front and back',
          onTap: () => setState(() => _selectedDoc = _IdDocKind.proofOfAge),
        ),
        const SizedBox(height: 24),
        Text('Make sure your ID is current and not expired.', style: body),
      ],
    );
  }

  String _headingForStep() {
    return switch (_step) {
      0 => 'Verify your identity',
      1 => 'Choose document type',
      2 => 'Photo ID: Front',
      3 => 'Photo ID: Back',
      4 => 'Take a selfie',
      5 =>
        _verificationSuccess == true
            ? 'Verification successful'
            : 'Verification failed',
      _ => 'Verification',
    };
  }

  Widget _buildBody(BuildContext context) {
    return switch (_step) {
      0 => _buildIntro(context),
      1 => _buildDocSelect(context),
      2 => TripClipIdVerificationPhotoIdBody(
        key: _photoCaptureKey,
        side: TripClipIdVerificationPhotoSide.front,
      ),
      3 => TripClipIdVerificationPhotoIdBody(
        key: _photoCaptureKey,
        side: TripClipIdVerificationPhotoSide.back,
      ),
      4 => TripClipIdVerificationSelfieBody(key: _selfieCaptureKey),
      5 => TripClipIdVerificationResultBody(
        success: _verificationSuccess == true,
      ),
      _ => Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Text(
          'This step will be available soon.',
          style: _bodyStyle(context),
        ),
      ),
    };
  }

  String? _primaryLabel() {
    return switch (_step) {
      0 => 'Choose Document Type',
      1 => 'Take Photo of ID',
      2 => 'Take Photo of ID: Front',
      3 => 'Take Photo of ID: Back',
      4 => 'Take Selfie',
      5 => null,
      _ => null,
    };
  }

  void _onPrimaryPressed() {
    unawaited(_onPrimaryPressedAsync());
  }

  Future<void> _onPrimaryPressedAsync() async {
    if (_step == 0) {
      _setStep(1);
    } else if (_step == 1) {
      _setStep(2);
    } else if (_step == 2) {
      final path = await _photoCaptureKey.currentState?.capturePhoto();
      if (!mounted) return;
      if (path != null) {
        _idFrontPhotoPath = path;
        _setStep(3);
      }
    } else if (_step == 3) {
      final path = await _photoCaptureKey.currentState?.capturePhoto();
      if (!mounted) return;
      if (path != null) {
        _idBackPhotoPath = path;
        _setStep(4);
      }
    } else if (_step == 4) {
      final selfiePath = await _selfieCaptureKey.currentState?.capturePhoto();
      if (!mounted) return;
      if (selfiePath == null) return;
      final ok = await Navigator.of(context, rootNavigator: true).push<bool>(
        MaterialPageRoute<bool>(
          fullscreenDialog: true,
          builder: (context) => TripClipIdVerificationVerifyingPage(
            idFrontPath: _idFrontPhotoPath,
            idBackPath: _idBackPhotoPath,
            selfiePath: selfiePath,
          ),
        ),
      );
      if (!mounted) return;
      if (ok == null) return;
      setState(() => _verificationSuccess = ok);
      _setStep(5);
    }
  }

  Widget? _bottomBarForStep() {
    if (_step != 5) return null;

    final success = _verificationSuccess == true;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TripClipButton(
            variant: TripClipButtonVariant.primary,
            expanded: true,
            label: success ? 'Browse Trips' : 'Retry Verification',
            onPressed: () {
              if (success) {
                TripClipAppScope.of(context).goToMainShell(initialTabIndex: 1);
              } else {
                setState(() {
                  _verificationSuccess = null;
                  _idFrontPhotoPath = null;
                  _idBackPhotoPath = null;
                });
                _setStep(0);
              }
            },
          ),
          const SizedBox(height: 16),
          TripClipButton(
            variant: TripClipButtonVariant.secondary,
            expanded: true,
            label: success ? 'Go to account' : 'Contact Support',
            onPressed: () {
              if (success) {
                TripClipAppScope.of(
                  context,
                ).goToMainShell(initialTabIndex: MainShellPage.accountTabIndex);
              } else {
                Navigator.of(context, rootNavigator: true).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const TripClipContactPage(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = _primaryLabel();
    final stepBottomBar = _bottomBarForStep();

    return TripClipSteppedPageScaffold(
      currentStep: _step,
      totalSteps: _totalSteps,
      heading: _headingForStep(),
      onStepChanged: _setStep,
      onExitAtFirstStep: () => Navigator.of(context).maybePop(),
      body: _buildBody(context),
      bottomBar:
          stepBottomBar ??
          (label == null
              ? null
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: TripClipButton(
                    variant: TripClipButtonVariant.primary,
                    expanded: true,
                    label: label,
                    onPressed: _onPrimaryPressed,
                  ),
                )),
    );
  }
}

class _IdDocumentCard extends StatelessWidget {
  const _IdDocumentCard({
    required this.selected,
    required this.iconAsset,
    required this.title,
    required this.subtitle,
    required this.footer,
    required this.onTap,
  });

  final bool selected;
  final String iconAsset;
  final String title;
  final String subtitle;
  final String footer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveBg = isDark ? _kCardInactiveDark : _kCardInactiveLight;
    final activeBg = isDark ? _kCardActiveDark : _kCardActiveLight;
    final bg = selected ? activeBg : inactiveBg;

    final titleBodyColor = selected
        ? Colors.white
        : context.tripClipColors.textBase;

    final t = Theme.of(context).textTheme;
    final titleStyle = t.headlineSmall!.copyWith(color: titleBodyColor);
    final subtitleStyle = t.bodyMedium!.copyWith(color: titleBodyColor);
    final footerColor = selected && isDark
        ? const Color(0xFFFFFFFF)
        : context.tripClipColors.textSubtle;
    final footerStyle = t.labelMedium!.copyWith(color: footerColor);

    final iconColor =
        selected ? Colors.white : context.tripClipColors.textSubtle;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashFactory: NoSplash.splashFactory,
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  iconAsset,
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: titleStyle),
                      const SizedBox(height: 4),
                      Text(subtitle, style: subtitleStyle),
                      const SizedBox(height: 4),
                      Text(footer, style: footerStyle),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
