import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_colors.dart';
import '../components/forms/trip_clip_atom_input.dart';
import 'trip_clip_modal_sheet.dart';
import 'trip_clip_sheet_layout.dart';

class TripClipTimeRange {
  const TripClipTimeRange({required this.start, required this.end});

  final TimeOfDay start;
  final TimeOfDay end;
}

Future<TripClipTimeRange?> showTripClipPickupTimeRangeSheet(
  BuildContext context, {
  TripClipTimeRange? initialRange,
  String title = 'Pickup Time Range',
}) {
  return TripClipModalSheet.show<TripClipTimeRange?>(
    context,
    wrapToContent: true,
    builder: (sheetContext) {
      return TripClipTermsStyleSheet(
        title: title,
        expandBody: false,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: _TripClipTimeRangeCard(
            initialRange: initialRange,
            onComplete: (r) => Navigator.of(sheetContext).pop(r),
          ),
        ),
      );
    },
  );
}

class _TripClipTimeRangeCard extends StatefulWidget {
  const _TripClipTimeRangeCard({
    required this.initialRange,
    required this.onComplete,
  });

  final TripClipTimeRange? initialRange;
  final ValueChanged<TripClipTimeRange> onComplete;

  @override
  State<_TripClipTimeRangeCard> createState() => _TripClipTimeRangeCardState();
}

class _TripClipTimeRangeCardState extends State<_TripClipTimeRangeCard> {
  late final TextEditingController _fromDisplay;
  late final TextEditingController _toDisplay;

  TimeOfDay? _from;
  TimeOfDay? _to;

  @override
  void initState() {
    super.initState();
    _from = widget.initialRange?.start;
    _to = widget.initialRange?.end;
    _fromDisplay = TextEditingController();
    _toDisplay = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fromDisplay.text = _from != null ? _fmt(_from!) : '';
    _toDisplay.text = _to != null ? _fmt(_to!) : '';
  }

  @override
  void dispose() {
    _fromDisplay.dispose();
    _toDisplay.dispose();
    super.dispose();
  }

  String _fmt(TimeOfDay t) => MaterialLocalizations.of(context).formatTimeOfDay(
        t,
        alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
      );

  int _minutes(TimeOfDay t) => t.hour * 60 + t.minute;

  void _maybeComplete() {
    final a = _from;
    final b = _to;
    if (a == null || b == null) return;
    final am = _minutes(a);
    final bm = _minutes(b);
    if (bm < am) {
      widget.onComplete(TripClipTimeRange(start: b, end: a));
    } else {
      widget.onComplete(TripClipTimeRange(start: a, end: b));
    }
  }

  Future<void> _pickFrom() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _from ?? TimeOfDay.now(),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _from = picked;
      _fromDisplay.text = _fmt(picked);
    });
    _maybeComplete();
  }

  Future<void> _pickTo() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _to ?? _from ?? TimeOfDay.now(),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _to = picked;
      _toDisplay.text = _fmt(picked);
    });
    _maybeComplete();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = context.tripClipColors.borderSubtle;
    final surface = isDark ? const Color(0xFF101319) : const Color(0xFFF5F7FA);

    final labelStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w500,
          color: context.tripClipColors.textBase,
        );

    final hintStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
          color: context.tripClipColors.textSubtle,
        );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('From', style: labelStyle),
                      const SizedBox(height: 8),
                      TripClipAtomInput(
                        controller: _fromDisplay,
                        hintText: 'Select time',
                        readOnly: true,
                        onTap: _pickFrom,
                        showLeading: false,
                        trailingIconAsset: 'assets/icons/chevron-down.svg',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('To', style: labelStyle),
                      const SizedBox(height: 8),
                      TripClipAtomInput(
                        controller: _toDisplay,
                        hintText: 'Select time',
                        readOnly: true,
                        onTap: _pickTo,
                        showLeading: false,
                        trailingIconAsset: 'assets/icons/chevron-down.svg',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_from == null || _to == null) ...[
              const SizedBox(height: 12),
              Text(
                'Select a start time and an end time',
                style: hintStyle,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

