import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'trip_clip_atom_input.dart';
import 'trip_clip_form_message.dart';
import 'trip_clip_form_models.dart';
import 'trip_clip_form_tokens.dart';

/// Six (or [length]) single-digit fields using the same chrome as [TripClipAtomInput]
/// ([TripClipFormFieldDecoration.atom]) for none / error / warning / success.
///
/// Layout: fixed [gapBetweenCells] between cells; cells share remaining width equally
/// (full-width row). Typing is handled by a single offstage [TextField].
class TripClipOtpInput extends StatefulWidget {
  const TripClipOtpInput({
    super.key,
    this.length = 6,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.status = TripClipFormStatus.none,
    this.message,
    this.onChanged,
    this.autofocus = false,
    this.autofillHints = const [AutofillHints.oneTimeCode],
  }) : assert(length > 0);

  /// Number of digit cells (default 6).
  final int length;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;
  final TripClipFormStatus status;

  /// Shown below the row when [status] is error, warning, or success (same pattern as
  /// form fields + [TripClipFormMessage]).
  final String? message;

  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final Iterable<String> autofillHints;

  static const double cellPadding = 15.5;
  static const double gapBetweenCells = 8;
  static const double radius = TripClipAtomInput.radius;

  static const double digitFontSize = 36;
  static const double digitLineHeight = 42 / 36;

  /// Outer height of the OTP row (cell padding + 42px text line). Used so the row
  /// is not laid out with unbounded height inside a [Stack] (e.g. in a scroll view).
  static double get digitRowHeight =>
      cellPadding * 2 + digitFontSize * digitLineHeight;

  @override
  State<TripClipOtpInput> createState() => _TripClipOtpInputState();
}

class _TripClipOtpInputState extends State<TripClipOtpInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocus = false;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _ownsFocus = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  @override
  void didUpdateWidget(covariant TripClipOtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_onTextChanged);
      if (_ownsController) _controller.dispose();
      _ownsController = widget.controller == null;
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_onTextChanged);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_onFocusChanged);
      if (_ownsFocus) _focusNode.dispose();
      _ownsFocus = widget.focusNode == null;
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    if (_ownsFocus) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    widget.onChanged?.call(_controller.text);
    setState(() {});
  }

  void _onFocusChanged() => setState(() {});

  String get _text => _controller.text;

  /// Index of the digit cell that shows the “active” border while typing (last filled,
  /// or the first empty slot when empty).
  int _highlightIndexWhileEditing() {
    if (_text.isEmpty) return 0;
    return _text.length - 1;
  }

  TripClipFormFieldDecoration _decorationForCell({
    required BuildContext context,
    required int index,
    required bool isDark,
  }) {
    if (!widget.enabled) {
      return TripClipFormFieldDecoration.atom(
        isDark: isDark,
        enabled: false,
        focused: false,
        hasValue: false,
        status: TripClipFormStatus.none,
      );
    }

    if (widget.status != TripClipFormStatus.none) {
      final hasChar = index < _text.length;
      return TripClipFormFieldDecoration.atom(
        isDark: isDark,
        enabled: true,
        focused: false,
        hasValue: hasChar,
        status: widget.status,
      );
    }

    if (_text.length >= widget.length) {
      return TripClipFormFieldDecoration.atom(
        isDark: isDark,
        enabled: true,
        focused: false,
        hasValue: true,
        status: TripClipFormStatus.none,
      );
    }

    final hasChar = index < _text.length && _text[index].trim().isNotEmpty;
    final hi = _highlightIndexWhileEditing();
    final focusedCell =
        _focusNode.hasFocus && widget.status == TripClipFormStatus.none && index == hi;

    return TripClipFormFieldDecoration.atom(
      isDark: isDark,
      enabled: true,
      focused: focusedCell,
      hasValue: hasChar,
      status: TripClipFormStatus.none,
    );
  }

  void _onCellTapped(int index) {
    if (!widget.enabled) return;
    _focusNode.requestFocus();
    final t = _text;
    final offset = index < t.length ? index : t.length;
    _controller.value = TextEditingValue(
      text: t,
      selection: TextSelection.collapsed(offset: offset),
    );
  }

  Widget? _buildMessage(BuildContext context) {
    final raw = widget.message?.trim();
    if (raw == null || raw.isEmpty) return null;
    final kind = switch (widget.status) {
      TripClipFormStatus.none => null,
      TripClipFormStatus.error => TripClipFormMessageKind.error,
      TripClipFormStatus.warning => TripClipFormMessageKind.warning,
      TripClipFormStatus.success => TripClipFormMessageKind.success,
    };
    if (kind == null) return null;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dec = TripClipFormFieldDecoration.atom(
      isDark: isDark,
      enabled: widget.enabled,
      focused: false,
      hasValue: true,
      status: widget.status,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        TripClipFormMessage(
          text: raw,
          kind: kind,
          iconSize: 16,
          colorOverride: dec.foreground,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final digitStyle = (theme.textTheme.bodyLarge ?? const TextStyle()).copyWith(
      fontSize: TripClipOtpInput.digitFontSize,
      height: TripClipOtpInput.digitLineHeight,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    );

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < widget.length; i++) ...[
          if (i > 0) const SizedBox(width: TripClipOtpInput.gapBetweenCells),
          Expanded(
            child: _TripClipOtpCell(
              digit: i < _text.length ? _text[i] : '',
              decoration: _decorationForCell(context: context, index: i, isDark: isDark),
              digitStyle: digitStyle,
              onTap: () => _onCellTapped(i),
            ),
          ),
        ],
      ],
    );

    final messageBelow = _buildMessage(context);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: TripClipOtpInput.digitRowHeight,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              row,
              Offstage(
                offstage: true,
                child: SizedBox(
                  height: 1,
                  width: 1,
                  child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  autofocus: widget.autofocus,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.transparent, fontSize: 1),
                  cursorColor: Colors.transparent,
                  showCursor: false,
                  enableInteractiveSelection: false,
                  autofillHints: widget.autofillHints,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(widget.length),
                  ],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            ],
          ),
        ),
        ?messageBelow,
      ],
    );

    if (!widget.enabled) {
      content = Opacity(opacity: 0.4, child: content);
    }

    return content;
  }
}

class _TripClipOtpCell extends StatelessWidget {
  const _TripClipOtpCell({
    required this.digit,
    required this.decoration,
    required this.digitStyle,
    required this.onTap,
  });

  final String digit;
  final TripClipFormFieldDecoration decoration;
  final TextStyle digitStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final char = digit.isEmpty ? '' : digit;
    final textStyle = digitStyle.copyWith(color: decoration.foreground);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TripClipOtpInput.radius),
        child: Container(
          padding: const EdgeInsets.all(TripClipOtpInput.cellPadding),
          decoration: BoxDecoration(
            color: decoration.fill,
            borderRadius: BorderRadius.circular(TripClipOtpInput.radius),
            border: decoration.borderWidth > 0
                ? Border.all(
                    color: decoration.borderColor,
                    width: decoration.borderWidth,
                  )
                : null,
          ),
          alignment: Alignment.center,
          child: Text(char, textAlign: TextAlign.center, style: textStyle),
        ),
      ),
    );
  }
}
