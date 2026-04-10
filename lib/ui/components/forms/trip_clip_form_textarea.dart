import 'package:flutter/material.dart';

import '../../foundations/app_spacing.dart';
import 'trip_clip_form_message.dart';
import 'trip_clip_form_models.dart';
import 'trip_clip_form_tokens.dart';

/// `form-input-textarea` — same chrome and typography as [TripClipFormInput], multiline [TextField].
///
/// Field padding **16×16**. Standard: value/hint **16/24** w400. Large: **36px** (line height 44).
class TripClipFormTextarea extends StatefulWidget {
  const TripClipFormTextarea({
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    this.helperKind,
    this.controller,
    this.enabled = true,
    this.status = TripClipFormStatus.none,
    this.density = TripClipFormDensity.standard,
    this.minLines = 4,
    this.maxLines,
    this.keyboardType = TextInputType.multiline,
    this.textInputAction = TextInputAction.newline,
    this.onSubmitted,
  });

  final String? label;
  final String? hintText;
  final String? helperText;
  /// When set with [helperText], shows [TripClipFormMessage] (icon + semantic color).
  /// If null, helper is plain text; color comes from [status] via tokens.
  final TripClipFormMessageKind? helperKind;
  final TextEditingController? controller;
  final bool enabled;
  final TripClipFormStatus status;
  final TripClipFormDensity density;
  /// Minimum visible lines (height grows with content up to [maxLines] if set).
  final int minLines;
  /// When null, height grows with content after [minLines].
  final int? maxLines;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  State<TripClipFormTextarea> createState() => _TripClipFormTextareaState();
}

class _TripClipFormTextareaState extends State<TripClipFormTextarea> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController? _internal;
  TextEditingController? _bound;

  void _syncDecoration() => setState(() {});

  void _ensureBound() {
    if (_bound != null) return;
    _bindController();
  }

  void _bindController() {
    _bound?.removeListener(_syncDecoration);
    if (widget.controller != null) {
      _internal?.dispose();
      _internal = null;
      _bound = widget.controller;
    } else {
      _internal?.dispose();
      _internal = TextEditingController();
      _bound = _internal;
    }
    _bound!.addListener(_syncDecoration);
  }

  @override
  void initState() {
    super.initState();
    _bindController();
    _focusNode.addListener(_syncDecoration);
  }

  @override
  void didUpdateWidget(covariant TripClipFormTextarea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _bindController();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    _ensureBound();
  }

  @override
  void dispose() {
    _bound?.removeListener(_syncDecoration);
    _focusNode.removeListener(_syncDecoration);
    _internal?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ensureBound();
    final controller = _bound!;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final focused = _focusNode.hasFocus;
    final hasValue = controller.text.isNotEmpty;
    final dec = TripClipFormFieldDecoration.field(
      isDark: isDark,
      enabled: widget.enabled,
      hasValue: hasValue,
      focused: focused,
      status: widget.status,
      density: widget.density,
    );

    final labelStyle = theme.textTheme.bodySmall?.copyWith(
          color: dec.label,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height: 20 / 14,
          letterSpacing: 0,
          fontFeatures: const [
            FontFeature.tabularFigures(),
            FontFeature.liningFigures(),
          ],
        );

    final isLarge = widget.density == TripClipFormDensity.large;
    final fieldFontSize = isLarge ? 36.0 : 16.0;
    final fieldLineHeight = isLarge ? 44 / 36 : 24 / 16;
    final fieldStyle = theme.textTheme.bodyLarge?.copyWith(
          color: dec.foreground,
          fontSize: fieldFontSize,
          height: fieldLineHeight,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        );

    const fieldPadding = 16.0;
    const radius = 4.0;

    final showDisabledOpacity = !widget.enabled;

    Widget field = Container(
      decoration: BoxDecoration(
        color: dec.fill,
        borderRadius: BorderRadius.circular(radius),
        border: dec.borderWidth > 0
            ? Border.all(color: dec.borderColor, width: dec.borderWidth)
            : null,
      ),
      alignment: Alignment.topLeft,
      child: TextField(
        controller: controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onSubmitted: widget.onSubmitted,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        style: fieldStyle,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: fieldStyle?.copyWith(color: dec.hintOrPlaceholder),
          contentPadding: const EdgeInsets.all(fieldPadding),
        ),
      ),
    );

    Widget? helper;
    final ht = widget.helperText;
    if (ht != null && ht.trim().isNotEmpty) {
      if (widget.helperKind != null) {
        helper = TripClipFormMessage(
          text: ht.trim(),
          kind: widget.helperKind!,
          colorOverride: dec.helper,
        );
      } else if (widget.status != TripClipFormStatus.none) {
        final kind = switch (widget.status) {
          TripClipFormStatus.error => TripClipFormMessageKind.error,
          TripClipFormStatus.warning => TripClipFormMessageKind.warning,
          TripClipFormStatus.success => TripClipFormMessageKind.success,
          TripClipFormStatus.none => TripClipFormMessageKind.neutral,
        };
        helper = TripClipFormMessage(
          text: ht.trim(),
          kind: kind,
          colorOverride: dec.helper,
        );
      } else {
        helper = Text(
          ht.trim(),
          style: TripClipFormMessage.helperStyle(context, dec.helper),
        );
      }
    }

    Widget column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null && widget.label!.trim().isNotEmpty) ...[
          Text(widget.label!.trim(), style: labelStyle),
          const SizedBox(height: AppSpacing.sm),
        ],
        field,
        if (helper != null) ...[
          const SizedBox(height: AppSpacing.sm),
          helper,
        ],
      ],
    );

    if (showDisabledOpacity) {
      column = Opacity(opacity: 0.4, child: column);
    }

    return column;
  }
}
