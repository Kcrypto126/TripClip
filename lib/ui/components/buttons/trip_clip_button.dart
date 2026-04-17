import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'trip_clip_button_models.dart';
import 'trip_clip_button_styles.dart';

class TripClipButton extends StatelessWidget {
  const TripClipButton({
    super.key,
    required this.variant,
    required this.onPressed,
    this.label,
    this.icon,
    this.svgAsset,
    this.tintSvg = true,
    this.iconPlacement = TripClipButtonIconPlacement.none,
    this.expanded = false,
    this.styleOverride,
  }) : assert(
         icon == null || svgAsset == null,
         'TripClipButton: use at most one of icon and svgAsset.',
       );

  final TripClipButtonVariant variant;
  final VoidCallback? onPressed;
  final String? label;
  final IconData? icon;
  final String? svgAsset;
  final bool tintSvg;
  final TripClipButtonIconPlacement iconPlacement;
  final bool expanded;
  final ButtonStyle? styleOverride;

  bool get _iconOnly => iconPlacement == TripClipButtonIconPlacement.iconOnly;

  @override
  Widget build(BuildContext context) {
    final hasGraphic = icon != null || svgAsset != null;

    if (_iconOnly) {
      assert(
        hasGraphic,
        'TripClipButton: icon or svgAsset is required when iconOnly.',
      );
    } else {
      assert(
        (label != null && label!.trim().isNotEmpty) || hasGraphic,
        'TripClipButton: provide a non-empty label and/or an icon/svgAsset.',
      );
      if (iconPlacement == TripClipButtonIconPlacement.leading ||
          iconPlacement == TripClipButtonIconPlacement.trailing) {
        assert(
          hasGraphic,
          'TripClipButton: icon or svgAsset is required for leading/trailing.',
        );
      }
    }

    final style =
        styleOverride ??
        TripClipButtonStyles.style(context, variant, iconOnly: _iconOnly);

    final child = _buildChild();

    Widget button = switch (variant) {
      TripClipButtonVariant.secondary => OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      TripClipButtonVariant.tertiary => TextButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      _ => FilledButton(onPressed: onPressed, style: style, child: child),
    };

    if (expanded) {
      button = SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Widget _buildChild() {
    if (_iconOnly) {
      return svgAsset != null
          ? _TripClipButtonSvgIcon(asset: svgAsset!, tint: tintSvg)
          : Icon(icon, size: TripClipButtonStyles.iconSize);
    }

    const gap = SizedBox(width: TripClipButtonStyles.iconGap);
    final iconWidget = svgAsset != null
        ? _TripClipButtonSvgIcon(asset: svgAsset!, tint: tintSvg)
        : (icon == null
              ? null
              : Icon(icon, size: TripClipButtonStyles.iconSize));

    final children = <Widget>[];

    if (iconWidget != null &&
        iconPlacement == TripClipButtonIconPlacement.leading) {
      children.add(iconWidget);
      children.add(gap);
    }

    if (label != null && label!.trim().isNotEmpty) {
      children.add(Text(label!.trim()));
    }

    if (iconWidget != null &&
        iconPlacement == TripClipButtonIconPlacement.trailing) {
      if (children.isNotEmpty) children.add(gap);
      children.add(iconWidget);
    }

    return Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

class _TripClipButtonSvgIcon extends StatelessWidget {
  const _TripClipButtonSvgIcon({required this.asset, required this.tint});

  final String asset;
  final bool tint;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final color = iconTheme.color ?? Theme.of(context).colorScheme.onSurface;

    return SvgPicture.asset(
      asset,
      width: TripClipButtonStyles.iconSize,
      height: TripClipButtonStyles.iconSize,
      fit: BoxFit.contain,
      colorFilter: tint ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }
}
