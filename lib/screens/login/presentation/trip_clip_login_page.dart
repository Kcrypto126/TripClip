import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/trip_clip_palette.dart';
import '../../auth/presentation/trip_clip_create_account_page.dart';
import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/buttons/trip_clip_button_styles.dart';
import '../../../ui/components/forms/trip_clip_atom_input.dart';
import '../../../ui/components/forms/trip_clip_form_models.dart';
import '../../../ui/components/forms/trip_clip_form_message.dart';
import '../../../ui/components/forms/trip_clip_password_visibility_toggle.dart';
import '../../../ui/components/app_toast.dart';

class TripClipLoginPage extends StatefulWidget {
  const TripClipLoginPage({
    super.key,
    required this.onLoggedIn,
    this.onCreateAccount,
  });

  final VoidCallback onLoggedIn;

  /// When set (e.g. from [MainShellPage] auth overlay), opens create account on
  /// the same navigator so the shell bottom bar stays visible.
  final VoidCallback? onCreateAccount;

  static const Color backgroundColor = TripClipPalette.primary500; // #0000D2

  @override
  State<TripClipLoginPage> createState() => _TripClipLoginPageState();
}

class _TripClipLoginPageState extends State<TripClipLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _showPassword = false;

  TripClipFormStatus _emailStatus = TripClipFormStatus.none;
  TripClipFormStatus _passwordStatus = TripClipFormStatus.none;
  String? _emailError;
  String? _passwordError;

  static const _pagePadding = EdgeInsets.all(32);
  static const _sectionGap = 24.0;

  static const _labelToFieldGap = 8.0;
  static const _fieldGap = 16.0;
  static const _fieldToLoginGap = 32.0;
  static const _loginToForgotGap = 26.0;
  static const _forgotToOrGap = 50.0;
  static const _orToSocialGap = 40.0;
  static const _socialButtonsGap = 16.0;

  static final RegExp _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onEmailChanged() {
    if (_emailStatus == TripClipFormStatus.none && _emailError == null) return;
    setState(() {
      _emailStatus = TripClipFormStatus.none;
      _emailError = null;
    });
  }

  void _onPasswordChanged() {
    if (_passwordStatus == TripClipFormStatus.none && _passwordError == null) {
      return;
    }
    setState(() {
      _passwordStatus = TripClipFormStatus.none;
      _passwordError = null;
    });
  }

  bool _validateEmail(String value) => _emailRegex.hasMatch(value.trim());

  bool _validatePassword(String value) => value.trim().length >= 8;

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

  Future<_LoginResult> _mockBackendLogin({
    required String email,
    required String password,
  }) async {
    // Frontend-only placeholder. Replace with API call later.
    await Future<void>.delayed(const Duration(milliseconds: 450));

    final e = email.trim().toLowerCase();

    // Simple deterministic failure path for UI testing.
    if (e.contains('fail')) {
      return const _LoginResult.failure('Invalid email or password.');
    }
    return const _LoginResult.success();
  }

  Future<void> _onLoginPressed() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final emailOk = _validateEmail(email);
    final passwordOk = _validatePassword(password);

    setState(() {
      _emailStatus = emailOk
          ? TripClipFormStatus.success
          : TripClipFormStatus.error;
      _passwordStatus = passwordOk
          ? TripClipFormStatus.success
          : TripClipFormStatus.error;

      _emailError = emailOk ? null : 'Please enter a valid email address.';
      _passwordError = passwordOk
          ? null
          : 'Password must be at least 8 characters.';
    });

    if (!emailOk || !passwordOk) return;

    final result = await _mockBackendLogin(email: email, password: password);
    if (!mounted) return;

    if (!result.ok) {
      setState(() {
        _emailStatus = TripClipFormStatus.none;
        _passwordStatus = TripClipFormStatus.none;
      });
      AppToast.show(
        context,
        message: result.message ?? 'Login failed.',
        kind: AppToastKind.error,
      );
      return;
    }

    AppToast.show(
      context,
      message: 'Login successful.',
      kind: AppToastKind.success,
    );
    widget.onLoggedIn();
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _passwordController.removeListener(_onPasswordChanged);
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = GoogleFonts.rubik(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 20 / 14,
      letterSpacing: 0,
      color: Colors.white,
    );

    final forgotStyle = GoogleFonts.rubik(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 24 / 16,
      letterSpacing: 0,
      color: Colors.white,
    );

    final orStyle = GoogleFonts.rubik(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 24 / 16,
      letterSpacing: 0,
      color: Colors.white,
    );

    final footerStyle = GoogleFonts.rubik(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 24 / 16,
      letterSpacing: 0,
      color: Colors.white,
    );

    final socialStyle = _socialButtonStyle(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: TripClipLoginPage.backgroundColor,
        systemNavigationBarColor: TripClipLoginPage.backgroundColor,
      ),
      child: Scaffold(
        backgroundColor: TripClipLoginPage.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: _pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    'assets/icons/home-logo-dark.svg',
                    width: 200,
                    height: 44,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: _sectionGap),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Email', style: labelStyle),
                          const SizedBox(height: _labelToFieldGap),
                          _LightInputsTheme(
                            child: TripClipAtomInput(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              hintText: 'your@email.com',
                              leadingIconAsset: 'assets/icons/email.svg',
                              showTrailing: true,
                              hideTrailingWhenStatusNone: true,
                              status: _emailStatus,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          ..._errorMessageBelowField(
                            status: _emailStatus,
                            errorText: _emailError,
                          ),
                          const SizedBox(height: _fieldGap),
                          Text('Password', style: labelStyle),
                          const SizedBox(height: _labelToFieldGap),
                          _LightInputsTheme(
                            child: TripClipAtomInput(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              hintText: 'Enter Password',
                              leadingIconAsset: 'assets/icons/secure-lock.svg',
                              showTrailing: true,
                              status: _passwordStatus,
                              trailing: _passwordStatus ==
                                      TripClipFormStatus.success
                                  ? null
                                  : TripClipPasswordVisibilityToggle(
                                      shown: _showPassword,
                                      active:
                                          _passwordFocus.hasFocus ||
                                          _passwordController.text.isNotEmpty,
                                      status: _passwordStatus,
                                      onPressed: () => setState(
                                        () => _showPassword = !_showPassword,
                                      ),
                                    ),
                              obscureText: !_showPassword,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _onLoginPressed(),
                            ),
                          ),
                          ..._errorMessageBelowField(
                            status: _passwordStatus,
                            errorText: _passwordError,
                          ),
                          const SizedBox(height: _fieldToLoginGap),
                          TripClipButton(
                            variant: TripClipButtonVariant.primaryAlternative,
                            expanded: true,
                            label: 'Log In',
                            onPressed: _onLoginPressed,
                          ),
                          const SizedBox(height: _loginToForgotGap),
                          Center(
                            child: TripClipButton(
                              variant: TripClipButtonVariant.tertiary,
                              label: 'Forgot password?',
                              onPressed: () {},
                              styleOverride: _textLinkButtonStyle(forgotStyle),
                            ),
                          ),
                          const SizedBox(height: _forgotToOrGap),
                          Center(child: Text('OR', style: orStyle)),
                          const SizedBox(height: _orToSocialGap),
                          TripClipButton(
                            variant: TripClipButtonVariant.primaryAlternative,
                            expanded: true,
                            styleOverride: socialStyle,
                            iconPlacement: TripClipButtonIconPlacement.leading,
                            svgAsset: 'assets/icons/google.svg',
                            tintSvg: false,
                            label: 'Log in with Google',
                            onPressed: () {},
                          ),
                          const SizedBox(height: _socialButtonsGap),
                          TripClipButton(
                            variant: TripClipButtonVariant.primaryAlternative,
                            expanded: true,
                            styleOverride: socialStyle,
                            iconPlacement: TripClipButtonIconPlacement.leading,
                            svgAsset: 'assets/icons/apple.svg',
                            tintSvg: false,
                            label: 'Log in with Apple',
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: _sectionGap),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 0,
                    children: [
                      Text('New to TripClip?', style: footerStyle),
                      const SizedBox(width: 4),
                      TripClipButton(
                        variant: TripClipButtonVariant.tertiary,
                        label: 'Create Account',
                        onPressed: () {
                          if (widget.onCreateAccount != null) {
                            widget.onCreateAccount!();
                          } else {
                            Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    const TripClipCreateAccountPage(),
                              ),
                            );
                          }
                        },
                        styleOverride: _textLinkButtonStyle(
                          footerStyle.copyWith(
                            decoration: TextDecoration.underline,
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
      ),
    );
  }

  ButtonStyle _textLinkButtonStyle(TextStyle textStyle) {
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(const Size(0, 0)),
      padding: WidgetStateProperty.all(EdgeInsets.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textStyle: WidgetStateProperty.all(textStyle),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.white.withValues(alpha: 0.78);
        }
        return Colors.white;
      }),
      iconColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.white.withValues(alpha: 0.78);
        }
        return Colors.white;
      }),
      // No background/overlay effect; only text/icon tint changes on press.
      overlayColor: WidgetStateProperty.all<Color?>(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
    );
  }

  ButtonStyle _socialButtonStyle(BuildContext context) {
    final base = TripClipButtonStyles.labelTextStyle(Theme.of(context));
    const fg = TripClipPalette.tertiary500; // #141E46
    const pressedBg = TripClipPalette.neutral100;
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(const Size(48, 44)),
      padding: WidgetStateProperty.all(TripClipButtonStyles.contentPadding),
      textStyle: WidgetStateProperty.all(base),
      shape: WidgetStateProperty.all(const StadiumBorder()),
      elevation: WidgetStateProperty.all(0),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.black.withValues(alpha: 0.06);
        }
        return null;
      }),
      foregroundColor: WidgetStateProperty.all(fg),
      iconColor: WidgetStateProperty.all(fg),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) return pressedBg;
        return Colors.white;
      }),
    );
  }
}

class _LightInputsTheme extends StatelessWidget {
  const _LightInputsTheme({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        brightness: Brightness.light,
        textTheme: theme.textTheme.apply(
          bodyColor: TripClipPalette.tertiary500,
          displayColor: TripClipPalette.tertiary500,
        ),
        // Default icons (email/lock + default eye) are grey; focused/active are navy.
        iconTheme: theme.iconTheme.copyWith(color: TripClipPalette.neutral600),
      ),
      child: child,
    );
  }
}

class _LoginResult {
  const _LoginResult._(this.ok, this.message);

  const _LoginResult.success() : this._(true, null);

  const _LoginResult.failure(this.message) : ok = false;

  final bool ok;
  final String? message;
}
