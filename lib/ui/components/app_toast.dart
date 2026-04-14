import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_colors.dart';
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

  TripClipToastScheme _scheme(TripClipColors c) {
    return switch (kind) {
      AppToastKind.error => c.toastError,
      AppToastKind.warning => c.toastWarning,
      AppToastKind.success => c.toastSuccess,
      AppToastKind.info => c.toastInfo,
    };
  }

  (IconData, double) get _icon {
    return switch (kind) {
      AppToastKind.error => (Icons.close, 16),
      AppToastKind.warning => (Icons.priority_high, 18),
      AppToastKind.success => (Icons.check, 16),
      AppToastKind.info => (Icons.info_outline, 16),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.tripClipColors;
    final scheme = _scheme(colors);
    final theme = Theme.of(context);
    final (iconData, iconSize) = _icon;

    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.border),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: scheme.iconBackground,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  iconData,
                  size: iconSize,
                  color: scheme.iconForeground,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.foreground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 28,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                color: scheme.divider,
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onClose,
                icon: Icon(Icons.close, color: scheme.foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
