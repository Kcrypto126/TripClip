import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_colors.dart';
import '../components/forms/trip_clip_atom_input.dart';
import '../components/forms/trip_clip_form_radio.dart';
import 'trip_clip_modal_sheet.dart';
import 'trip_clip_sheet_layout.dart';

const tripClipAustralianStates = <String>[
  'ACT',
  'NSW',
  'NT',
  'QLD',
  'SA',
  'TAS',
  'VIC',
  'WA',
];

const tripClipCountries = <String>[
  'Afghanistan',
  'Albania',
  'Algeria',
  'Argentina',
  'Australia',
  'Austria',
  'Bahrain',
  'Bangladesh',
  'Belgium',
  'Brazil',
  'Canada',
  'Chile',
  'China',
  'Colombia',
  'Denmark',
  'Egypt',
  'Estonia',
  'Finland',
  'France',
  'Germany',
  'Greece',
  'India',
  'Indonesia',
  'Ireland',
  'Italy',
  'Japan',
  'Kenya',
  'Malaysia',
  'Mexico',
  'Netherlands',
  'New Zealand',
  'Norway',
  'Pakistan',
  'Philippines',
  'Poland',
  'Portugal',
  'Singapore',
  'South Africa',
  'South Korea',
  'Spain',
  'Sweden',
  'Switzerland',
  'Thailand',
  'Turkey',
  'United Arab Emirates',
  'United Kingdom',
  'United States',
  'Vietnam',
];

Future<String?> showTripClipSearchSelectionSheet(
  BuildContext context, {
  required String title,
  required List<String> items,
  String? selected,
  String searchHint = 'Search…',
}) {
  return TripClipModalSheet.show<String?>(
    context,
    builder: (_) => _TripClipCountrySelectionSheet(
      title: title,
      items: items,
      selected: selected,
      searchHint: searchHint,
    ),
  );
}

Future<String?> showTripClipCountrySelectionSheet(
  BuildContext context, {
  String? selected,
  String searchHint = 'Search countries…',
}) {
  return TripClipModalSheet.show<String?>(
    context,
    builder: (_) => _TripClipCountrySelectionSheet(
      title: 'Country',
      items: tripClipCountries,
      selected: selected,
      searchHint: searchHint,
    ),
  );
}

Future<String?> showTripClipStateSelectionSheet(
  BuildContext context, {
  String? selected,
}) {
  return TripClipModalSheet.show<String?>(
    context,
    builder: (_) => _TripClipStateSelectionSheet(
      title: 'State',
      items: tripClipAustralianStates,
      selected: selected,
    ),
  );
}

class _TripClipCountrySelectionSheet extends StatefulWidget {
  const _TripClipCountrySelectionSheet({
    required this.title,
    required this.items,
    this.selected,
    required this.searchHint,
  });

  final String title;
  final List<String> items;
  final String? selected;
  final String searchHint;

  @override
  State<_TripClipCountrySelectionSheet> createState() =>
      _TripClipCountrySelectionSheetState();
}

class _TripClipCountrySelectionSheetState
    extends State<_TripClipCountrySelectionSheet> {
  late final TextEditingController _search;
  String? _selected;

  @override
  void initState() {
    super.initState();
    _search = TextEditingController();
    _selected = widget.selected;
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<String> get _filtered {
    final q = _search.text.trim().toLowerCase();
    final sorted = List<String>.from(widget.items)..sort();
    if (q.isEmpty) return sorted;
    return sorted.where((e) => e.toLowerCase().contains(q)).toList();
  }

  Map<String, List<String>> get _grouped {
    final map = <String, List<String>>{};
    for (final e in _filtered) {
      final letter = e.isEmpty ? '#' : e[0].toUpperCase();
      map.putIfAbsent(letter, () => []).add(e);
    }
    final keys = map.keys.toList()..sort();
    return {for (final k in keys) k: map[k]!};
  }

  @override
  Widget build(BuildContext context) {
    return TripClipTermsStyleSheet(
      title: widget.title,
      header: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: TripClipAtomInput(
          controller: _search,
          hintText: widget.searchHint,
          leadingIconAsset: 'assets/icons/location.svg',
          trailingIconAsset: 'assets/icons/search.svg',
          showLeading: true,
          showTrailing: true,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          for (final entry in _grouped.entries) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                entry.key,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.tripClipColors.textBase,
                    ),
              ),
            ),
            for (final name in entry.value)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TripClipFormRadio<String>(
                  value: name,
                  groupValue: _selected,
                  onChanged: (v) {
                    setState(() => _selected = v);
                    Navigator.of(context).pop(v);
                  },
                  label: name,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _TripClipStateSelectionSheet extends StatelessWidget {
  const _TripClipStateSelectionSheet({
    required this.title,
    required this.items,
    this.selected,
  });

  final String title;
  final List<String> items;
  final String? selected;

  @override
  Widget build(BuildContext context) {
    String? groupValue = selected;

    return TripClipTermsStyleSheet(
      title: title,
      body: StatefulBuilder(
        builder: (context, setState) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              for (final name in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TripClipFormRadio<String>(
                    value: name,
                    groupValue: groupValue,
                    onChanged: (v) {
                      setState(() => groupValue = v);
                      Navigator.of(context).pop(v);
                    },
                    label: name,
                    // Keep the same visual behavior; rely on component styling.
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
