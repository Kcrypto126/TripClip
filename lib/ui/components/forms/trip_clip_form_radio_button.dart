import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/trip_clip_palette.dart';
import '../../foundations/app_spacing.dart';

class TripClipFormRadioButton extends StatelessWidget {
  const TripClipFormRadioButton({
    super.key,
    required this.selected,
    required this.onPressed,
    required this.label,
    this.iconAsset = defaultIconAsset,
    this.width = 176,
  });

  static const String defaultIconAsset = 'assets/icons/apartment.svg';

  static const double _radius = 4;

  final bool selected;
  final VoidCallback? onPressed;
  final String label;
  final String iconAsset;
  final double width;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color background;
    final Color iconColor;
    final Color textColor;
    final BoxBorder? border;

    if (isDark) {
      if (selected) {
        background = TripClipPalette.tertiary300;
        iconColor = Colors.white;
        textColor = Colors.white;
        border = Border.all(color: TripClipPalette.tertiary300, width: 1);
      } else {
        background = TripClipPalette.neutral900;
        iconColor = TripClipPalette.neutral300;
        textColor = Colors.white;
        border = Border.all(color: TripClipPalette.neutral850, width: 1);
      }
    } else {
      if (selected) {
        background = TripClipPalette.tertiary500;
        iconColor = Colors.white;
        textColor = Colors.white;
        border = null;
      } else {
        background = TripClipPalette.neutral100;
        iconColor = TripClipPalette.neutral600;
        textColor = TripClipPalette.tertiary500;
        border = null;
      }
    }

    Widget child = Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(_radius),
        border: border,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconAsset,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0,
                  color: textColor,
                ),
          ),
        ],
      ),
    );

    child = Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(_radius),
          child: child,
        ),
      ),
    );

    if (!enabled) {
      child = Opacity(opacity: 0.4, child: child);
    }

    return child;
  }
}
