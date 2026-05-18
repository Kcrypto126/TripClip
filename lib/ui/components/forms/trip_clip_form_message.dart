import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../foundations/app_spacing.dart';

enum TripClipFormMessageKind { neutral, error, warning, success, info }

class TripClipFormMessage extends StatelessWidget {
  const TripClipFormMessage({
    super.key,
    required this.text,
    this.kind = TripClipFormMessageKind.neutral,
    this.iconSize = 16,
    this.colorOverride,
  });

  final String text;
  final TripClipFormMessageKind kind;
  final double iconSize;
  final Color? colorOverride;

  static TextStyle helperStyle(BuildContext context, Color color) {
    final theme = Theme.of(context);
    return (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: color,
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = colorOverride ?? _color(kind, isDark);

    final svgAsset = switch (kind) {
      TripClipFormMessageKind.neutral => null,
      TripClipFormMessageKind.error => 'assets/icons/cancel-circle.svg',
      TripClipFormMessageKind.warning => 'assets/icons/alert-circle.svg',
      TripClipFormMessageKind.success => 'assets/icons/check-circle.svg',
      TripClipFormMessageKind.info => 'assets/icons/info-circle.svg',
    };
    final iconData = switch (kind) {
      TripClipFormMessageKind.neutral => Icons.highlight_off_outlined,
      TripClipFormMessageKind.error => Icons.highlight_off,
      TripClipFormMessageKind.warning => Icons.error_outline,
      TripClipFormMessageKind.success => Icons.check_circle_outline,
      TripClipFormMessageKind.info => Icons.info_outline,
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (svgAsset != null)
          SvgPicture.asset(
            svgAsset,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          )
        else
          Icon(iconData, size: iconSize, color: color),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: TripClipFormMessage.helperStyle(context, color),
          ),
        ),
      ],
    );
  }

  static Color _color(TripClipFormMessageKind kind, bool isDark) {
    switch (kind) {
      case TripClipFormMessageKind.neutral:
        return isDark
            ? TripClipColors.dark.textSubtle
            : TripClipColors.light.textSubtle;
      case TripClipFormMessageKind.error:
        return isDark ? TripClipPalette.error300 : TripClipPalette.error600;
      case TripClipFormMessageKind.warning:
        return isDark ? TripClipPalette.warning300 : TripClipPalette.warning800;
      case TripClipFormMessageKind.success:
        return isDark ? TripClipPalette.success300 : TripClipPalette.success700;
      case TripClipFormMessageKind.info:
        return isDark
            ? TripClipColors.dark.heading
            : TripClipColors.light.heading;
    }
  }
}
