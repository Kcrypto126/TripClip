import 'package:flutter/material.dart';

import '../../../../app/navigation/trip_clip_navigator.dart';
import '../../../../app/theme/trip_clip_colors.dart';
import '../../../../ui/components/buttons/trip_clip_button.dart';
import '../../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../../ui/components/forms/trip_clip_atom_input.dart';
import '../../../../ui/components/pages/trip_clip_content_page_scaffold.dart';
import 'trip_clip_account_verify_email_otp_page.dart';

class TripClipVerifyEmailPage extends StatefulWidget {
  const TripClipVerifyEmailPage({super.key});

  @override
  State<TripClipVerifyEmailPage> createState() => _TripClipVerifyEmailPageState();
}

class _TripClipVerifyEmailPageState extends State<TripClipVerifyEmailPage> {
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();

  static const double _fieldGap = 24;
  static const double _labelToField = 8;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (mounted) setState(() {});
  }

  bool _isValidEmail(String value) {
    final t = value.trim();
    if (t.length < 5) return false;
    final at = t.indexOf('@');
    if (at <= 0 || at >= t.length - 1) return false;
    final dot = t.lastIndexOf('.');
    return dot > at + 1 && dot < t.length - 1;
  }

  bool get _formComplete => _isValidEmail(_emailController.text);

  void _onSendCode() {
    if (!_formComplete) return;
    final raw = _emailController.text.trim();
    tripClipPushMaterialPage<void>(
      context,
      TripClipAccountVerifyEmailOtpPage(emailRaw: raw),
      shellNavHighlightTabIndex: TripClipShellNavRoutes.accountTabIndex,
    );
  }

  @override
  void dispose() {
    _emailController.removeListener(_onFormChanged);
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textBase = context.tripClipColors.textBase;

    final t = Theme.of(context).textTheme;
    final labelStyle = t.bodySmall!.copyWith(
      fontWeight: FontWeight.w500,
      color: textBase,
    );

    final introColor = textBase;
    final introStyle = t.bodyMedium!.copyWith(color: introColor);

    return TripClipContentPageScaffold(
      appBarTitle: 'Verify Email',
      heading: 'Enter your email',
      bottomBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: TripClipButton(
          variant: TripClipButtonVariant.primary,
          label: 'Send Code',
          expanded: true,
          onPressed: _formComplete ? _onSendCode : null,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text(
            'Verifying your identity helps us protect both Senders and '
            'Travellers.',
            style: introStyle,
          ),
          const SizedBox(height: _fieldGap),
          Text('Email', style: labelStyle),
          const SizedBox(height: _labelToField),
          TripClipAtomInput(
            controller: _emailController,
            focusNode: _emailFocus,
            hintText: 'e.g. name@company.com.au',
            leadingIconAsset: 'assets/icons/email.svg',
            showTrailing: false,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}
