import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../ui/components/app_toast.dart';
import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/forms/trip_clip_form_models.dart';
import '../../../ui/components/forms/trip_clip_otp_input.dart';
import '../../../ui/components/trip_clip_title_bar.dart';
import '../data/trip_clip_verify_otp_service.dart';
import 'trip_clip_account_type.dart';
import 'trip_clip_account_verify_success_page.dart';
import 'trip_clip_mobile_display_format.dart';

class TripClipVerifyMobileNumberPage extends StatefulWidget {
  const TripClipVerifyMobileNumberPage({
    super.key,
    required this.accountType,
    required this.mobileRaw,
    this.verifyOtpService,
  });

  final TripClipAccountType accountType;
  final String mobileRaw;

  final TripClipVerifyOtpService? verifyOtpService;

  @override
  State<TripClipVerifyMobileNumberPage> createState() =>
      _TripClipVerifyMobileNumberPageState();
}

class _TripClipVerifyMobileNumberPageState
    extends State<TripClipVerifyMobileNumberPage> {
  final _otpController = TextEditingController();

  TripClipVerifyOtpService get _otpService =>
      widget.verifyOtpService ?? const MockTripClipVerifyOtpService();

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
      mobileRaw: widget.mobileRaw,
      otp: _otpController.text,
    );

    if (!mounted) return;

    switch (result) {
      case TripClipOtpVerifySuccess():
        if (!mounted) return;
        setState(() => _verificationBusy = false);
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil<void>(
          MaterialPageRoute<void>(
            builder: (_) => const TripClipAccountVerifySuccessPage(),
          ),
          (route) => route.isFirst,
        );
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
    final pageBg = context.tripClipColors.pageBackground;
    final t = Theme.of(context).textTheme;
    final headingStyle =
        t.headlineLarge!.copyWith(color: context.tripClipColors.heading);

    final bodyColor = context.tripClipColors.textBase;
    final bodyStyle = t.bodyMedium!.copyWith(color: bodyColor);

    final phoneStyle = bodyStyle.copyWith(fontWeight: FontWeight.w600);
    final formattedPhone = tripClipFormatMobileDisplay(widget.mobileRaw);

    final otpComplete = _otpController.text.length == 6;

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TripClipTitleBar(
              title: 'Verify Mobile Number',
              includeStatusBarInset: false,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: context.tripClipColors.borderSubtle,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('We sent a code by SMS', style: headingStyle),
                    const SizedBox(height: 24),
                    Text.rich(
                      TextSpan(
                        style: bodyStyle,
                        children: [
                          const TextSpan(text: 'We sent a 6 digit code to: '),
                          TextSpan(text: formattedPhone, style: phoneStyle),
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TripClipButton(
                variant: TripClipButtonVariant.primary,
                expanded: true,
                label: _verificationBusy ? 'Checking…' : 'Verify',
                onPressed: otpComplete && !_verificationBusy ? _onVerify : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
