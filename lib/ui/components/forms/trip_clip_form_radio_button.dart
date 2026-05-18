import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../foundations/app_spacing.dart';

class TripClipFormRadioButton extends StatelessWidget {
  const TripClipFormRadioButton({
    super.key,
    required this.selected,
    required this.onPressed,
    required this.label,
    this.iconAsset,
    this.width = 176,
    this.radius = 4,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.iconSize = 24,
    this.gap = AppSpacing.xs,
    this.textStyle,
    this.contentAlignment = MainAxisAlignment.center,
  });

  final bool selected;
  final VoidCallback? onPressed;
  final String label;
  final String? iconAsset;
  final double width;
  final double radius;
  final EdgeInsets padding;
  final double iconSize;
  final double gap;
  final TextStyle? textStyle;
  final MainAxisAlignment contentAlignment;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textBase = context.tripClipColors.textBase;

    final Color background;
    final Color textColor;
    final BoxBorder border;

    if (isDark) {
      if (selected) {
        background = TripClipPalette.tertiary300;
        textColor = Colors.white;
        border = Border.all(color: TripClipPalette.tertiary300, width: 1);
      } else {
        background = TripClipPalette.neutral900;
        textColor = textBase;
        border = Border.all(
          color: context.tripClipColors.borderSubtle,
          width: 1,
        );
      }
    } else {
      if (selected) {
        background = TripClipPalette.tertiary500;
        textColor = Colors.white;
        border = Border.all(color: TripClipPalette.tertiary500, width: 1);
      } else {
        background = TripClipPalette.neutral100;
        textColor = textBase;
        border = Border.all(
          color: context.tripClipColors.borderSubtle,
          width: 1,
        );
      }
    }

    final Color iconTint = selected
        ? Colors.white
        : (isDark ? TripClipPalette.neutral300 : TripClipPalette.neutral600);

    Widget child = Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
        border: border,
      ),
      child: Row(
        mainAxisAlignment: contentAlignment,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (iconAsset case final String asset) ...[
            SvgPicture.asset(
              asset,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(iconTint, BlendMode.srcIn),
            ),
            SizedBox(width: gap),
          ],
          Text(
            label,
            textAlign: contentAlignment == MainAxisAlignment.center
                ? TextAlign.center
                : TextAlign.left,
            style: (textStyle ?? Theme.of(context).textTheme.bodySmall)
                ?.copyWith(color: textColor),
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
          borderRadius: BorderRadius.circular(radius),
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
