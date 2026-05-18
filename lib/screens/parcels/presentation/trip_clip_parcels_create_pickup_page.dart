import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/forms/trip_clip_atom_input.dart';
import '../../../ui/components/forms/trip_clip_form_checkbox.dart';
import '../../../ui/components/forms/trip_clip_form_input.dart';
import '../../../ui/components/forms/trip_clip_form_radio_button.dart';
import '../../../ui/components/forms/trip_clip_form_textarea.dart';
import '../../../ui/components/pages/trip_clip_stepped_title_page_scaffold.dart';
import '../../../ui/maps/trip_clip_address_search_map_preview.dart';
import '../../../ui/sheets/trip_clip_pickup_address_search_sheet.dart';
import '../../../ui/sheets/trip_clip_pickup_date_range_sheet.dart';
import '../../../ui/sheets/trip_clip_pickup_time_range_sheet.dart';
import '../../../ui/sheets/trip_clip_selection_sheets.dart';
import 'trip_clip_parcels_create_delivery_page.dart';
import 'trip_clip_parcels_create_models.dart';
import 'trip_clip_parcels_create_scope.dart';

class TripClipParcelsCreatePickupPage extends StatefulWidget {
  const TripClipParcelsCreatePickupPage({super.key});

  static const int totalSteps = 7;

  @override
  State<TripClipParcelsCreatePickupPage> createState() =>
      _TripClipParcelsCreatePickupPageState();
}

class _TripClipParcelsCreatePickupPageState
    extends State<TripClipParcelsCreatePickupPage> {
  static const int _stepIndex = 1;

  static const double _chipSpacing = 8;

  static const List<String> _kDateOptions = [
    'Flexible',
    'Today',
    'Tomorrow',
    'This Week',
    'Next Week',
    'Date Range',
  ];

  static const List<String> _kTimeOptions = [
    'Flexible',
    'Morning',
    'Afternoon',
    'Evening',
    'By a time...',
    'Time Range',
  ];

  static const int _kIndexDateRange = 5;
  static const int _kIndexTimeRange = 5;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _line1 = TextEditingController();
  final TextEditingController _line2 = TextEditingController();
  final TextEditingController _suburb = TextEditingController();
  final TextEditingController _postcode = TextEditingController();
  final TextEditingController _stateDisplay = TextEditingController(
    text: 'VIC',
  );
  final TextEditingController _countryDisplay = TextEditingController(
    text: 'Australia',
  );
  final TextEditingController _notesController = TextEditingController();

  ParcelsAddressKind _addressKind = ParcelsAddressKind.residential;
  bool _manualEntry = false;

  int _dateSelection = 0;
  int _timeSelection = 0;
  bool _seededFromDraft = false;

  DateTimeRange? _pickupDateRange;
  TripClipTimeRange? _pickupTimeRange;

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    for (final c in [
      _searchController,
      _line1,
      _line2,
      _suburb,
      _postcode,
      _stateDisplay,
      _countryDisplay,
      _notesController,
    ]) {
      c.addListener(_onFieldChanged);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seededFromDraft) return;
    final scope = TripClipParcelsCreateScope.maybeOf(context);
    if (scope == null) return;
    _seededFromDraft = true;
    final p = scope.draft.pickup;
    setState(() {
      _addressKind = p.kind;
      _manualEntry = p.manualEntry;
      _searchController.text = p.searchQuery;
      _line1.text = p.line1;
      _line2.text = p.line2;
      _suburb.text = p.suburb;
      _postcode.text = p.postcode;
      _stateDisplay.text = p.state;
      _countryDisplay.text = p.country;
      _notesController.text = p.notes;
      _dateSelection = p.dateOptionIndex;
      _timeSelection = p.timeOptionIndex;
      _pickupDateRange = p.dateRange;
      _pickupTimeRange = p.timeRange;
    });
  }

  @override
  void dispose() {
    for (final c in [
      _searchController,
      _line1,
      _line2,
      _suburb,
      _postcode,
      _stateDisplay,
      _countryDisplay,
      _notesController,
    ]) {
      c.removeListener(_onFieldChanged);
    }
    _searchController.dispose();
    _line1.dispose();
    _line2.dispose();
    _suburb.dispose();
    _postcode.dispose();
    _stateDisplay.dispose();
    _countryDisplay.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get _returnToSummary {
    final a = ModalRoute.of(context)?.settings.arguments;
    return a is ParcelsCreatePageArgs && a.returnToSummary;
  }

  ParcelsAddressDraft _buildPickupDraft() {
    return ParcelsAddressDraft(
      kind: _addressKind,
      searchQuery: _searchController.text,
      manualEntry: _manualEntry,
      line1: _line1.text,
      line2: _line2.text,
      suburb: _suburb.text,
      postcode: _postcode.text,
      state: _stateDisplay.text,
      country: _countryDisplay.text,
      notes: _notesController.text,
      dateOptionIndex: _dateSelection,
      timeOptionIndex: _timeSelection,
      dateRange: _pickupDateRange,
      timeRange: _pickupTimeRange,
    );
  }

  bool get _canContinue {
    if (!_manualEntry) {
      if (_searchController.text.trim().isEmpty) return false;
    } else {
      if (_line1.text.trim().isEmpty) return false;
      if (_suburb.text.trim().isEmpty) return false;
      if (_postcode.text.trim().isEmpty) return false;
      if (_stateDisplay.text.trim().isEmpty) return false;
      if (_countryDisplay.text.trim().isEmpty) return false;
    }
    if (_dateSelection == ParcelsAddressDraft.kIndexDateRange &&
        _pickupDateRange == null) {
      return false;
    }
    if (_timeSelection == ParcelsAddressDraft.kIndexTimeRange &&
        _pickupTimeRange == null) {
      return false;
    }
    return true;
  }

  Future<void> _openAddressSearch() async {
    final r = await showTripClipPickupAddressSearchSheet(
      context,
      initialQuery: _searchController.text,
    );
    if (r != null && mounted) {
      setState(() => _searchController.text = r);
    }
  }

  Future<void> _pickState() async {
    final result = await showTripClipStateSelectionSheet(
      context,
      selected: _stateDisplay.text.trim().isEmpty
          ? null
          : _stateDisplay.text.trim(),
    );
    if (result != null && mounted) {
      setState(() => _stateDisplay.text = result);
    }
  }

  Future<void> _pickCountry() async {
    final result = await showTripClipCountrySelectionSheet(
      context,
      selected: _countryDisplay.text.trim().isEmpty
          ? null
          : _countryDisplay.text.trim(),
      searchHint: 'Search countries…',
    );
    if (result != null && mounted) {
      setState(() => _countryDisplay.text = result);
    }
  }

  Future<void> _openDateRangeSheet() async {
    final r = await showTripClipPickupDateRangeSheet(
      context,
      initialRange: _pickupDateRange,
    );
    if (r == null || !mounted) return;
    setState(() {
      _pickupDateRange = r;
      _dateSelection = _kIndexDateRange;
    });
  }

  Future<void> _openTimeRangeSheet() async {
    final r = await showTripClipPickupTimeRangeSheet(
      context,
      initialRange: _pickupTimeRange,
    );
    if (r == null || !mounted) return;
    setState(() {
      _pickupTimeRange = r;
      _timeSelection = _kIndexTimeRange;
    });
  }

  TextStyle _sectionHeadingStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: context.tripClipColors.textBase,
        );
  }

  TextStyle _linkStyle(BuildContext context) {
    final h = context.tripClipColors.heading;
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          color: h,
          decoration: TextDecoration.underline,
          decorationColor: h,
        );
  }

  Widget _iconSectionTitle(
    BuildContext context, {
    required String svgAsset,
    required String title,
    Widget? trailing,
  }) {
    final iconColor = context.tripClipColors.textSubtle;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          svgAsset,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(title, style: _sectionHeadingStyle(context)),
        ),
        ?trailing,
      ],
    );
  }

  Widget _dateTimeOptionGrid({
    required List<String> labels,
    required int selectedIndex,
    required ValueChanged<int> onChanged,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const cols = 3;
        final w =
            (constraints.maxWidth - (cols - 1) * _chipSpacing) / cols;
        return Wrap(
          spacing: _chipSpacing,
          runSpacing: _chipSpacing,
          children: List.generate(labels.length, (i) {
            return SizedBox(
              width: w,
              child: TripClipFormRadioButton(
                width: w,
                selected: selectedIndex == i,
                onPressed: () => onChanged(i),
                label: labels[i],
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              ),
            );
          }),
        );
      },
    );
  }

  void _goNext() {
    if (!_canContinue) return;
    TripClipParcelsCreateScope.of(context).setPickup(_buildPickupDraft());
    if (_returnToSummary) {
      Navigator.of(context).pop();
      return;
    }
    pushTripClipParcelsCreateRoute<void>(
      context,
      const TripClipParcelsCreateDeliveryPage(),
    );
  }

  String _formatPickupDateRange(DateTimeRange r) {
    final a = r.start;
    final b = r.end;
    String d(DateTime x) => '${x.day.toString().padLeft(2, '0')}/'
        '${x.month.toString().padLeft(2, '0')}/'
        '${x.year}';
    if (a.year == b.year && a.month == b.month && a.day == b.day) {
      return d(a);
    }
    return '${d(a)} – ${d(b)}';
  }

  String _formatPickupTimeRange(TripClipTimeRange r) {
    final l = MaterialLocalizations.of(context);
    final is24h = MediaQuery.of(context).alwaysUse24HourFormat;
    final a = l.formatTimeOfDay(r.start, alwaysUse24HourFormat: is24h);
    final b = l.formatTimeOfDay(r.end, alwaysUse24HourFormat: is24h);
    return '$a – $b';
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mapFill = isDark
        ? TripClipPalette.neutral900
        : TripClipPalette.neutral100;
    final mapBorder = context.tripClipColors.borderSubtle;
    final toggleTextStyle = t.bodySmall!;

    final helperStyle = t.bodySmall!.copyWith(
      color: context.tripClipColors.textSubtle,
    );
    final fieldLabelStyle = t.bodySmall!.copyWith(
      fontWeight: FontWeight.w500,
      color: context.tripClipColors.textBase,
    );

    return TripClipSteppedTitlePageScaffold(
      currentStep: _stepIndex,
      totalSteps: TripClipParcelsCreatePickupPage.totalSteps,
      title: 'Pickup',
      onStepChanged: (next) {
        if (next < _stepIndex) {
          Navigator.of(context).maybePop();
        }
      },
      onExitAtFirstStep: () => Navigator.of(context).maybePop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _iconSectionTitle(
            context,
            svgAsset: 'assets/icons/location.svg',
            title: 'Pickup Address',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TripClipFormRadioButton(
                  width: double.infinity,
                  selected: _addressKind == ParcelsAddressKind.business,
                  onPressed: () => setState(
                    () => _addressKind = ParcelsAddressKind.business,
                  ),
                  label: 'Business',
                  iconAsset: 'assets/icons/apartment.svg',
                  radius: 4,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  iconSize: 24,
                  gap: 4,
                  textStyle: toggleTextStyle,
                  contentAlignment: MainAxisAlignment.center,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TripClipFormRadioButton(
                  width: double.infinity,
                  selected: _addressKind == ParcelsAddressKind.residential,
                  onPressed: () => setState(
                    () => _addressKind = ParcelsAddressKind.residential,
                  ),
                  label: 'Residential',
                  iconAsset: 'assets/icons/house.svg',
                  radius: 4,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  iconSize: 24,
                  gap: 4,
                  textStyle: toggleTextStyle,
                  contentAlignment: MainAxisAlignment.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TripClipAddressSearchMapPreview(
            addressLine: _searchController.text,
            border: mapBorder,
            fill: mapFill,
          ),
          const SizedBox(height: 16),
          TripClipAtomInput(
            controller: _searchController,
            hintText: 'Search for an address',
            leadingIconAsset: 'assets/icons/search.svg',
            readOnly: true,
            onTap: () {
              _openAddressSearch();
            },
            showTrailing: false,
          ),
          const SizedBox(height: 8),
          Text(
            'Only the suburb and state will be displayed in the listing',
            style: helperStyle,
          ),
          const SizedBox(height: 16),
          TripClipFormCheckbox(
            value: _manualEntry,
            onChanged: (v) => setState(() => _manualEntry = v),
            label: 'Enter address manually',
          ),
          if (_manualEntry) ...[
            const SizedBox(height: 16),
            TripClipFormInput(
              label: 'Address Line 1',
              controller: _line1,
            ),
            const SizedBox(height: 16),
            TripClipFormInput(
              label: 'Address Line 2',
              controller: _line2,
              hintText: 'Apartment, Suite, Unit number, etc',
            ),
            const SizedBox(height: 16),
            TripClipFormInput(
              label: 'Suburb',
              controller: _suburb,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('State', style: fieldLabelStyle),
                      const SizedBox(height: 8),
                      TripClipAtomInput(
                        controller: _stateDisplay,
                        readOnly: true,
                        onTap: () {
                          _pickState();
                        },
                        showLeading: false,
                        trailingIconAsset: 'assets/icons/chevron-down.svg',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TripClipFormInput(
                    label: 'Postcode',
                    controller: _postcode,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Country', style: fieldLabelStyle),
            const SizedBox(height: 8),
            TripClipAtomInput(
              controller: _countryDisplay,
              readOnly: true,
              onTap: () {
                _pickCountry();
              },
              showLeading: false,
              trailingIconAsset: 'assets/icons/chevron-down.svg',
            ),
          ],
          const SizedBox(height: 40),
          Text(
            'Notes',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.tripClipColors.textBase,
                ),
          ),
          const SizedBox(height: 8),
          TripClipFormTextarea(
            controller: _notesController,
            hintText: 'Enter details about the pickup address',
            fieldHeight: 112,
            minLines: 1,
            maxLength: 600,
          ),
          const SizedBox(height: 4),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _notesController,
            builder: (context, value, _) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${value.text.length}/600',
                  style: helperStyle,
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          _iconSectionTitle(
            context,
            svgAsset: 'assets/icons/calendar.svg',
            title: 'Pickup Date',
            trailing: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text('Date Guide', style: _linkStyle(context)),
            ),
          ),
          const SizedBox(height: 16),
          _dateTimeOptionGrid(
            labels: _kDateOptions,
            selectedIndex: _dateSelection,
            onChanged: (i) {
              setState(() => _dateSelection = i);
              if (i == _kIndexDateRange) {
                _openDateRangeSheet();
              }
            },
          ),
          if (_dateSelection == _kIndexDateRange &&
              _pickupDateRange != null) ...[
            const SizedBox(height: 8),
            Text(
              _formatPickupDateRange(_pickupDateRange!),
              style: helperStyle,
            ),
          ],
          const SizedBox(height: 40),
          _iconSectionTitle(
            context,
            svgAsset: 'assets/icons/clock.svg',
            title: 'Pickup Time',
            trailing: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text('Time Guide', style: _linkStyle(context)),
            ),
          ),
          const SizedBox(height: 16),
          _dateTimeOptionGrid(
            labels: _kTimeOptions,
            selectedIndex: _timeSelection,
            onChanged: (i) {
              setState(() => _timeSelection = i);
              if (i == _kIndexTimeRange) {
                _openTimeRangeSheet();
              } else {
                _pickupTimeRange = null;
              }
            },
          ),
          if (_timeSelection == _kIndexTimeRange && _pickupTimeRange != null) ...[
            const SizedBox(height: 8),
            Text(
              _formatPickupTimeRange(_pickupTimeRange!),
              style: helperStyle,
            ),
          ],
        ],
      ),
      bottomBar: SafeArea(
        top: false,
        minimum: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: TripClipButton(
            variant: TripClipButtonVariant.primary,
            expanded: true,
            label: _returnToSummary ? 'Summary' : 'Delivery Details',
            iconPlacement: TripClipButtonIconPlacement.trailing,
            svgAsset: 'assets/icons/chevron-right.svg',
            onPressed: _canContinue ? _goNext : null,
          ),
        ),
      ),
    );
  }
}
