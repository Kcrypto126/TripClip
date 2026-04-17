import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/trip_clip_palette.dart';
import '../../foundations/app_spacing.dart';
import 'trip_clip_form_models.dart';
import 'trip_clip_form_tokens.dart';

class TripClipAtomInput extends StatefulWidget {
  const TripClipAtomInput({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.leading,
    this.trailing,
    this.showLeading = true,
    this.showTrailing = true,
    this.hideTrailingWhenStatusNone = false,
    this.leadingIconAsset,
    this.trailingIconAsset,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.status = TripClipFormStatus.none,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
  });

  static const String defaultLeadingIconAsset = 'assets/icons/user1.svg';

  static const String defaultTrailingIconAsset =
      'assets/icons/chevron-down.svg';

  static String defaultTrailingIconAssetForStatus(TripClipFormStatus status) {
    return switch (status) {
      TripClipFormStatus.none => defaultTrailingIconAsset,
      TripClipFormStatus.error => 'assets/icons/cancel-circle.svg',
      TripClipFormStatus.warning => 'assets/icons/alert-circle.svg',
      TripClipFormStatus.success => 'assets/icons/check-circle.svg',
    };
  }

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final Widget? leading;
  final Widget? trailing;
  final bool showLeading;
  final bool showTrailing;
  final bool hideTrailingWhenStatusNone;
  final String? leadingIconAsset;
  final String? trailingIconAsset;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool enabled;
  final TripClipFormStatus status;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  static const EdgeInsets padding = EdgeInsets.symmetric(
    vertical: 8,
    horizontal: 16,
  );

  /// Matches [TripClipFormInput] field radius.
  static const double radius = 4;

  @override
  State<TripClipAtomInput> createState() => _TripClipAtomInputState();
}

class _TripClipAtomInputState extends State<TripClipAtomInput> {
  FocusNode? _internalFocus;
  FocusNode? _boundFocus;
  TextEditingController? _internal;
  TextEditingController? _bound;

  FocusNode get _focusNode {
    _boundFocus ??= (widget.focusNode ?? (_internalFocus ??= FocusNode()));
    return _boundFocus!;
  }

  void _onFocusChanged() => setState(() {});

  void _onControllerChanged() => setState(() {});

  void _ensureBound() {
    if (_bound != null) return;
    _bindController();
  }

  void _bindController() {
    _bound?.removeListener(_onControllerChanged);
    if (widget.controller != null) {
      _internal?.dispose();
      _internal = null;
      _bound = widget.controller;
    } else {
      _internal?.dispose();
      _internal = TextEditingController();
      _bound = _internal;
    }
    _bound!.addListener(_onControllerChanged);
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
    _bindController();
  }

  @override
  void didUpdateWidget(covariant TripClipAtomInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _bindController();
    }
    if (oldWidget.focusNode != widget.focusNode) {
      _boundFocus?.removeListener(_onFocusChanged);
      _internalFocus?.dispose();
      _internalFocus = null;
      _boundFocus = null;
      _focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    _ensureBound();
  }

  @override
  void dispose() {
    _bound?.removeListener(_onControllerChanged);
    _internal?.dispose();
    _boundFocus?.removeListener(_onFocusChanged);
    _internalFocus?.dispose();
    super.dispose();
  }

  bool get _hasValue => _bound?.text.isNotEmpty ?? false;

  @override
  Widget build(BuildContext context) {
    _ensureBound();
    final controller = _bound!;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final focused = _focusNode.hasFocus;
    final dec = TripClipFormFieldDecoration.atom(
      isDark: isDark,
      enabled: widget.enabled,
      focused: focused,
      hasValue: _hasValue,
      status: widget.status,
    );

    final showDisabledOpacity = !widget.enabled;

    final fieldStyle = theme.textTheme.bodyLarge?.copyWith(
      color: dec.foreground,
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    );

    Widget? leading;
    if (widget.showLeading) {
      final leadingColor = widget.status != TripClipFormStatus.none
          ? dec.hintOrPlaceholder
          : ((focused || _hasValue)
                ? dec.foreground
                : TripClipPalette.neutral500);
      leading =
          widget.leading ??
          _TripClipAtomSvg(
            asset:
                widget.leadingIconAsset ??
                TripClipAtomInput.defaultLeadingIconAsset,
            color: leadingColor,
          );
    }

    Widget? trailing;
    if (widget.showTrailing) {
      final shouldHideTrailing =
          widget.hideTrailingWhenStatusNone &&
          widget.status == TripClipFormStatus.none &&
          widget.trailing == null &&
          widget.trailingIconAsset == null;
      if (shouldHideTrailing) {
        trailing = null;
      } else {
        final trailingColor = widget.status != TripClipFormStatus.none
            ? dec.hintOrPlaceholder
            : dec.foreground;
        trailing =
            widget.trailing ??
            _TripClipAtomSvg(
              asset:
                  widget.trailingIconAsset ??
                  TripClipAtomInput.defaultTrailingIconAssetForStatus(
                    widget.status,
                  ),
              color: trailingColor,
            );
      }
    } else {
      // Still allow a custom trailing widget even when the default trailing icon is hidden.
      trailing = widget.trailing;
    }

    final paddedRow = Padding(
      padding: TripClipAtomInput.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...?leading == null
              ? null
              : <Widget>[leading, const SizedBox(width: AppSpacing.xs)],
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              onSubmitted: widget.onSubmitted,
              style: fieldStyle,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: fieldStyle?.copyWith(color: dec.hintOrPlaceholder),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );

    Widget child = Container(
      decoration: BoxDecoration(
        color: dec.fill,
        borderRadius: BorderRadius.circular(TripClipAtomInput.radius),
        border: dec.borderWidth > 0
            ? Border.all(color: dec.borderColor, width: dec.borderWidth)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: widget.onTap != null
            ? InkWell(
                onTap: widget.enabled ? widget.onTap : null,
                borderRadius: BorderRadius.circular(TripClipAtomInput.radius),
                child: paddedRow,
              )
            : paddedRow,
      ),
    );

    if (showDisabledOpacity) {
      child = Opacity(opacity: 0.4, child: child);
    }

    return child;
  }
}

class _TripClipAtomSvg extends StatelessWidget {
  const _TripClipAtomSvg({required this.asset, required this.color});

  final String asset;
  final Color color;

  static const double size = 24;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
