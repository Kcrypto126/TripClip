import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';

const double _kCellGap = 4;
const double _kWeekCellH = 20;

class TripClipFormCalendarRange extends StatefulWidget {
  const TripClipFormCalendarRange({
    super.key,
    this.initialRange,
    this.minDate,
    this.maxDate,
    this.onFocusedMonthChanged,
    this.onTitleTap,
    required this.onRangeComplete,
  });

  final DateTimeRange? initialRange;

  final DateTime? minDate;
  final DateTime? maxDate;

  final ValueChanged<DateTime>? onFocusedMonthChanged;
  final VoidCallback? onTitleTap;
  final ValueChanged<DateTimeRange> onRangeComplete;

  @override
  State<TripClipFormCalendarRange> createState() =>
      _TripClipFormCalendarRangeState();
}

class _TripClipFormCalendarRangeState extends State<TripClipFormCalendarRange> {
  late DateTime _focusedMonth;
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    final r = widget.initialRange;
    final now = _dateOnly(DateTime.now());
    if (r != null) {
      _start = _dateOnly(r.start);
      _end = _dateOnly(r.end);
      _focusedMonth = DateTime(_start!.year, _start!.month);
    } else {
      _focusedMonth = DateTime(now.year, now.month);
    }
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime _monthOnly(DateTime d) => DateTime(d.year, d.month);

  Color get _accent => context.tripClipColors.heading;

  bool get _isLight => Theme.of(context).brightness == Brightness.light;

  Color get _surface =>
      _isLight ? const Color(0xFFEFF2F5) : const Color(0xFF1F242B);

  Color get _selectedFill =>
      _isLight ? const Color(0xFF141E46) : const Color(0xFF7C86AE);

  Color get _primaryText => context.tripClipColors.textBase;
  Color get _weekdayColor => context.tripClipColors.textSubtle;
  Color get _adjacentColor =>
      _isLight ? TripClipPalette.neutral400 : TripClipPalette.neutral700;

  Color get _borderColor => context.tripClipColors.borderSubtle;

  DateTime? get _minD =>
      widget.minDate != null ? _dateOnly(widget.minDate!) : null;
  DateTime? get _maxD =>
      widget.maxDate != null ? _dateOnly(widget.maxDate!) : null;

  bool _beforeMin(DateTime d) {
    final m = _minD;
    if (m == null) return false;
    return d.isBefore(m);
  }

  bool _afterMax(DateTime d) {
    final m = _maxD;
    if (m == null) return false;
    return d.isAfter(m);
  }

  bool get _canGoPrev {
    if (_minD == null) return true;
    return _monthOnly(_focusedMonth).isAfter(
      DateTime(_minD!.year, _minD!.month),
    );
  }

  bool get _canGoNext {
    if (_maxD == null) return true;
    return _monthOnly(_focusedMonth).isBefore(
      DateTime(_maxD!.year, _maxD!.month),
    );
  }

  void _goPrev() {
    if (!_canGoPrev) return;
    setState(
      () => _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month - 1,
      ),
    );
    widget.onFocusedMonthChanged?.call(_focusedMonth);
  }

  void _goNext() {
    if (!_canGoNext) return;
    setState(
      () => _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + 1,
      ),
    );
    widget.onFocusedMonthChanged?.call(_focusedMonth);
  }

  int _sundayFirstColumn(DateTime d) =>
      d.weekday == DateTime.sunday ? 0 : d.weekday;

  void _onDayTap(DateTime day) {
    final d = _dateOnly(day);
    if (_beforeMin(d) || _afterMax(d)) return;

    if (_start == null || _end != null) {
      setState(() {
        _start = d;
        _end = null;
      });
      return;
    }

    final oldStart = _start!;
    late DateTime newStart;
    late DateTime newEnd;
    if (d.isBefore(oldStart)) {
      newStart = d;
      newEnd = oldStart;
    } else {
      newStart = oldStart;
      newEnd = d;
    }
    setState(() {
      _start = newStart;
      _end = newEnd;
    });
    widget.onRangeComplete(DateTimeRange(start: newStart, end: newEnd));
  }

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
        _CalendarDayCell(
          date: DateTime(y, m - 1, day),
          inFocusedMonth: false,
        ),
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

  bool _sameDay(DateTime? a, DateTime b) {
    if (a == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _inInclusiveRange(DateTime d) {
    if (_start == null || _end == null) return false;
    final t = d.millisecondsSinceEpoch;
    return t >= _start!.millisecondsSinceEpoch &&
        t <= _end!.millisecondsSinceEpoch;
  }

  Widget _chevronButton({
    required String asset,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final color = !enabled
        ? (_isLight ? TripClipPalette.neutral400 : TripClipPalette.neutral700)
        : _accent;
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
      color: _primaryText,
    );
    final weekdayStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1,
      color: _weekdayColor,
    );
    final dateBase = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1,
    );

    final monthTitle = MaterialLocalizations.of(
      context,
    ).formatMonthYear(DateTime(_focusedMonth.year, _focusedMonth.month));
    const labels = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    final dayCells = _buildCells();
    final weeks = <List<_CalendarDayCell>>[];
    for (var i = 0; i < dayCells.length; i += 7) {
      weeks.add(dayCells.sublist(i, i + 7));
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                const navReserve = 80.0;
                final titleBlockMax = (constraints.maxWidth - navReserve).clamp(
                  0.0,
                  double.infinity,
                );
                final textMax = (titleBlockMax - 4 - 24).clamp(0.0, double.infinity);
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
                                    constraints: BoxConstraints(
                                      maxWidth: textMax,
                                    ),
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
                                      _accent,
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
            LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final cellW = (w - 6 * _kCellGap) / 7;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        for (var c = 0; c < 7; c++) ...[
                          if (c > 0) const SizedBox(width: _kCellGap),
                          SizedBox(
                            width: cellW,
                            height: _kWeekCellH,
                            child: Center(
                              child: Text(labels[c], style: weekdayStyle),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: _kCellGap),
                    for (var r = 0; r < weeks.length; r++) ...[
                      if (r > 0) const SizedBox(height: _kCellGap),
                      Row(
                        children: [
                          for (var c = 0; c < 7; c++) ...[
                            if (c > 0) const SizedBox(width: _kCellGap),
                            _RangeDateCell(
                              size: cellW,
                              cell: weeks[r][c],
                              textStyle: dateBase ?? const TextStyle(fontSize: 16),
                              inMonthColor: _primaryText,
                              adjacentColor: _adjacentColor,
                              rangeStart: _start,
                              rangeEnd: _end,
                              inInclusiveRange: _inInclusiveRange,
                              sameDay: _sameDay,
                              minDate: _minD,
                              maxDate: _maxD,
                              accent: _accent,
                              selectedFill: _selectedFill,
                              onTap: _onDayTap,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                );
              },
            ),
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

class _RangeDateCell extends StatelessWidget {
  const _RangeDateCell({
    required this.size,
    required this.cell,
    required this.textStyle,
    required this.inMonthColor,
    required this.adjacentColor,
    required this.rangeStart,
    required this.rangeEnd,
    required this.inInclusiveRange,
    required this.sameDay,
    required this.minDate,
    required this.maxDate,
    required this.accent,
    required this.selectedFill,
    required this.onTap,
  });

  final double size;
  final _CalendarDayCell cell;
  final TextStyle textStyle;
  final Color inMonthColor;
  final Color adjacentColor;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final bool Function(DateTime) inInclusiveRange;
  final bool Function(DateTime?, DateTime) sameDay;
  final DateTime? minDate;
  final DateTime? maxDate;
  final Color accent;
  final Color selectedFill;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final d = cell.date;
    final inMonth = cell.inFocusedMonth;
    var disabled = false;
    final t = DateTime(d.year, d.month, d.day);
    if (minDate != null && t.isBefore(minDate!)) disabled = true;
    if (maxDate != null && t.isAfter(maxDate!)) disabled = true;

    final isStart = sameDay(rangeStart, d);
    final isEnd = sameDay(rangeEnd, d);
    final haveBoth = rangeStart != null && rangeEnd != null;
    final inRangeSpan = haveBoth && inInclusiveRange(d);
    final isEdge = haveBoth && (isStart || isEnd);
    final isMid = inRangeSpan && haveBoth && !isStart && !isEnd;

    Color? fill;
    late Color fg;
    if (disabled) {
      fill = null;
      fg = adjacentColor;
    } else if (rangeEnd == null && isStart) {
      fill = selectedFill;
      fg = Colors.white;
    } else if (isEdge) {
      fill = selectedFill;
      fg = Colors.white;
    } else if (isMid) {
      fill = selectedFill.withValues(alpha: 0.15);
      fg = inMonth ? inMonthColor : adjacentColor;
    } else {
      fill = null;
      fg = inMonth ? inMonthColor : adjacentColor;
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: disabled
            ? null
            : () {
                onTap(d);
              },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(8),
            border: null,
          ),
          child: Text('${d.day}', style: textStyle.copyWith(color: fg)),
        ),
      ),
    );
  }
}
