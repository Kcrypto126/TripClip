import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/forms/trip_clip_atom_input.dart';
import '../../../ui/components/forms/trip_clip_form_message.dart';
import '../../../ui/components/forms/trip_clip_form_models.dart';
import '../../../ui/components/pages/trip_clip_stepped_title_page_scaffold.dart';
import 'trip_clip_parcels_create_items_page.dart';
import 'trip_clip_parcels_create_models.dart';
import 'trip_clip_parcels_create_scope.dart';

class TripClipParcelsCreateRecipientPage extends StatefulWidget {
  const TripClipParcelsCreateRecipientPage({super.key});

  static const int totalSteps = 7;

  @override
  State<TripClipParcelsCreateRecipientPage> createState() =>
      _TripClipParcelsCreateRecipientPageState();
}

class _TripClipParcelsCreateRecipientPageState
    extends State<TripClipParcelsCreateRecipientPage> {
  static const int _stepIndex = 3;

  static final RegExp _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobile = TextEditingController();

  TripClipFormStatus _nameStatus = TripClipFormStatus.none;
  TripClipFormStatus _emailStatus = TripClipFormStatus.none;
  TripClipFormStatus _mobileStatus = TripClipFormStatus.none;

  String? _nameError;
  String? _emailError;
  String? _mobileError;
  bool _seededFromDraft = false;

  bool get _returnToSummary {
    final a = ModalRoute.of(context)?.settings.arguments;
    return a is ParcelsCreatePageArgs && a.returnToSummary;
  }

  @override
  void initState() {
    super.initState();
    _name.addListener(_onNameChanged);
    _email.addListener(_onEmailChanged);
    _mobile.addListener(_onMobileChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seededFromDraft) return;
    final scope = TripClipParcelsCreateScope.maybeOf(context);
    if (scope == null) return;
    _seededFromDraft = true;
    final r = scope.draft.recipient;
    if (r.name.isNotEmpty) _name.text = r.name;
    if (r.email.isNotEmpty) _email.text = r.email;
    if (r.mobile.isNotEmpty) _mobile.text = r.mobile;
  }

  @override
  void dispose() {
    _name.removeListener(_onNameChanged);
    _email.removeListener(_onEmailChanged);
    _mobile.removeListener(_onMobileChanged);
    _name.dispose();
    _email.dispose();
    _mobile.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _name.text.trim().isNotEmpty &&
      _email.text.trim().isNotEmpty &&
      _mobile.text.trim().isNotEmpty;

  bool _validateName(String value) => value.trim().isNotEmpty;
  bool _validateEmail(String value) => _emailRegex.hasMatch(value.trim());

  bool _validateMobile(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 10;
  }

  void _onNameChanged() {
    if (_nameStatus == TripClipFormStatus.none && _nameError == null) return;
    setState(() {
      _nameStatus = TripClipFormStatus.none;
      _nameError = null;
    });
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

  void _goNext() {
    final nameOk = _validateName(_name.text);
    final emailOk = _validateEmail(_email.text);
    final mobileOk = _validateMobile(_mobile.text);

    setState(() {
      _nameStatus = nameOk ? TripClipFormStatus.success : TripClipFormStatus.error;
      _emailStatus =
          emailOk ? TripClipFormStatus.success : TripClipFormStatus.error;
      _mobileStatus =
          mobileOk ? TripClipFormStatus.success : TripClipFormStatus.error;

      _nameError = nameOk ? null : 'Please enter a name.';
      _emailError = emailOk ? null : 'Please enter a valid email address.';
      _mobileError =
          mobileOk ? null : 'Please enter a valid mobile number (at least 10 digits).';
    });

    if (!nameOk || !emailOk || !mobileOk) return;

    TripClipParcelsCreateScope.of(context).setRecipient(
      ParcelsRecipientDraft(
        name: _name.text.trim(),
        email: _email.text.trim(),
        mobile: _mobile.text.trim(),
      ),
    );
    if (_returnToSummary) {
      Navigator.of(context).pop();
      return;
    }
    pushTripClipParcelsCreateRoute<void>(
      context,
      const TripClipParcelsCreateItemsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    final introStyle = t.bodyMedium!.copyWith(
      color: context.tripClipColors.textBase,
    );
    final labelStyle = t.bodySmall!.copyWith(
      fontWeight: FontWeight.w500,
      color: context.tripClipColors.textBase,
    );

    return TripClipSteppedTitlePageScaffold(
      currentStep: _stepIndex,
      totalSteps: TripClipParcelsCreateRecipientPage.totalSteps,
      title: 'Recipient',
      onStepChanged: (next) {
        if (next < _stepIndex) {
          Navigator.of(context).maybePop();
        }
      },
      onExitAtFirstStep: () => Navigator.of(context).maybePop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "We'll use these details to send delivery updates\nto the recipient.",
            style: introStyle,
          ),
          const SizedBox(height: 24),
          Text('Name', style: labelStyle),
          const SizedBox(height: 8),
          TripClipAtomInput(
            controller: _name,
            hintText: 'Eg. John Smith',
            leadingIconAsset: 'assets/icons/user1.svg',
            showLeading: true,
            showTrailing: true,
            hideTrailingWhenStatusNone: true,
            status: _nameStatus,
            textInputAction: TextInputAction.next,
          ),
          ..._errorMessageBelowField(status: _nameStatus, errorText: _nameError),
          const SizedBox(height: 16),
          Text('Email', style: labelStyle),
          const SizedBox(height: 8),
          TripClipAtomInput(
            controller: _email,
            hintText: 'Eg. john.smith@example.com',
            leadingIconAsset: 'assets/icons/email.svg',
            showLeading: true,
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
          const SizedBox(height: 16),
          Text('Mobile', style: labelStyle),
          const SizedBox(height: 8),
          TripClipAtomInput(
            controller: _mobile,
            hintText: 'Eg. 0408 123 456',
            leadingIconAsset: 'assets/icons/phone.svg',
            showLeading: true,
            showTrailing: true,
            hideTrailingWhenStatusNone: true,
            status: _mobileStatus,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
          ),
          ..._errorMessageBelowField(
            status: _mobileStatus,
            errorText: _mobileError,
          ),
        ],
      ),
      bottomBar: SafeArea(
        top: false,
        minimum: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: AnimatedBuilder(
            animation: Listenable.merge([_name, _email, _mobile]),
            builder: (context, _) {
              return TripClipButton(
                variant: TripClipButtonVariant.primary,
                expanded: true,
                label: _returnToSummary ? 'Summary' : 'Items',
                iconPlacement: TripClipButtonIconPlacement.trailing,
                svgAsset: 'assets/icons/chevron-right.svg',
                onPressed: _canContinue ? _goNext : null,
              );
            },
          ),
        ),
      ),
    );
  }
}

