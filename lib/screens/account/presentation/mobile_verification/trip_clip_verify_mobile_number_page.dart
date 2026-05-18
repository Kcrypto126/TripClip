import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/navigation/trip_clip_navigator.dart';
import '../../../../app/theme/trip_clip_colors.dart';
import '../../../../ui/components/buttons/trip_clip_button.dart';
import '../../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../../ui/components/forms/trip_clip_atom_input.dart';
import '../../../../ui/components/pages/trip_clip_content_page_scaffold.dart';
import '../../../../ui/sheets/trip_clip_selection_sheets.dart';
import 'trip_clip_account_verify_mobile_otp_page.dart';

class TripClipVerifyMobileNumberPage extends StatefulWidget {
  const TripClipVerifyMobileNumberPage({super.key});

  @override
  State<TripClipVerifyMobileNumberPage> createState() =>
      _TripClipVerifyMobileNumberPageState();
}

class _TripClipVerifyMobileNumberPageState
    extends State<TripClipVerifyMobileNumberPage> {
  final _countryDisplay = TextEditingController();
  final _mobileController = TextEditingController();

  final _mobileFocus = FocusNode();

  static const double _fieldGap = 24;
  static const double _labelToField = 8;

  static final List<TextInputFormatter> _mobileFormatters = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-]')),
    LengthLimitingTextInputFormatter(32),
  ];

  @override
  void initState() {
    super.initState();
    _countryDisplay.addListener(_onFormChanged);
    _mobileController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (mounted) setState(() {});
  }

  bool get _formComplete {
    final country = _countryDisplay.text.trim();
    final mobile = _mobileController.text.replaceAll(RegExp(r'\s'), '');
    return country.isNotEmpty && mobile.isNotEmpty;
  }

  Future<void> _pickCountry() async {
    final r = await showTripClipCountrySelectionSheet(
      context,
      selected: _countryDisplay.text.trim().isEmpty
          ? null
          : _countryDisplay.text.trim(),
      searchHint: 'Search countries…',
    );
    if (r != null && mounted) setState(() => _countryDisplay.text = r);
  }

  void _onSendCode() {
    if (!_formComplete) return;
    final raw = _mobileController.text.trim();
    tripClipPushMaterialPage<void>(
      context,
      TripClipAccountVerifyMobileOtpPage(mobileRaw: raw),
      shellNavHighlightTabIndex: TripClipShellNavRoutes.accountTabIndex,
    );
  }

  @override
  void dispose() {
    _countryDisplay.removeListener(_onFormChanged);
    _mobileController.removeListener(_onFormChanged);
    _countryDisplay.dispose();
    _mobileController.dispose();
    _mobileFocus.dispose();
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
      appBarTitle: 'Verify Mobile Number',
      heading: 'Enter your mobile number',
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
          Text('Country', style: labelStyle),
          const SizedBox(height: _labelToField),
          TripClipAtomInput(
            controller: _countryDisplay,
            readOnly: true,
            onTap: _pickCountry,
            hintText: 'Australia',
            leadingIconAsset: 'assets/icons/location.svg',
            trailingIconAsset: 'assets/icons/chevron-down.svg',
          ),
          const SizedBox(height: _fieldGap),
          Text('Mobile Number', style: labelStyle),
          const SizedBox(height: _labelToField),
          TripClipAtomInput(
            controller: _mobileController,
            focusNode: _mobileFocus,
            hintText: '0400 100 200',
            leadingIconAsset: 'assets/icons/phone.svg',
            showTrailing: false,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            inputFormatters: _mobileFormatters,
          ),
        ],
      ),
    );
  }
}
