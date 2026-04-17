import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../../app/trip_clip_app.dart';
import '../../../ui/components/app_toast.dart';
import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/forms/trip_clip_atom_input.dart';
import '../../../ui/components/forms/trip_clip_form_checkbox.dart';
import '../../../ui/components/forms/trip_clip_form_message.dart';
import '../../../ui/components/forms/trip_clip_form_models.dart';
import '../../../ui/components/forms/trip_clip_password_visibility_toggle.dart';
import '../../legal/presentation/trip_clip_terms_of_service_sheet.dart';
import 'trip_clip_account_type.dart';

/// Second step: account details (name, email, mobile, passwords, terms).
class TripClipCreateAccountDetailsPage extends StatefulWidget {
  const TripClipCreateAccountDetailsPage({super.key, required this.accountType});

  final TripClipAccountType accountType;

  @override
  State<TripClipCreateAccountDetailsPage> createState() =>
      _TripClipCreateAccountDetailsPageState();
}

class _TripClipCreateAccountDetailsPageState
    extends State<TripClipCreateAccountDetailsPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _mobileFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _agreedTerms = false;

  TripClipFormStatus _emailStatus = TripClipFormStatus.none;
  TripClipFormStatus _mobileStatus = TripClipFormStatus.none;
  TripClipFormStatus _passwordStatus = TripClipFormStatus.none;
  TripClipFormStatus _confirmStatus = TripClipFormStatus.none;

  String? _emailError;
  String? _mobileError;
  String? _passwordError;
  String? _confirmError;

  static const double _fieldGap = 24;
  static const double _labelToField = 8;

  static final RegExp _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _mobileController.addListener(_onMobileChanged);
    _passwordController.addListener(_onPasswordChanged);
    _confirmController.addListener(_onConfirmChanged);
  }

  void _onEmailChanged() {
    if (_emailStatus == TripClipFormStatus.none && _emailError == null) return;
    setState(() {
      _emailStatus = TripClipFormStatus.none;
      _emailError = null;
    });
  }

  void _onMobileChanged() {
    if (_mobileStatus == TripClipFormStatus.none && _mobileError == null) {
      return;
    }
    setState(() {
      _mobileStatus = TripClipFormStatus.none;
      _mobileError = null;
    });
  }

  void _onPasswordChanged() {
    final passwordClear =
        _passwordStatus != TripClipFormStatus.none || _passwordError != null;
    final confirmClear =
        _confirmStatus != TripClipFormStatus.none || _confirmError != null;
    if (!passwordClear && !confirmClear) return;
    setState(() {
      if (passwordClear) {
        _passwordStatus = TripClipFormStatus.none;
        _passwordError = null;
      }
      if (confirmClear) {
        _confirmStatus = TripClipFormStatus.none;
        _confirmError = null;
      }
    });
  }

  void _onConfirmChanged() {
    if (_confirmStatus == TripClipFormStatus.none && _confirmError == null) {
      return;
    }
    setState(() {
      _confirmStatus = TripClipFormStatus.none;
      _confirmError = null;
    });
  }

  bool _validateEmail(String value) => _emailRegex.hasMatch(value.trim());

  bool _validateMobile(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 10;
  }

  bool _validatePassword(String value) => value.trim().length >= 8;

  /// Null if valid; otherwise an error message (length rule, then match).
  String? _confirmValidationError(String password, String confirm) {
    final c = confirm.trim();
    final p = password.trim();
    if (c.isEmpty) {
      return 'Please confirm your password.';
    }
    if (c.length < 8) {
      return 'Must be at least 8 characters.';
    }
    if (c != p) {
      return 'Passwords do not match.';
    }
    return null;
  }

  static final List<TextInputFormatter> _passwordInputFormatters = [
    LengthLimitingTextInputFormatter(128),
  ];

  List<Widget> _errorMessageBelowField({
    required TripClipFormStatus status,
    required String? errorText,
  }) {
    if (status != TripClipFormStatus.error ||
        errorText == null ||
        errorText.trim().isEmpty) {
      return const [];
    }

    return [
      const SizedBox(height: 8),
      TripClipFormMessage(
        text: errorText.trim(),
        kind: TripClipFormMessageKind.error,
        iconSize: 16,
        colorOverride: const Color(0xFFA4332B),
      ),
    ];
  }

  Widget _passwordLengthHint(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark
        ? TripClipPalette.neutral400
        : TripClipPalette.neutral600;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        'Must be at least 8 characters',
        style: GoogleFonts.rubik(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 20 / 14,
          letterSpacing: 0,
          color: color,
        ),
      ),
    );
  }

  void _onContinuePressed() {
    if (!_agreedTerms) {
      AppToast.show(
        context,
        message: 'Please accept the Terms of Service.',
        kind: AppToastKind.warning,
      );
      return;
    }

    final email = _emailController.text;
    final mobile = _mobileController.text;
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    final emailOk = _validateEmail(email);
    final mobileOk = _validateMobile(mobile);
    final passwordOk = _validatePassword(password);
    final confirmErr = _confirmValidationError(password, confirm);
    final confirmOk = confirmErr == null;

    setState(() {
      _emailStatus = emailOk
          ? TripClipFormStatus.success
          : TripClipFormStatus.error;
      _mobileStatus = mobileOk
          ? TripClipFormStatus.success
          : TripClipFormStatus.error;
      _passwordStatus = passwordOk
          ? TripClipFormStatus.success
          : TripClipFormStatus.error;
      _confirmStatus = confirmOk
          ? TripClipFormStatus.success
          : TripClipFormStatus.error;

      _emailError = emailOk ? null : 'Please enter a valid email address.';
      _mobileError = mobileOk
          ? null
          : 'Please enter a valid mobile number (at least 10 digits).';
      _passwordError = passwordOk
          ? null
          : 'Password must be at least 8 characters.';
      _confirmError = confirmOk ? null : confirmErr;
    });

    if (!emailOk || !mobileOk || !passwordOk || !confirmOk) return;

    TripClipAppScope.of(context).goToMainShell();
  }

  ButtonStyle _termsLinkButtonStyle(BuildContext context, TextStyle textStyle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? Colors.white : TripClipPalette.tertiary500;
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
      iconColor: WidgetStateProperty.resolveWith((states) {
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
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _mobileController.removeListener(_onMobileChanged);
    _passwordController.removeListener(_onPasswordChanged);
    _confirmController.removeListener(_onConfirmChanged);
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _mobileFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBorder = isDark
        ? const Color(0xFF2E343D)
        : const Color(0xFFDCE1E6);
    final headerColor = isDark
        ? TripClipPalette.primary400
        : TripClipPalette.primary500;

    final title = switch (widget.accountType) {
      TripClipAccountType.individual => 'Individual Account',
      TripClipAccountType.business => 'Business Account',
    };

    final headerStyle = GoogleFonts.rubik(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 32 / 28,
      letterSpacing: 0,
      color: headerColor,
    );

    final labelColor =
        isDark ? Colors.white : TripClipPalette.tertiary500; // #141E46

    final labelStyle = GoogleFonts.rubik(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 20 / 14,
      letterSpacing: 0,
      color: labelColor,
    );

    final termsPrefixStyle = GoogleFonts.rubik(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 24 / 16,
      letterSpacing: 0,
      color: labelColor,
    );

    final termsLinkStyle = termsPrefixStyle.copyWith(
      decoration: TextDecoration.underline,
    );

    return Scaffold(
      backgroundColor: context.tripClipColors.pageBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 44,
              padding: const EdgeInsets.only(left: 4, right: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: headerBorder, width: 1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: () => Navigator.of(context).maybePop(),
                      customBorder: const CircleBorder(),
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/chevron-left.svg',
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            colorFilter: ColorFilter.mode(
                              headerColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: headerStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Name', style: labelStyle),
                    const SizedBox(height: _labelToField),
                    TripClipAtomInput(
                      controller: _nameController,
                      focusNode: _nameFocus,
                      hintText: 'Eg. John Smith',
                      leadingIconAsset: 'assets/icons/user1.svg',
                      showTrailing: true,
                      hideTrailingWhenStatusNone: true,
                      status: TripClipFormStatus.none,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: _fieldGap),
                    Text('Email', style: labelStyle),
                    const SizedBox(height: _labelToField),
                    TripClipAtomInput(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      hintText: 'you@company.com.au',
                      leadingIconAsset: 'assets/icons/email.svg',
                      showTrailing: true,
                      hideTrailingWhenStatusNone: true,
                      status: _emailStatus,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    ..._errorMessageBelowField(
                      status: _emailStatus,
                      errorText: _emailError,
                    ),
                    const SizedBox(height: _fieldGap),
                    Text('Mobile', style: labelStyle),
                    const SizedBox(height: _labelToField),
                    TripClipAtomInput(
                      controller: _mobileController,
                      focusNode: _mobileFocus,
                      hintText: '0400 123 456',
                      leadingIconAsset: 'assets/icons/phone.svg',
                      showTrailing: true,
                      hideTrailingWhenStatusNone: true,
                      status: _mobileStatus,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    ..._errorMessageBelowField(
                      status: _mobileStatus,
                      errorText: _mobileError,
                    ),
                    const SizedBox(height: _fieldGap),
                    Text('Password', style: labelStyle),
                    const SizedBox(height: _labelToField),
                    TripClipAtomInput(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      hintText: 'Create Password',
                      leadingIconAsset: 'assets/icons/secure-lock.svg',
                      showTrailing: true,
                      status: _passwordStatus,
                      trailing: _passwordStatus ==
                              TripClipFormStatus.success
                          ? null
                          : TripClipPasswordVisibilityToggle(
                              shown: _showPassword,
                              focused: _passwordFocus.hasFocus,
                              hasValue:
                                  _passwordController.text.isNotEmpty,
                              status: _passwordStatus,
                              onPressed: () => setState(
                                () => _showPassword = !_showPassword,
                              ),
                            ),
                      obscureText: !_showPassword,
                      textInputAction: TextInputAction.next,
                      inputFormatters: _passwordInputFormatters,
                    ),
                    if (_passwordStatus == TripClipFormStatus.none &&
                        _passwordError == null)
                      _passwordLengthHint(context),
                    ..._errorMessageBelowField(
                      status: _passwordStatus,
                      errorText: _passwordError,
                    ),
                    const SizedBox(height: _fieldGap),
                    Text('Confirm Password', style: labelStyle),
                    const SizedBox(height: _labelToField),
                    TripClipAtomInput(
                      controller: _confirmController,
                      focusNode: _confirmFocus,
                      hintText: 'Create Password',
                      leadingIconAsset: 'assets/icons/secure-lock.svg',
                      showTrailing: true,
                      status: _confirmStatus,
                      trailing: _confirmStatus ==
                              TripClipFormStatus.success
                          ? null
                          : TripClipPasswordVisibilityToggle(
                              shown: _showConfirmPassword,
                              focused: _confirmFocus.hasFocus,
                              hasValue:
                                  _confirmController.text.isNotEmpty,
                              status: _confirmStatus,
                              onPressed: () => setState(
                                () =>
                                    _showConfirmPassword = !_showConfirmPassword,
                              ),
                            ),
                      obscureText: !_showConfirmPassword,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _onContinuePressed(),
                      inputFormatters: _passwordInputFormatters,
                    ),
                    if (_confirmStatus == TripClipFormStatus.none &&
                        _confirmError == null)
                      _passwordLengthHint(context),
                    ..._errorMessageBelowField(
                      status: _confirmStatus,
                      errorText: _confirmError,
                    ),
                    const SizedBox(height: _fieldGap),
                    TripClipFormCheckbox(
                      value: _agreedTerms,
                      onChanged: (v) => setState(() => _agreedTerms = v),
                      label: 'I agree to the Terms of Service',
                      labelWidget: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'I agree to the ',
                              style: termsPrefixStyle,
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(0, -2),
                            child: TripClipButton(
                              variant: TripClipButtonVariant.tertiary,
                              label: 'Terms of Service',
                              onPressed: () =>
                                  showTripClipTermsOfServiceSheet(context),
                              styleOverride: _termsLinkButtonStyle(
                                context,
                                termsLinkStyle,
                              ),
                            ),
                          ),
                        ],
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
                label: 'Continue',
                onPressed: _onContinuePressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
