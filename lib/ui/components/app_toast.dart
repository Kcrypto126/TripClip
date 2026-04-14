import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme/trip_clip_palette.dart';
import '../foundations/app_spacing.dart';

enum AppToastKind { error, warning, success, info }

class AppToast {
  AppToast._();

  static void show(
    BuildContext context, {
    required String message,
    required AppToastKind kind,
    Duration duration = const Duration(seconds: 4),
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _ToastOverlay(
        message: message,
        kind: kind,
        onDismiss: () {
          entry.remove();
        },
        duration: duration,
      ),
    );
    overlay.insert(entry);
  }
}

class _ToastOverlay extends StatefulWidget {
  const _ToastOverlay({
    required this.message,
    required this.kind,
    required this.onDismiss,
    required this.duration,
  });

  final String message;
  final AppToastKind kind;
  final VoidCallback onDismiss;
  final Duration duration;

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.duration, () {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: _ToastBody(
            message: widget.message,
            kind: widget.kind,
            onClose: widget.onDismiss,
          ),
        ),
      ),
    );
  }
}

class _ToastBody extends StatelessWidget {
  const _ToastBody({
    required this.message,
    required this.kind,
    required this.onClose,
  });

  final String message;
  final AppToastKind kind;
  final VoidCallback onClose;

  static const double _radius = 8;
  static const double _padding = 16;
  static const double _iconSize = 24;
  static const double _gap = 4;

  static const _lightErrorBorder = Color(0xFFA4332B);
  static const _lightWarningBorder = Color(0xFF9E6E0F);
  static const _lightSuccessBorder = Color(0xFF1C845C);
  static const _lightInfoBorder = Color(0xFF0000A3);

  static const _darkErrorBorder = Color(0xFFF66659);
  static const _darkWarningBorder = Color(0xFFF6CA54);
  static const _darkSuccessBorder = Color(0xFF52C890);
  static const _darkInfoBorder = Color(0xFF3F5BFF);

  static const _lightErrorBg = Color(0xFFFFE4E1);
  static const _lightWarningBg = Color(0xFFFFF8E1);
  static const _lightSuccessBg = Color(0xFFD9F4E7);
  static const _lightInfoBg = TripClipPalette.primary100; // #DCE3FF

  static const _darkErrorBg = Color(0xFF5E1C16);
  static const _darkWarningBg = Color(0xFF7A5207);
  static const _darkSuccessBg = Color(0xFF0C4D35);
  static const _darkInfoBg = Color(0xFF000066);

  static const _lightErrorIcon = Color(0xFFA4332B);
  static const _lightWarningIcon = Color(0xFF9E6E0F);
  static const _lightSuccessIcon = Color(0xFF1C845C);
  static const _lightInfoIcon = Color(0xFF0000A3);

  static const _darkErrorIcon = Color(0xFFFFBFB9);
  static const _darkWarningIcon = Color(0xFFFDEEB3);
  static const _darkSuccessIcon = Color(0xFFB4E8CF);
  static const _darkInfoIcon = TripClipPalette.primary200; // #BFCBFF

  String get _iconAsset {
    return switch (kind) {
      AppToastKind.error => 'assets/icons/cancel-circle2.svg',
      AppToastKind.warning => 'assets/icons/alert-circle2.svg',
      AppToastKind.success => 'assets/icons/tick-circle.svg',
      AppToastKind.info => 'assets/icons/info-circle2.svg',
    };
  }

  ({Color bg, Color border, Color iconAndDivider}) _colors(bool light) {
    return switch (kind) {
      AppToastKind.error => (
          bg: light ? _lightErrorBg : _darkErrorBg,
          border: light ? _lightErrorBorder : _darkErrorBorder,
          iconAndDivider: light ? _lightErrorIcon : _darkErrorIcon,
        ),
      AppToastKind.warning => (
          bg: light ? _lightWarningBg : _darkWarningBg,
          border: light ? _lightWarningBorder : _darkWarningBorder,
          iconAndDivider: light ? _lightWarningIcon : _darkWarningIcon,
        ),
      AppToastKind.success => (
          bg: light ? _lightSuccessBg : _darkSuccessBg,
          border: light ? _lightSuccessBorder : _darkSuccessBorder,
          iconAndDivider: light ? _lightSuccessIcon : _darkSuccessIcon,
        ),
      AppToastKind.info => (
          bg: light ? _lightInfoBg : _darkInfoBg,
          border: light ? _lightInfoBorder : _darkInfoBorder,
          iconAndDivider: light ? _lightInfoIcon : _darkInfoIcon,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final light = theme.brightness == Brightness.light;
    final c = _colors(light);

    final textStyle = GoogleFonts.rubik(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: c.iconAndDivider,
    );

    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.bg,
          borderRadius: BorderRadius.circular(_radius),
          border: Border.all(color: c.border, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: Row(
            children: [
              SvgPicture.asset(
                _iconAsset,
                width: _iconSize,
                height: _iconSize,
                colorFilter: ColorFilter.mode(c.iconAndDivider, BlendMode.srcIn),
              ),
              const SizedBox(width: _gap),
              Expanded(
                child: Text(
                  message,
                  style: textStyle,
                ),
              ),
              Container(
                width: 1,
                height: _iconSize,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                color: c.iconAndDivider,
              ),
              SizedBox(
                width: _iconSize,
                height: _iconSize,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(),
                  onPressed: onClose,
                  icon: Icon(Icons.close, size: 20, color: c.iconAndDivider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
