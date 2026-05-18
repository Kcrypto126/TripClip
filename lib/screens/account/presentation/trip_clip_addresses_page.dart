import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../../ui/components/badges/trip_clip_badge_icon_label.dart';
import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/forms/trip_clip_atom_input.dart';
import '../../../ui/components/forms/trip_clip_form_checkbox.dart';
import '../../../ui/components/forms/trip_clip_form_input.dart';
import '../../../ui/components/forms/trip_clip_form_radio_button.dart';
import '../../../ui/components/pages/trip_clip_content_page_scaffold.dart';
import '../../../ui/maps/trip_clip_address_search_map_preview.dart';
import '../../../ui/sheets/trip_clip_pickup_address_search_sheet.dart';
import '../../../ui/sheets/trip_clip_selection_sheets.dart';

enum _AddressKind { residential, business }

class _AddressRow {
  _AddressRow({
    required this.title,
    required this.detail,
    required this.kind,
    required this.line1,
    required this.line2,
    required this.suburb,
    required this.postcode,
    required this.state,
    required this.country,
  });

  String title;
  String detail;
  _AddressKind kind;
  String line1;
  String line2;
  String suburb;
  String postcode;
  String state;
  String country;
}

class TripClipAddressesPage extends StatefulWidget {
  const TripClipAddressesPage({super.key});

  @override
  State<TripClipAddressesPage> createState() => _TripClipAddressesPageState();
}

class _TripClipAddressesPageState extends State<TripClipAddressesPage> {
  final List<_AddressRow> _rows = [
    _AddressRow(
      title: 'Home',
      detail: '7 Something Street, St Kilda VIC 3182',
      kind: _AddressKind.residential,
      line1: '3 Hanover Street',
      line2: '',
      suburb: 'Fitzroy',
      postcode: '3065',
      state: 'VIC',
      country: 'Australia',
    ),
    _AddressRow(
      title: 'Work',
      detail: '100 Collins Street, Melbourne VIC 3000',
      kind: _AddressKind.business,
      line1: '100 Collins Street',
      line2: '',
      suburb: 'Melbourne',
      postcode: '3000',
      state: 'VIC',
      country: 'Australia',
    ),
    _AddressRow(
      title: 'Holiday House',
      detail: '2 Ocean Road, Lorne VIC 3232',
      kind: _AddressKind.residential,
      line1: '2 Ocean Road',
      line2: '',
      suburb: 'Lorne',
      postcode: '3232',
      state: 'VIC',
      country: 'Australia',
    ),
  ];

  int? _expandedIndex;

  late final TextEditingController _name;
  late final TextEditingController _searchAddr;
  late final TextEditingController _line1;
  late final TextEditingController _line2;
  late final TextEditingController _suburb;
  late final TextEditingController _postcode;
  late final TextEditingController _stateDisplay;
  late final TextEditingController _countryDisplay;

  _AddressKind _editKind = _AddressKind.residential;
  bool _manualEntry = true;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _searchAddr = TextEditingController();
    _line1 = TextEditingController();
    _line2 = TextEditingController();
    _suburb = TextEditingController();
    _postcode = TextEditingController();
    _stateDisplay = TextEditingController();
    _countryDisplay = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _searchAddr.dispose();
    _line1.dispose();
    _line2.dispose();
    _suburb.dispose();
    _postcode.dispose();
    _stateDisplay.dispose();
    _countryDisplay.dispose();
    super.dispose();
  }

  void _syncEditorsFromRow(_AddressRow r) {
    _editKind = r.kind;
    _name.text = r.title;
    _line1.text = r.line1;
    _line2.text = r.line2;
    _suburb.text = r.suburb;
    _postcode.text = r.postcode;
    _stateDisplay.text = r.state;
    _countryDisplay.text = r.country;
    _searchAddr.clear();
    _manualEntry = true;
  }

  void _openEdit(int i) {
    setState(() {
      if (_expandedIndex == i) {
        _expandedIndex = null;
      } else {
        _expandedIndex = i;
        _syncEditorsFromRow(_rows[i]);
      }
    });
  }

  void _cancelEdit() {
    setState(() => _expandedIndex = null);
  }

  void _saveEdit(int i) {
    final r = _rows[i];
    setState(() {
      r.title = _name.text.trim().isEmpty ? r.title : _name.text.trim();
      r.kind = _editKind;
      r.line1 = _line1.text.trim();
      r.line2 = _line2.text.trim();
      r.suburb = _suburb.text.trim();
      r.postcode = _postcode.text.trim();
      r.state = _stateDisplay.text.trim();
      r.country = _countryDisplay.text.trim();
      final line2part = r.line2.isEmpty ? '' : ', ${r.line2}';
      r.detail = '${r.line1}$line2part, ${r.suburb} ${r.state} ${r.postcode}';
      _expandedIndex = null;
    });
  }

  void _addAddress() {
    setState(() {
      _rows.add(
        _AddressRow(
          title: 'New address',
          detail: 'Tap edit to add details',
          kind: _AddressKind.residential,
          line1: '',
          line2: '',
          suburb: '',
          postcode: '',
          state: 'VIC',
          country: 'Australia',
        ),
      );
    });
  }

  Future<void> _pickState() async {
    final r = await showTripClipStateSelectionSheet(
      context,
      selected: _stateDisplay.text.trim().isEmpty
          ? null
          : _stateDisplay.text.trim(),
    );
    if (r != null && mounted) setState(() => _stateDisplay.text = r);
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

  Future<void> _openAddressSearch() async {
    final r = await showTripClipPickupAddressSearchSheet(
      context,
      initialQuery: _searchAddr.text,
    );
    if (r != null && mounted) {
      setState(() => _searchAddr.text = r);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t = Theme.of(context).textTheme;

    final introColor = context.tripClipColors.textBase;
    final introStyle = t.bodyMedium!.copyWith(color: introColor);

    final rowBorder = context.tripClipColors.borderSubtle;
    final labelColor = context.tripClipColors.textBase;
    final labelStyle = t.titleLarge!.copyWith(color: labelColor);
    final contentColor = context.tripClipColors.textBase;
    final contentStyle = t.bodyMedium!.copyWith(color: contentColor);

    final pencilColor = context.tripClipColors.textSubtle;
    final pencilFilter = ColorFilter.mode(pencilColor, BlendMode.srcIn);

    final formBg = isDark
        ? TripClipPalette.neutral900
        : TripClipPalette.neutral100;

    final mapBorder = context.tripClipColors.borderSubtle;

    final toggleTextStyle = t.bodySmall!;

    final fieldLabelColor = context.tripClipColors.textBase;
    final fieldLabelStyle = t.bodySmall!.copyWith(
      fontWeight: FontWeight.w500,
      color: fieldLabelColor,
    );

    return TripClipContentPageScaffold(
      appBarTitle: 'Addresses',
      heading: 'Addresses',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add frequently used pickup and delivery addresses. '
            'Only the suburb and state will appear in your listings.',
            style: introStyle,
          ),
          const SizedBox(height: 40),
          for (var i = 0; i < _rows.length; i++)
            _AddressItem(
              row: _rows[i],
              expanded: _expandedIndex == i,
              rowBorder: rowBorder,
              labelStyle: labelStyle,
              contentStyle: contentStyle,
              pencilFilter: pencilFilter,
              formBg: formBg,
              mapBorder: mapBorder,
              toggleTextStyle: toggleTextStyle,
              fieldLabelStyle: fieldLabelStyle,
              editKind: _editKind,
              onKindChanged: (k) => setState(() => _editKind = k),
              manualEntry: _manualEntry,
              onManualChanged: (v) => setState(() => _manualEntry = v),
              name: _name,
              searchAddr: _searchAddr,
              line1: _line1,
              line2: _line2,
              suburb: _suburb,
              postcode: _postcode,
              stateDisplay: _stateDisplay,
              countryDisplay: _countryDisplay,
              onEdit: () => _openEdit(i),
              editForm: _expandedIndex == i
                  ? _AddressEditFormActions(
                      onCancel: _cancelEdit,
                      onSave: () => _saveEdit(i),
                    )
                  : null,
              onPickState: _pickState,
              onPickCountry: _pickCountry,
              onOpenAddressSearch: _openAddressSearch,
            ),
          const SizedBox(height: 24),
          TripClipButton(
            variant: TripClipButtonVariant.primary,
            expanded: false,
            label: 'Add Address',
            onPressed: _addAddress,
          ),
        ],
      ),
    );
  }
}

class _AddressEditFormActions extends StatelessWidget {
  const _AddressEditFormActions({required this.onCancel, required this.onSave});

  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TripClipButton(
          variant: TripClipButtonVariant.tertiary,
          label: 'Cancel',
          onPressed: onCancel,
        ),
        TripClipButton(
          variant: TripClipButtonVariant.primary,
          label: 'Save',
          onPressed: onSave,
        ),
      ],
    );
  }
}

class _AddressItem extends StatelessWidget {
  const _AddressItem({
    required this.row,
    required this.expanded,
    required this.rowBorder,
    required this.labelStyle,
    required this.contentStyle,
    required this.pencilFilter,
    required this.formBg,
    required this.mapBorder,
    required this.toggleTextStyle,
    required this.fieldLabelStyle,
    required this.editKind,
    required this.onKindChanged,
    required this.manualEntry,
    required this.onManualChanged,
    required this.name,
    required this.searchAddr,
    required this.line1,
    required this.line2,
    required this.suburb,
    required this.postcode,
    required this.stateDisplay,
    required this.countryDisplay,
    required this.onEdit,
    required this.editForm,
    required this.onPickState,
    required this.onPickCountry,
    required this.onOpenAddressSearch,
  });

  final _AddressRow row;
  final bool expanded;
  final Color rowBorder;
  final TextStyle labelStyle;
  final TextStyle contentStyle;
  final ColorFilter pencilFilter;
  final Color formBg;
  final Color mapBorder;
  final TextStyle toggleTextStyle;
  final TextStyle fieldLabelStyle;
  final _AddressKind editKind;
  final ValueChanged<_AddressKind> onKindChanged;
  final bool manualEntry;
  final ValueChanged<bool> onManualChanged;
  final TextEditingController name;
  final TextEditingController searchAddr;
  final TextEditingController line1;
  final TextEditingController line2;
  final TextEditingController suburb;
  final TextEditingController postcode;
  final TextEditingController stateDisplay;
  final TextEditingController countryDisplay;
  final VoidCallback onEdit;
  final Widget? editForm;
  final Future<void> Function() onPickState;
  final Future<void> Function() onPickCountry;
  final Future<void> Function() onOpenAddressSearch;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mapFill = isDark
        ? TripClipPalette.neutral900
        : TripClipPalette.neutral100;
    final hasForm = editForm != null;
    final badgeAsset = row.kind == _AddressKind.residential
        ? 'assets/icons/house.svg'
        : 'assets/icons/apartment.svg';
    final badgeLabel = row.kind == _AddressKind.residential
        ? 'Residential'
        : 'Business';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, hasForm ? 0 : 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(row.title, style: labelStyle),
                    const SizedBox(height: 4),
                    Text(row.detail, style: contentStyle),
                    const SizedBox(height: 4),
                    TripClipBadgeIconLabel(
                      label: badgeLabel,
                      svgAsset: badgeAsset,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onEdit,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                icon: SvgPicture.asset(
                  'assets/icons/pencil-edit.svg',
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  colorFilter: pencilFilter,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          clipBehavior: Clip.hardEdge,
          child: hasForm
              ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: formBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TripClipFormInput(
                                label: 'Name',
                                controller: name,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: TripClipFormRadioButton(
                                      width: double.infinity,
                                      selected:
                                          editKind == _AddressKind.business,
                                      onPressed: () =>
                                          onKindChanged(_AddressKind.business),
                                      label: 'Business',
                                      iconAsset: 'assets/icons/apartment.svg',
                                      radius: 4,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      iconSize: 24,
                                      gap: 4,
                                      textStyle: toggleTextStyle,
                                      contentAlignment:
                                          MainAxisAlignment.center,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TripClipFormRadioButton(
                                      width: double.infinity,
                                      selected:
                                          editKind == _AddressKind.residential,
                                      onPressed: () => onKindChanged(
                                        _AddressKind.residential,
                                      ),
                                      label: 'Residential',
                                      iconAsset: 'assets/icons/house.svg',
                                      radius: 4,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      iconSize: 24,
                                      gap: 4,
                                      textStyle: toggleTextStyle,
                                      contentAlignment:
                                          MainAxisAlignment.center,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TripClipAddressSearchMapPreview(
                                addressLine: searchAddr.text,
                                border: mapBorder,
                                fill: mapFill,
                              ),
                              const SizedBox(height: 16),
                              TripClipAtomInput(
                                controller: searchAddr,
                                hintText: 'Search for an address',
                                leadingIconAsset: 'assets/icons/search.svg',
                                readOnly: true,
                                onTap: () {
                                  onOpenAddressSearch();
                                },
                                showTrailing: false,
                              ),
                              const SizedBox(height: 16),
                              TripClipFormCheckbox(
                                value: manualEntry,
                                onChanged: onManualChanged,
                                label: 'Enter address manually',
                              ),
                              if (manualEntry) ...[
                                const SizedBox(height: 8),
                                TripClipFormInput(
                                  label: 'Address Line 1',
                                  controller: line1,
                                ),
                                const SizedBox(height: 16),
                                TripClipFormInput(
                                  label: 'Address Line 2',
                                  controller: line2,
                                  hintText:
                                      'Apartment, Suite, Unit number, etc',
                                ),
                                const SizedBox(height: 16),
                                TripClipFormInput(
                                  label: 'Suburb',
                                  controller: suburb,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('State', style: fieldLabelStyle),
                                          const SizedBox(height: 8),
                                          TripClipAtomInput(
                                            controller: stateDisplay,
                                            readOnly: true,
                                            onTap: () {
                                              onPickState();
                                            },
                                            showLeading: false,
                                            trailingIconAsset:
                                                'assets/icons/chevron-down.svg',
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TripClipFormInput(
                                        label: 'Postcode',
                                        controller: postcode,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Text('Country', style: fieldLabelStyle),
                                const SizedBox(height: 8),
                                TripClipAtomInput(
                                  controller: countryDisplay,
                                  readOnly: true,
                                  onTap: () {
                                    onPickCountry();
                                  },
                                  showLeading: false,
                                  trailingIconAsset:
                                      'assets/icons/chevron-down.svg',
                                ),
                              ],
                              const SizedBox(height: 24),
                              editForm!,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
        Divider(height: 1, thickness: 1, color: rowBorder),
      ],
    );
  }
}
