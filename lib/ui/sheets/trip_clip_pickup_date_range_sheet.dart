import 'package:flutter/material.dart';

import '../components/forms/trip_clip_form_calendar_range.dart';
import 'trip_clip_modal_sheet.dart';
import 'trip_clip_sheet_layout.dart';

Future<DateTimeRange?> showTripClipPickupDateRangeSheet(
  BuildContext context, {
  DateTimeRange? initialRange,
  String title = 'Pickup Date Range',
}) {
  return TripClipModalSheet.show<DateTimeRange?>(
    context,
    wrapToContent: true,
    builder: (sheetContext) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final maxDate = DateTime(now.year + 2, 12, 31);
      return TripClipTermsStyleSheet(
        title: title,
        expandBody: false,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: TripClipFormCalendarRange(
            initialRange: initialRange,
            minDate: today,
            maxDate: maxDate,
            onRangeComplete: (range) {
              Navigator.of(sheetContext).pop(range);
            },
          ),
        ),
      );
    },
  );
}
