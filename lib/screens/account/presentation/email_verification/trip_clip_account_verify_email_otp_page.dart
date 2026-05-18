import 'package:flutter/material.dart';

import '../../../../app/theme/trip_clip_colors.dart';
import '../../../../ui/components/app_toast.dart';
import '../../../../ui/components/buttons/trip_clip_button.dart';
import '../../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../../ui/components/forms/trip_clip_form_models.dart';
import '../../../../ui/components/forms/trip_clip_otp_input.dart';
import '../../../../ui/components/pages/trip_clip_content_page_scaffold.dart';
import '../../../auth/data/trip_clip_verify_otp_service.dart';
import '../../../auth/presentation/trip_clip_account_verify_success_page.dart';
import 'trip_clip_verify_email_otp_service.dart';

class TripClipAccountVerifyEmailOtpPage extends StatefulWidget {
  const TripClipAccountVerifyEmailOtpPage({
    super.key,
    required this.emailRaw,
    this.verifyOtpService,
  });

  final String emailRaw;
  final TripClipVerifyEmailOtpService? verifyOtpService;

  @override
  State<TripClipAccountVerifyEmailOtpPage> createState() =>
      _TripClipAccountVerifyEmailOtpPageState();
}

class _TripClipAccountVerifyEmailOtpPageState
    extends State<TripClipAccountVerifyEmailOtpPage> {
  final _otpController = TextEditingController();

  TripClipVerifyEmailOtpService get _otpService =>
      widget.verifyOtpService ?? const MockTripClipVerifyEmailOtpService();

  TripClipFormStatus _otpStatus = TripClipFormStatus.none;
  String? _otpMessage;
  bool _verificationBusy = false;

  bool get _otpEditable => !_verificationBusy;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onOtpChanged() {
    if (_otpStatus == TripClipFormStatus.none && _otpMessage == null) {
      setState(() {});
      return;
    }
    setState(() {
      _otpStatus = TripClipFormStatus.none;
      _otpMessage = null;
    });
  }

  Future<void> _onVerify() async {
    if (_otpController.text.length != 6 || _verificationBusy) return;
    setState(() {
      _verificationBusy = true;
      _otpStatus = TripClipFormStatus.none;
      _otpMessage = null;
    });

    final result = await _otpService.verify(
      emailRaw: widget.emailRaw,
      otp: _otpController.text,
    );

    if (!mounted) return;

    switch (result) {
      case TripClipOtpVerifySuccess():
        if (!mounted) return;
        final rootNav = Navigator.of(context, rootNavigator: true);
        final shellNav = Navigator.of(context, rootNavigator: false);
        shellNav.popUntil((r) => r.isFirst);
        rootNav.push<void>(
          MaterialPageRoute<void>(
            builder: (routeContext) => TripClipAccountVerifySuccessPage(
              onGoToAccount: () {
                Navigator.of(routeContext, rootNavigator: true).pop();
              },
              successMessage: 'Your email has been verified',
            ),
          ),
        );
        return;
      case TripClipOtpVerifyFailure(:final message):
        setState(() {
          _verificationBusy = false;
          _otpStatus = TripClipFormStatus.error;
          _otpMessage = message;
        });
    }
  }

  void _onResend() {
    setState(() {
      _otpStatus = TripClipFormStatus.none;
      _otpMessage = null;
    });
    AppToast.show(
      context,
      message: 'A new code has been sent.',
      kind: AppToastKind.info,
    );
  }

  ButtonStyle _resendButtonStyle(BuildContext context) {
    final fg = context.tripClipColors.heading;
    final textStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w500,
        );
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(const Size(0, 0)),
      padding: WidgetStateProperty.all(EdgeInsets.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textStyle: WidgetStateProperty.all(textStyle),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return fg.withValues(alpha: 0.72);
        }
        return fg;
      }),
      overlayColor: WidgetStateProperty.all<Color?>(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bodyColor = context.tripClipColors.textBase;
    final bodyStyle =
        Theme.of(context).textTheme.bodyMedium!.copyWith(color: bodyColor);

    final emailStyle = bodyStyle.copyWith(fontWeight: FontWeight.w600);
    final displayEmail = widget.emailRaw.trim();

    final otpComplete = _otpController.text.length == 6;

    return TripClipContentPageScaffold(
      appBarTitle: 'Verify Email',
      heading: 'We sent a code by email',
      bottomBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: TripClipButton(
          variant: TripClipButtonVariant.primary,
          expanded: true,
          label: _verificationBusy ? 'Checking…' : 'Verify',
          onPressed: otpComplete && !_verificationBusy ? _onVerify : null,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              style: bodyStyle,
              children: [
                const TextSpan(text: 'We sent a 6 digit code to: '),
                TextSpan(text: displayEmail, style: emailStyle),
                const TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Please enter it below.', style: bodyStyle),
          const SizedBox(height: 24),
          TripClipOtpInput(
            controller: _otpController,
            autofocus: true,
            enabled: _otpEditable,
            status: _otpStatus,
            message: _otpMessage,
            onChanged: (_) => _onOtpChanged(),
          ),
          const SizedBox(height: 34),
          Align(
            alignment: Alignment.center,
            child: TripClipButton(
              variant: TripClipButtonVariant.tertiary,
              label: 'Resend Code',
              onPressed: _onResend,
              styleOverride: _resendButtonStyle(context),
            ),
          ),
        ],
      ),
    );
  }
}
