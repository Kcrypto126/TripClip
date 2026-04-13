import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/trip_clip_palette.dart';

const double _kFormCalendarCellGap = 4;
const double _kFormCalendarWeekCellW = 40;
const double _kFormCalendarWeekCellH = 20;
const double _kFormCalendarDateCell = 40;

/// `form-calendar` — month grid with chevron navigation and Rubik typography.
///
/// Week starts Sunday (`Su`–`Sa`). When [selectedDate] is null, the calendar
/// starts on the current month with today selected; today is also outlined when
/// another day is selected.
class TripClipFormCalendar extends StatefulWidget {
  const TripClipFormCalendar({
    super.key,
    this.initialFocusedMonth,
    this.selectedDate,
    this.onSelectedDateChanged,
    this.onFocusedMonthChanged,
    this.onTitleTap,
    this.minDate,
    this.maxDate,
  });

  /// Month shown on first build (day is ignored). Defaults to [DateTime.now].
  final DateTime? initialFocusedMonth;

  /// When non-null, selection highlight follows this value (controlled).
  final DateTime? selectedDate;

  final ValueChanged<DateTime>? onSelectedDateChanged;
  final ValueChanged<DateTime>? onFocusedMonthChanged;
  final VoidCallback? onTitleTap;

  /// Inclusive month bounds for prev/next (day fields ignored).
  final DateTime? minDate;
  final DateTime? maxDate;

  @override
  State<TripClipFormCalendar> createState() => _TripClipFormCalendarState();
}

class _TripClipFormCalendarState extends State<TripClipFormCalendar> {
  late DateTime _focusedMonth;
  DateTime? _localSelected;

  @override
  void initState() {
    super.initState();
    _focusedMonth = _monthOnly(widget.initialFocusedMonth ?? DateTime.now());
    if (widget.selectedDate == null) {
      _localSelected = _dateOnly(DateTime.now());
    }
  }

  @override
  void didUpdateWidget(covariant TripClipFormCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFocusedMonth != oldWidget.initialFocusedMonth &&
        widget.initialFocusedMonth != null) {
      _focusedMonth = _monthOnly(widget.initialFocusedMonth!);
    }
  }

  DateTime _monthOnly(DateTime d) => DateTime(d.year, d.month);

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime? get _shownSelected =>
      widget.selectedDate != null ? _dateOnly(widget.selectedDate!) : _localSelected;

  bool get _isLight => Theme.of(context).brightness == Brightness.light;

  /// Chevrons + selected-day outline: `#0000D2` light, `#3F5BFF` dark.
  Color get _calendarAccentColor =>
      _isLight ? TripClipPalette.primary500 : TripClipPalette.primary400;

  Color get _todayCellBackground =>
      _isLight ? TripClipPalette.tertiary500 : TripClipPalette.tertiary300;

  bool get _canGoPrev {
    final m = widget.minDate;
    if (m == null) return true;
    final minM = DateTime(m.year, m.month);
    return _monthOnly(_focusedMonth).isAfter(minM);
  }

  bool get _canGoNext {
    final m = widget.maxDate;
    if (m == null) return true;
    final maxM = DateTime(m.year, m.month);
    return _monthOnly(_focusedMonth).isBefore(maxM);
  }

  void _goPrev() {
    if (!_canGoPrev) return;
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
    widget.onFocusedMonthChanged?.call(_focusedMonth);
  }

  void _goNext() {
    if (!_canGoNext) return;
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
    widget.onFocusedMonthChanged?.call(_focusedMonth);
  }

  void _onDayTap(DateTime day) {
    final picked = _dateOnly(day);
    if (widget.selectedDate == null) {
      setState(() => _localSelected = picked);
    }
    widget.onSelectedDateChanged?.call(picked);
  }

  Color get _borderColor =>
      _isLight ? TripClipPalette.neutral200 : TripClipPalette.neutral850;

  Color get _surfaceColor =>
      _isLight ? TripClipPalette.neutral100 : TripClipPalette.neutral900;

  Color get _titleColor =>
      _isLight ? TripClipPalette.tertiary500 : Colors.white;

  Color get _weekdayColor =>
      _isLight ? TripClipPalette.neutral600 : TripClipPalette.neutral300;

  Color get _dateInMonthColor =>
      _isLight ? TripClipPalette.tertiary500 : Colors.white;

  Color get _dateAdjacentColor =>
      _isLight ? TripClipPalette.neutral400 : TripClipPalette.neutral700;

  Color _navChevronColor(bool enabled) {
    if (!enabled) {
      return _isLight ? TripClipPalette.neutral400 : TripClipPalette.neutral700;
    }
    return _calendarAccentColor;
  }

  static const List<String> _weekdayLabels2 = [
    'Su',
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
  ];

  /// Sunday = column 0 … Saturday = 6
  int _sundayFirstColumn(DateTime d) =>
      d.weekday == DateTime.sunday ? 0 : d.weekday;

  List<_CalendarDayCell> _buildCells() {
    final y = _focusedMonth.year;
    final m = _focusedMonth.month;
    final first = DateTime(y, m, 1);
    final daysInMonth = DateTime(y, m + 1, 0).day;
    final leading = _sundayFirstColumn(first);
    final prevMonthDays = DateTime(y, m, 0).day;

    final cells = <_CalendarDayCell>[];

    for (var i = 0; i < leading; i++) {
      final day = prevMonthDays - leading + i + 1;
      cells.add(
        _CalendarDayCell(date: DateTime(y, m - 1, day), inFocusedMonth: false),
      );
    }
    for (var d = 1; d <= daysInMonth; d++) {
      cells.add(_CalendarDayCell(date: DateTime(y, m, d), inFocusedMonth: true));
    }
    var nextAdjacent = 1;
    while (cells.length % 7 != 0) {
      cells.add(
        _CalendarDayCell(
          date: DateTime(y, m + 1, nextAdjacent++),
          inFocusedMonth: false,
        ),
      );
    }
    while (cells.length < 42) {
      cells.add(
        _CalendarDayCell(
          date: DateTime(y, m + 1, nextAdjacent++),
          inFocusedMonth: false,
        ),
      );
    }

    return cells;
  }

  Widget _chevronButton({
    required String asset,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final color = _navChevronColor(enabled);
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: SvgPicture.asset(
              asset,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 22 / 18,
          color: _titleColor,
        );
    final weekdayStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1,
          color: _weekdayColor,
        );
    final dateStyleBase = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1,
        );

    final monthTitle = MaterialLocalizations.of(context)
        .formatMonthYear(DateTime(_focusedMonth.year, _focusedMonth.month));

    final labels = _weekdayLabels2;
    final today = _dateOnly(DateTime.now());
    final dayCells = _buildCells();
    final weeks = <List<_CalendarDayCell>>[];
    for (var i = 0; i < dayCells.length; i += 7) {
      weeks.add(dayCells.sublist(i, i + 7));
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                const navReserve = 80.0;
                final titleBlockMax = (constraints.maxWidth - navReserve)
                    .clamp(0.0, double.infinity);
                final textMax =
                    (titleBlockMax - 4 - 24).clamp(0.0, double.infinity);
                return Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            onTap: widget.onTitleTap,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ConstrainedBox(
                                    constraints:
                                        BoxConstraints(maxWidth: textMax),
                                    child: Text(
                                      monthTitle,
                                      style: titleStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  SvgPicture.asset(
                                    'assets/icons/chevron-right.svg',
                                    width: 24,
                                    height: 24,
                                    colorFilter: ColorFilter.mode(
                                      _calendarAccentColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _chevronButton(
                          asset: 'assets/icons/chevron-left.svg',
                          enabled: _canGoPrev,
                          onTap: _goPrev,
                        ),
                        _chevronButton(
                          asset: 'assets/icons/chevron-right.svg',
                          enabled: _canGoNext,
                          onTap: _goNext,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 23),
            Row(
              children: [
                for (var c = 0; c < 7; c++) ...[
                  if (c > 0) const SizedBox(width: _kFormCalendarCellGap),
                  SizedBox(
                    width: _kFormCalendarWeekCellW,
                    height: _kFormCalendarWeekCellH,
                    child: Center(
                      child: Text(labels[c], style: weekdayStyle),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: _kFormCalendarCellGap),
            for (var r = 0; r < weeks.length; r++) ...[
              if (r > 0) const SizedBox(height: _kFormCalendarCellGap),
              Row(
                children: [
                  for (var c = 0; c < 7; c++) ...[
                    if (c > 0) const SizedBox(width: _kFormCalendarCellGap),
                    _DateCell(
                      cell: weeks[r][c],
                      textStyle: dateStyleBase,
                      inMonthColor: _dateInMonthColor,
                      adjacentColor: _dateAdjacentColor,
                      selected: _shownSelected,
                      today: today,
                      accentColor: _calendarAccentColor,
                      todayBackground: _todayCellBackground,
                      onTap: _onDayTap,
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CalendarDayCell {
  const _CalendarDayCell({required this.date, required this.inFocusedMonth});

  final DateTime date;
  final bool inFocusedMonth;
}

class _DateCell extends StatelessWidget {
  const _DateCell({
    required this.cell,
    required this.textStyle,
    required this.inMonthColor,
    required this.adjacentColor,
    required this.selected,
    required this.today,
    required this.accentColor,
    required this.todayBackground,
    required this.onTap,
  });

  final _CalendarDayCell cell;
  final TextStyle? textStyle;
  final Color inMonthColor;
  final Color adjacentColor;
  final DateTime? selected;
  final DateTime today;
  final Color accentColor;
  final Color todayBackground;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = selected != null &&
        cell.date.year == selected!.year &&
        cell.date.month == selected!.month &&
        cell.date.day == selected!.day;
    final isToday = cell.date.year == today.year &&
        cell.date.month == today.month &&
        cell.date.day == today.day;

    final Color fg;
    final Color? fill;
    Border? border;

    if (isToday) {
      fg = Colors.white;
      fill = todayBackground;
      if (isSelected) {
        border = Border.all(color: accentColor, width: 1.5);
      }
    } else {
      fg = cell.inFocusedMonth ? inMonthColor : adjacentColor;
      fill = null;
      if (isSelected) {
        border = Border.all(color: accentColor, width: 1.5);
      }
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => onTap(cell.date),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: _kFormCalendarDateCell,
          height: _kFormCalendarDateCell,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(8),
            border: border,
          ),
          child: Text(
            '${cell.date.day}',
            style: textStyle?.copyWith(color: fg),
          ),
        ),
      ),
    );
  }
}
