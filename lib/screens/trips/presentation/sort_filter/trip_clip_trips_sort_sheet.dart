import 'package:flutter/material.dart';

import '../../../../app/theme/trip_clip_colors.dart';
import '../../../../ui/components/forms/trip_clip_form_radio.dart';
import '../../../../ui/sheets/trip_clip_modal_sheet.dart';
import '../../../../ui/sheets/trip_clip_sheet_layout.dart';
import 'trip_clip_trips_sort.dart';

void showTripClipTripsSortSheet(
  BuildContext context, {
  required TripClipTripsSortOption selected,
  required ValueChanged<TripClipTripsSortOption> onSelected,
}) {
  TripClipModalSheet.show<void>(
    context,
    builder: (sheetContext) => TripClipTripsSortSheet(
      initialSelection: selected,
      onSelected: onSelected,
    ),
  );
}

class TripClipTripsSortSheet extends StatefulWidget {
  const TripClipTripsSortSheet({
    super.key,
    required this.initialSelection,
    required this.onSelected,
  });

  final TripClipTripsSortOption initialSelection;
  final ValueChanged<TripClipTripsSortOption> onSelected;

  @override
  State<TripClipTripsSortSheet> createState() => _TripClipTripsSortSheetState();
}

class _TripClipTripsSortSheetState extends State<TripClipTripsSortSheet> {
  late TripClipTripsSortOption _groupValue;

  static const double _sectionGap = 24;
  static const double _radioGap = 8;

  @override
  void initState() {
    super.initState();
    _groupValue = widget.initialSelection;
  }

  @override
  void didUpdateWidget(covariant TripClipTripsSortSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelection != widget.initialSelection) {
      _groupValue = widget.initialSelection;
    }
  }

  void _pick(TripClipTripsSortOption? v) {
    if (v == null) return;
    setState(() => _groupValue = v);
    widget.onSelected(v);
  }

  @override
  Widget build(BuildContext context) {
    final headerColor = context.tripClipColors.textBase;

    TextStyle sectionStyle() => Theme.of(context)
        .textTheme
        .headlineMedium!
        .copyWith(color: headerColor);

    Widget section(String title, List<Widget> radios) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: sectionStyle()),
          const SizedBox(height: 8),
          for (var i = 0; i < radios.length; i++) ...[
            if (i > 0) const SizedBox(height: _radioGap),
            radios[i],
          ],
        ],
      );
    }

    return TripClipTermsStyleSheet(
      title: 'Sort',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          section('Best', [
            TripClipFormRadio<TripClipTripsSortOption>(
              value: TripClipTripsSortOption.bestMatch,
              groupValue: _groupValue,
              onChanged: _pick,
              label: 'Best match',
            ),
            TripClipFormRadio<TripClipTripsSortOption>(
              value: TripClipTripsSortOption.bestValue,
              groupValue: _groupValue,
              onChanged: _pick,
              label: 'Best value',
            ),
          ]),
          const SizedBox(height: _sectionGap),
          section('Clips', [
            TripClipFormRadio<TripClipTripsSortOption>(
              value: TripClipTripsSortOption.highestClip,
              groupValue: _groupValue,
              onChanged: _pick,
              label: 'Highest clip',
            ),
            TripClipFormRadio<TripClipTripsSortOption>(
              value: TripClipTripsSortOption.lowestClip,
              groupValue: _groupValue,
              onChanged: _pick,
              label: 'Lowest clip',
            ),
            TripClipFormRadio<TripClipTripsSortOption>(
              value: TripClipTripsSortOption.flexibleClip,
              groupValue: _groupValue,
              onChanged: _pick,
              label: 'Flexible clip',
            ),
          ]),
          const SizedBox(height: _sectionGap),
          section('Dates', [
            TripClipFormRadio<TripClipTripsSortOption>(
              value: TripClipTripsSortOption.soonestDeparture,
              groupValue: _groupValue,
              onChanged: _pick,
              label: 'Soonest departure',
            ),
            TripClipFormRadio<TripClipTripsSortOption>(
              value: TripClipTripsSortOption.newestTrips,
              groupValue: _groupValue,
              onChanged: _pick,
              label: 'Newest trips',
            ),
            TripClipFormRadio<TripClipTripsSortOption>(
              value: TripClipTripsSortOption.oldestTrips,
              groupValue: _groupValue,
              onChanged: _pick,
              label: 'Oldest trips',
            ),
          ]),
          const SizedBox(height: _sectionGap),
          section('Ratings', [
            TripClipFormRadio<TripClipTripsSortOption>(
              value: TripClipTripsSortOption.highestRatedSenders,
              groupValue: _groupValue,
              onChanged: _pick,
              label: 'Highest rated senders',
            ),
            TripClipFormRadio<TripClipTripsSortOption>(
              value: TripClipTripsSortOption.lowestRatedSenders,
              groupValue: _groupValue,
              onChanged: _pick,
              label: 'Lowest rated senders',
            ),
          ]),
        ],
      ),
    );
  }
}

