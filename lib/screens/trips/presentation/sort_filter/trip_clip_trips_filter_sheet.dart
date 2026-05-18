import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/trip_clip_colors.dart';
import '../../../../ui/components/buttons/trip_clip_button.dart';
import '../../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../../ui/components/forms/trip_clip_atom_input.dart';
import '../../../../ui/components/forms/trip_clip_form_radio_button.dart';
import '../../../../ui/components/forms/trip_clip_form_slider.dart';
import '../../../../ui/sheets/trip_clip_modal_sheet.dart';
import '../../../../ui/sheets/trip_clip_sheet_layout.dart';
import 'trip_clip_trips_filter.dart';
import 'trip_clip_trips_sort.dart';

enum TripClipTripsFilterListSurface {
  featureCards,
  semiCards,
  mapMarkers,
}

Future<TripClipTripsFilterCriteria?> showTripClipTripsFilterSheet(
  BuildContext context, {
  required TripClipTripsFilterCriteria initial,
  required TripClipTripsSortOption currentSort,
  required TripClipTripsFilterListSurface surface,
}) {
  return TripClipModalSheet.show<TripClipTripsFilterCriteria>(
    context,
    builder: (_) => TripClipTripsFilterSheet(
      initial: initial,
      currentSort: currentSort,
      surface: surface,
    ),
  );
}

class TripClipTripsFilterSheet extends StatefulWidget {
  const TripClipTripsFilterSheet({
    super.key,
    required this.initial,
    required this.currentSort,
    required this.surface,
  });

  final TripClipTripsFilterCriteria initial;
  final TripClipTripsSortOption currentSort;
  final TripClipTripsFilterListSurface surface;

  @override
  State<TripClipTripsFilterSheet> createState() =>
      _TripClipTripsFilterSheetState();
}

class _TripClipTripsFilterSheetState extends State<TripClipTripsFilterSheet> {
  static const double _sectionGap = 40;
  static const double _headingBodyGap = 16;
  static const double _chipSpacing = 8;

  static const List<String> _parcelTypes = [
    'Box',
    'Envelope',
    'Satchel',
    'Fragile',
    'Perishable',
    'Bulky',
  ];

  static const List<String> _sizes = ['XS', 'SM', 'MD', 'LG', 'XL'];

  static const List<String> _weightBands = [
    '<3kg',
    '3-10kg',
    '10-20kg',
    '20kg+',
  ];

  late TripClipTripsFilterCriteria _draft;
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _draft = widget.initial;
    _locationController =
        TextEditingController(text: widget.initial.locationText);
    _locationController.addListener(_onLocationChanged);
  }

  void _onLocationChanged() {
    setState(() {
      _draft = _draft.copyWith(locationText: _locationController.text);
    });
  }

  @override
  void dispose() {
    _locationController.removeListener(_onLocationChanged);
    _locationController.dispose();
    super.dispose();
  }

  int _matchCount() {
    switch (widget.surface) {
      case TripClipTripsFilterListSurface.featureCards:
        return tripClipCountMatchingList(
          widget.currentSort,
          _draft,
          semi: false,
        );
      case TripClipTripsFilterListSurface.semiCards:
        return tripClipCountMatchingList(
          widget.currentSort,
          _draft,
          semi: true,
        );
      case TripClipTripsFilterListSurface.mapMarkers:
        return tripClipCountMatchingMap(widget.currentSort, _draft);
    }
  }

  void _clearAll() {
    final cleared = TripClipTripsFilterCriteria.cleared();
    setState(() {
      _draft = cleared;
      _locationController.text = cleared.locationText;
    });
  }

  Widget _sectionHeading(BuildContext context, String svgAsset, String title) {
    final iconColor = context.tripClipColors.textSubtle;
    final textColor = context.tripClipColors.textBase;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          svgAsset,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: textColor),
          ),
        ),
      ],
    );
  }

  TextStyle _distanceLabelStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w500,
          color: context.tripClipColors.textBase,
        );
  }

  double _contentWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width - 32;
  }

  @override
  Widget build(BuildContext context) {
    final count = _matchCount();

    Widget sectionSpacing() => const SizedBox(height: _sectionGap);

    Widget typeGrid() {
      final w = (_contentWidth(context) - 2 * _chipSpacing) / 3;
      final chipW = w.clamp(96.0, 160.0);
      return Wrap(
        spacing: _chipSpacing,
        runSpacing: _chipSpacing,
        children: _parcelTypes.map((t) {
          return SizedBox(
            width: chipW,
            child: TripClipFormRadioButton(
              width: chipW,
              selected: _draft.parcelType == t,
              onPressed: () => setState(() {
                _draft = _draft.copyWith(parcelType: t);
              }),
              label: t,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            ),
          );
        }).toList(),
      );
    }

    Widget sizeRow() {
      final cw = _contentWidth(context);
      final chipW = ((cw - 4 * _chipSpacing) / 5).clamp(52.0, 88.0);
      return Wrap(
        spacing: _chipSpacing,
        runSpacing: _chipSpacing,
        children: _sizes.map((s) {
          return SizedBox(
            width: chipW,
            child: TripClipFormRadioButton(
              width: chipW,
              selected: _draft.sizeCode == s,
              onPressed: () => setState(() {
                _draft = _draft.copyWith(sizeCode: s);
              }),
              label: s,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            ),
          );
        }).toList(),
      );
    }

    Widget weightBandsRow() {
      final cw = _contentWidth(context);
      final chipW = ((cw - 3 * _chipSpacing) / 4).clamp(72.0, 120.0);
      return Wrap(
        spacing: _chipSpacing,
        runSpacing: _chipSpacing,
        children: _weightBands.map((b) {
          return SizedBox(
            width: chipW,
            child: TripClipFormRadioButton(
              width: chipW,
              selected: _draft.weightBand == b,
              onPressed: () => setState(() {
                _draft = _draft.copyWith(weightBand: b);
              }),
              label: b,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            ),
          );
        }).toList(),
      );
    }

    final listBody = ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionHeading(context, 'assets/icons/location.svg', 'Location'),
        const SizedBox(height: _headingBodyGap),
        TripClipAtomInput(
          controller: _locationController,
          showLeading: false,
          trailingIconAsset: 'assets/icons/pencil-edit.svg',
          showTrailing: true,
        ),
        const SizedBox(height: 24),
        Text('Distance from your location', style: _distanceLabelStyle(context)),
        const SizedBox(height: 8),
        TripClipFormSlider(
          value: _draft.maxDistanceKm,
          min: 1,
          max: 50,
          labelLeft: '1km',
          labelRight: '50km',
          onChanged: (v) => setState(() {
            _draft = _draft.copyWith(maxDistanceKm: v);
          }),
        ),
        sectionSpacing(),
        _sectionHeading(context, 'assets/icons/doller.svg', 'Clip'),
        const SizedBox(height: _headingBodyGap),
        TripClipFormSlider(
          value: _draft.clipMaxAud,
          min: 1,
          max: 50,
          labelLeft: r'AUD $1',
          labelRight: r'AUD $50',
          onChanged: (v) => setState(() {
            _draft = _draft.copyWith(clipMaxAud: v);
          }),
        ),
        sectionSpacing(),
        _sectionHeading(context, 'assets/icons/package.svg', 'Type'),
        const SizedBox(height: _headingBodyGap),
        typeGrid(),
        sectionSpacing(),
        _sectionHeading(
          context,
          'assets/icons/package-dimensions.svg',
          'Size',
        ),
        const SizedBox(height: _headingBodyGap),
        sizeRow(),
        sectionSpacing(),
        _sectionHeading(context, 'assets/icons/weight.svg', 'Weight'),
        const SizedBox(height: _headingBodyGap),
        weightBandsRow(),
        const SizedBox(height: _headingBodyGap),
        Text('Maximum Weight', style: _distanceLabelStyle(context)),
        const SizedBox(height: 8),
        TripClipFormSlider(
          value: _draft.maxWeightKg,
          min: 1,
          max: 1000,
          divisions: null,
          labelLeft: '1kg',
          labelRight: '1000kg',
          onChanged: (v) => setState(() {
            _draft = _draft.copyWith(maxWeightKg: v);
          }),
        ),
        const SizedBox(height: 24),
      ],
    );

    return TripClipTermsStyleSheet(
      title: 'Filter',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: listBody),
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              16 + MediaQuery.paddingOf(context).bottom,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TripClipButton(
                    variant: TripClipButtonVariant.primary,
                    expanded: true,
                    label: 'View Results ($count)',
                    onPressed: () =>
                        Navigator.of(context).pop<TripClipTripsFilterCriteria>(
                      _draft,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                TripClipButton(
                  variant: TripClipButtonVariant.tertiary,
                  label: 'Clear All',
                  onPressed: _clearAll,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

