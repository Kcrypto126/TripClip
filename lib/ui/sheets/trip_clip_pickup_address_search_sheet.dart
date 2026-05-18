import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/trip_clip_colors.dart';
import '../components/forms/trip_clip_atom_input.dart';
import 'trip_clip_modal_sheet.dart';
import 'trip_clip_sheet_layout.dart';

const _kPickupFavourites = <({String label, String addressLine})>[
  (label: 'Home', addressLine: '7 Something Street, St Kilda VIC 3182'),
  (label: 'Work', addressLine: '100 Collins Street, Melbourne VIC 3000'),
  (label: 'Holiday House', addressLine: '2 Ocean Road, Lorne VIC 3232'),
];

const _kAddressSearchPool = <String>[
  '7 Something Street, St Kilda VIC 3182',
  '100 Collins Street, Melbourne VIC 3000',
  '2 Ocean Road, Lorne VIC 3232',
  '3 Hanover Street, Fitzroy VIC, Australia',
  '3 Hanover Street, Fitzroy VIC 3065',
  '120 Spencer Street, Melbourne VIC 3000',
  '1 Bourke Street, Melbourne VIC 3000',
  '45 High Street, Prahran VIC 3181',
];

Future<String?> showTripClipPickupAddressSearchSheet(
  BuildContext context, {
  String? initialQuery,
  String title = 'Pickup Address',
}) {
  return TripClipModalSheet.show<String?>(
    context,
    builder: (ctx) => _TripClipPickupAddressSearchSheetBody(
      initialQuery: initialQuery,
      title: title,
    ),
  );
}

class _TripClipPickupAddressSearchSheetBody extends StatefulWidget {
  const _TripClipPickupAddressSearchSheetBody({
    this.initialQuery,
    required this.title,
  });

  final String? initialQuery;
  final String title;

  @override
  State<_TripClipPickupAddressSearchSheetBody> createState() =>
      _TripClipPickupAddressSearchSheetBodyState();
}

class _TripClipPickupAddressSearchSheetBodyState
    extends State<_TripClipPickupAddressSearchSheetBody> {
  late final TextEditingController _search;
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _search = TextEditingController(text: widget.initialQuery ?? '');
    _search.addListener(_onQueryChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocus.requestFocus();
    });
  }

  void _onQueryChanged() => setState(() {});

  @override
  void dispose() {
    _search.removeListener(_onQueryChanged);
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<String> get _filteredPool {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return _kAddressSearchPool
        .where((line) => line.toLowerCase().contains(q))
        .toList();
  }

  void _pickAndClose(String line) {
    Navigator.of(context).pop<String>(line);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final subtle = context.tripClipColors.textSubtle;
    final base = context.tripClipColors.textBase;
    final favouriteTitleStyle = t.headlineSmall!.copyWith(
      color: base,
    );
    final itemTitleStyle = t.titleMedium!.copyWith(
      color: base,
    );
    final itemSubtitleStyle = t.labelMedium!.copyWith(color: base);
    final query = _search.text;

    return TripClipTermsStyleSheet(
      title: widget.title,
      header: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: _PickupSheetSearchField(
          controller: _search,
          focusNode: _searchFocus,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text('Favourites', style: favouriteTitleStyle),
          ),
          for (var i = 0; i < _kPickupFavourites.length; i++) ...[
            _FavouriteAddressTile(
              label: _kPickupFavourites[i].label,
              addressLine: _kPickupFavourites[i].addressLine,
              onTap: () => _pickAndClose(_kPickupFavourites[i].addressLine),
              titleStyle: itemTitleStyle,
              subtitleStyle: itemSubtitleStyle,
            ),
            if (i < _kPickupFavourites.length - 1) const SizedBox(height: 0),
          ],
          if (query.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            Divider(
              height: 1,
              thickness: 1,
              color: context.tripClipColors.borderSubtle,
            ),
            const SizedBox(height: 16),
            if (_filteredPool.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Text(
                  'No matches',
                  style: t.bodySmall!.copyWith(color: subtle),
                ),
              )
            else
              ..._filteredPool.asMap().entries.map((e) {
                final line = e.value;
                return [
                  _SearchResultRow(
                    line: line,
                    query: query,
                    onTap: () => _pickAndClose(line),
                  ),
                  if (e.key < _filteredPool.length - 1)
                    const SizedBox(height: 12),
                ];
              }).expand((w) => w),
          ],
        ],
      ),
    );
  }
}

class _PickupSheetSearchField extends StatelessWidget {
  const _PickupSheetSearchField({
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final h = context.tripClipColors.heading;
        final hasText = value.text.isNotEmpty;
        return TripClipAtomInput(
          controller: controller,
          focusNode: focusNode,
          hintText: 'Search for an address',
          leadingIconAsset: 'assets/icons/location.svg',
          showLeading: true,
          showTrailing: hasText,
          trailing: hasText
              ? Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    icon: SvgPicture.asset(
                      'assets/icons/cancel-circle.svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(h, BlendMode.srcIn),
                    ),
                    onPressed: () => controller.clear(),
                    tooltip: 'Clear',
                  ),
                )
              : null,
        );
      },
    );
  }
}

class _FavouriteAddressTile extends StatelessWidget {
  const _FavouriteAddressTile({
    required this.label,
    required this.addressLine,
    required this.onTap,
    required this.titleStyle,
    required this.subtitleStyle,
  });

  final String label;
  final String addressLine;
  final VoidCallback onTap;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: titleStyle),
              Text(addressLine, style: subtitleStyle),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchResultRow extends StatelessWidget {
  const _SearchResultRow({
    required this.line,
    required this.query,
    required this.onTap,
  });

  final String line;
  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final base = t.bodyMedium!.copyWith(
      color: context.tripClipColors.textBase,
    );
    final match = t.bodyMedium!.copyWith(
      color: context.tripClipColors.textBase,
      fontWeight: FontWeight.w600,
    );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          onTap();
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/icons/location.svg',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                  context.tripClipColors.textSubtle,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: base,
                    children: _highlightLine(line, query, base, match),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<TextSpan> _highlightLine(
  String line,
  String query,
  TextStyle base,
  TextStyle matchStyle,
) {
  final t = query.trim();
  if (t.isEmpty) {
    return [TextSpan(text: line, style: base)];
  }
  final lo = line.toLowerCase();
  final tlo = t.toLowerCase();
  int i = lo.indexOf(tlo);
  if (i >= 0) {
    final e = i + t.length;
    if (e <= line.length) {
      return [
        if (i > 0) TextSpan(text: line.substring(0, i), style: base),
        TextSpan(
          text: line.length >= e ? line.substring(i, e) : line.substring(i),
          style: matchStyle,
        ),
        if (e < line.length) TextSpan(text: line.substring(e), style: base),
      ];
    }
  }
  for (final w in t.split(RegExp(r'\s+'))) {
    if (w.isEmpty) continue;
    i = lo.indexOf(w.toLowerCase());
    if (i < 0) continue;
    final e = i + w.length;
    if (e > line.length) continue;
    return [
      if (i > 0) TextSpan(text: line.substring(0, i), style: base),
      TextSpan(text: line.substring(i, e), style: matchStyle),
      if (e < line.length) TextSpan(text: line.substring(e), style: base),
    ];
  }
  return [TextSpan(text: line, style: base)];
}
