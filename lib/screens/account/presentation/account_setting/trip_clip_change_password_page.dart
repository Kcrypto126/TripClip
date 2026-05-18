import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/trip_clip_colors.dart';
import '../../../../ui/components/app_toast.dart';
import '../../../../ui/components/buttons/trip_clip_button.dart';
import '../../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../../ui/components/forms/trip_clip_atom_input.dart';
import '../../../../ui/components/forms/trip_clip_form_message.dart';
import '../../../../ui/components/forms/trip_clip_form_models.dart';
import '../../../../ui/components/forms/trip_clip_password_visibility_toggle.dart';
import '../../../../ui/components/pages/trip_clip_content_page_scaffold.dart';

class TripClipChangePasswordPage extends StatefulWidget {
  const TripClipChangePasswordPage({super.key});

  @override
  State<TripClipChangePasswordPage> createState() =>
      _TripClipChangePasswordPageState();
}

class _TripClipChangePasswordPageState
    extends State<TripClipChangePasswordPage> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  final _currentFocus = FocusNode();
  final _newFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  TripClipFormStatus _currentStatus = TripClipFormStatus.none;
  TripClipFormStatus _newStatus = TripClipFormStatus.none;
  TripClipFormStatus _confirmStatus = TripClipFormStatus.none;

  String? _currentError;
  String? _newError;
  String? _confirmError;

  static const double _fieldGap = 24;
  static const double _labelToField = 8;

  static final List<TextInputFormatter> _passwordInputFormatters = [
    LengthLimitingTextInputFormatter(128),
  ];

  @override
  void initState() {
    super.initState();
    _currentController.addListener(_onCurrentChanged);
    _newController.addListener(_onNewChanged);
    _confirmController.addListener(_onConfirmChanged);
  }

  void _onCurrentChanged() {
    if (_currentStatus == TripClipFormStatus.none && _currentError == null) {
      return;
    }
    setState(() {
      _currentStatus = TripClipFormStatus.none;
      _currentError = null;
    });
  }

  void _onNewChanged() {
    final newClear = _newStatus != TripClipFormStatus.none || _newError != null;
    final confirmClear =
        _confirmStatus != TripClipFormStatus.none || _confirmError != null;
    if (!newClear && !confirmClear) return;
    setState(() {
      if (newClear) {
        _newStatus = TripClipFormStatus.none;
        _newError = null;
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

  bool _validatePassword(String value) => value.trim().length >= 8;

  bool _validateCurrent(String value) => value.trim().isNotEmpty;

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
      ),
    ];
  }

  Widget _passwordLengthHint(BuildContext context) {
    final color = context.tripClipColors.textSubtle;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        'Must be at least 8 characters',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: color),
      ),
    );
  }

  void _onSavePressed() {
    final current = _currentController.text;
    final password = _newController.text;
    final confirm = _confirmController.text;

    final currentOk = _validateCurrent(current);
    final passwordOk = _validatePassword(password);
    final confirmErr = _confirmValidationError(password, confirm);
    final confirmOk = confirmErr == null;

    setState(() {
      _currentStatus = currentOk
          ? TripClipFormStatus.success
          : TripClipFormStatus.error;
      _newStatus = passwordOk
          ? TripClipFormStatus.success
          : TripClipFormStatus.error;
      _confirmStatus = confirmOk
          ? TripClipFormStatus.success
          : TripClipFormStatus.error;

      _currentError = currentOk ? null : 'Please enter your current password.';
      _newError = passwordOk ? null : 'Password must be at least 8 characters.';
      _confirmError = confirmOk ? null : confirmErr;
    });

    if (!currentOk || !passwordOk || !confirmOk) return;

    AppToast.show(
      context,
      message: 'Password saved.',
      kind: AppToastKind.success,
    );
    Navigator.of(context).maybePop();
  }

  @override
  void dispose() {
    _currentController.removeListener(_onCurrentChanged);
    _newController.removeListener(_onNewChanged);
    _confirmController.removeListener(_onConfirmChanged);
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    _currentFocus.dispose();
    _newFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w500,
          color: context.tripClipColors.textBase,
        );

    return TripClipContentPageScaffold(
      appBarTitle: 'Password',
      heading: 'Password',
      bottomBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: TripClipButton(
          variant: TripClipButtonVariant.primary,
          label: 'Save password',
          expanded: true,
          onPressed: _onSavePressed,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text('Current password', style: labelStyle),
          const SizedBox(height: _labelToField),
          TripClipAtomInput(
            controller: _currentController,
            focusNode: _currentFocus,
            hintText: 'Enter current password',
            leadingIconAsset: 'assets/icons/secure-lock.svg',
            showTrailing: true,
            status: _currentStatus,
            trailing: _currentStatus == TripClipFormStatus.success
                ? null
                : TripClipPasswordVisibilityToggle(
                    shown: _showCurrentPassword,
                    focused: _currentFocus.hasFocus,
                    hasValue: _currentController.text.isNotEmpty,
                    status: _currentStatus,
                    onPressed: () => setState(
                      () => _showCurrentPassword = !_showCurrentPassword,
                    ),
                  ),
            obscureText: !_showCurrentPassword,
            textInputAction: TextInputAction.next,
            inputFormatters: _passwordInputFormatters,
          ),
          ..._errorMessageBelowField(
            status: _currentStatus,
            errorText: _currentError,
          ),
          const SizedBox(height: _fieldGap),
          Text('Create new password', style: labelStyle),
          const SizedBox(height: _labelToField),
          TripClipAtomInput(
            controller: _newController,
            focusNode: _newFocus,
            hintText: 'Create new password',
            leadingIconAsset: 'assets/icons/secure-lock.svg',
            showTrailing: true,
            status: _newStatus,
            trailing: _newStatus == TripClipFormStatus.success
                ? null
                : TripClipPasswordVisibilityToggle(
                    shown: _showNewPassword,
                    focused: _newFocus.hasFocus,
                    hasValue: _newController.text.isNotEmpty,
                    status: _newStatus,
                    onPressed: () =>
                        setState(() => _showNewPassword = !_showNewPassword),
                  ),
            obscureText: !_showNewPassword,
            textInputAction: TextInputAction.next,
            inputFormatters: _passwordInputFormatters,
          ),
          if (_newStatus == TripClipFormStatus.none && _newError == null)
            _passwordLengthHint(context),
          ..._errorMessageBelowField(status: _newStatus, errorText: _newError),
          const SizedBox(height: _fieldGap),
          Text('Confirm new password', style: labelStyle),
          const SizedBox(height: _labelToField),
          TripClipAtomInput(
            controller: _confirmController,
            focusNode: _confirmFocus,
            hintText: 'Confirm new password',
            leadingIconAsset: 'assets/icons/secure-lock.svg',
            showTrailing: true,
            status: _confirmStatus,
            trailing: _confirmStatus == TripClipFormStatus.success
                ? null
                : TripClipPasswordVisibilityToggle(
                    shown: _showConfirmPassword,
                    focused: _confirmFocus.hasFocus,
                    hasValue: _confirmController.text.isNotEmpty,
                    status: _confirmStatus,
                    onPressed: () => setState(
                      () => _showConfirmPassword = !_showConfirmPassword,
                    ),
                  ),
            obscureText: !_showConfirmPassword,
            textInputAction: TextInputAction.done,
            inputFormatters: _passwordInputFormatters,
          ),
          ..._errorMessageBelowField(
            status: _confirmStatus,
            errorText: _confirmError,
          ),
        ],
      ),
    );
  }
}
