import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'trip_clip_atom_input.dart';
import 'trip_clip_form_message.dart';
import 'trip_clip_form_models.dart';
import 'trip_clip_form_tokens.dart';

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

  final int length;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;
  final TripClipFormStatus status;

  final String? message;

  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final Iterable<String> autofillHints;

  static const double cellHeight = 56;

  static const double cellHorizontalPadding = 8;
  static const double gapBetweenCells = 8;
  static const double radius = TripClipAtomInput.radius;

  static const double digitFontSize = 32;
  static const double digitLineHeight = 1.0;

  static const double digitRowHeight = cellHeight;

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
    final t = _controller.text;
    final sel = _controller.selection;
    if (!sel.isValid ||
        sel.extentOffset > t.length ||
        sel.baseOffset > t.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_controller.text != t) return;
        _controller.value = TextEditingValue(
          text: t,
          selection: TextSelection.collapsed(offset: t.length),
        );
      });
    }
    widget.onChanged?.call(t);
    setState(() {});
  }

  void _onFocusChanged() => setState(() {});

  String get _text => _controller.text;

  int _activeInputSlotIndex() {
    if (_text.length >= widget.length) {
      return widget.length - 1;
    }
    if (!_focusNode.hasFocus) {
      return _text.length.clamp(0, widget.length - 1);
    }
    final sel = _controller.selection;
    if (!sel.isValid || !sel.isCollapsed) {
      return _text.length.clamp(0, widget.length - 1);
    }
    return sel.extentOffset.clamp(0, widget.length - 1);
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
    final hi = _activeInputSlotIndex();
    final focusedCell =
        _focusNode.hasFocus &&
        widget.status == TripClipFormStatus.none &&
        index == hi;

    return TripClipFormFieldDecoration.atom(
      isDark: isDark,
      enabled: true,
      focused: focusedCell,
      hasValue: hasChar,
      status: TripClipFormStatus.none,
    );
  }

  void _placeCaretAtCell(int index) {
    if (!widget.enabled) return;
    _focusNode.requestFocus();
    final t = _text;
    final offset = index < t.length ? index : t.length;
    _controller.value = TextEditingValue(
      text: t,
      selection: TextSelection.collapsed(offset: offset),
    );
  }

  int _cellIndexFromLocalDx(double dx, double totalWidth) {
    final n = widget.length;
    final gap = TripClipOtpInput.gapBetweenCells;
    if (n <= 0 || totalWidth <= 0) return 0;
    final cellW = (totalWidth - (n - 1) * gap) / n;
    if (cellW <= 0) return 0;
    var acc = 0.0;
    for (var i = 0; i < n; i++) {
      if (dx < acc + cellW) return i;
      acc += cellW;
      if (i < n - 1) acc += gap;
    }
    return n - 1;
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
          colorOverride: dec.helper,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final digitStyle = (theme.textTheme.bodyLarge ?? const TextStyle())
        .copyWith(
          fontSize: TripClipOtpInput.digitFontSize,
          height: TripClipOtpInput.digitLineHeight,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        );

    final messageBelow = _buildMessage(context);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: TripClipOtpInput.digitRowHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalW = constraints.maxWidth;
              final row = Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < widget.length; i++) ...[
                    if (i > 0)
                      const SizedBox(width: TripClipOtpInput.gapBetweenCells),
                    Expanded(
                      child: _TripClipOtpCell(
                        digit: i < _text.length ? _text[i] : '',
                        decoration: _decorationForCell(
                          context: context,
                          index: i,
                          isDark: isDark,
                        ),
                        digitStyle: digitStyle,
                      ),
                    ),
                  ],
                ],
              );

              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  row,
                  Positioned.fill(
                    child: Listener(
                      behavior: HitTestBehavior.translucent,
                      onPointerDown: (event) {
                        if (!widget.enabled) return;
                        final i = _cellIndexFromLocalDx(
                          event.localPosition.dx,
                          totalW,
                        );
                        _placeCaretAtCell(i);
                      },
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        enabled: widget.enabled,
                        autofocus: widget.autofocus,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        minLines: null,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          color: Colors.transparent,
                          fontSize: 16,
                          height: 1,
                        ),
                        strutStyle: StrutStyle.disabled,
                        cursorColor: Colors.transparent,
                        showCursor: false,
                        enableInteractiveSelection: true,
                        autofillHints: widget.autofillHints,
                        mouseCursor: widget.enabled
                            ? SystemMouseCursors.text
                            : SystemMouseCursors.basic,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(widget.length),
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          isCollapsed: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
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
  });

  final String digit;
  final TripClipFormFieldDecoration decoration;
  final TextStyle digitStyle;

  @override
  Widget build(BuildContext context) {
    final char = digit.isEmpty ? '' : digit;
    final textStyle = digitStyle.copyWith(color: decoration.foreground);

    return Container(
      height: TripClipOtpInput.cellHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: TripClipOtpInput.cellHorizontalPadding,
      ),
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
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(char, textAlign: TextAlign.center, style: textStyle),
      ),
    );
  }
}
