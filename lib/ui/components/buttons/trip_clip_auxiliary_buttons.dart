import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../foundations/app_spacing.dart';

class TripClipLabeledCircleActionButton extends StatefulWidget {
  const TripClipLabeledCircleActionButton({
    super.key,
    this.icon,
    this.svgAsset,
    this.svgAssetSelected,
    required this.label,
    this.onPressed,
    this.selected = false,
    this.diameter = 48,
    this.inset = 12,
  }) : assert(
         (icon != null) ^ (svgAsset != null),
         'Provide exactly one of icon or svgAsset',
       ),
       assert(diameter > 2 * inset, 'diameter must exceed 2 * inset'),
       assert(inset >= 0);

  final IconData? icon;
  final String? svgAsset;
  final String? svgAssetSelected;
  final String label;
  final VoidCallback? onPressed;
  final bool selected;
  final double diameter;
  final double inset;

  @override
  State<TripClipLabeledCircleActionButton> createState() =>
      _TripClipLabeledCircleActionButtonState();
}

class _TripClipLabeledCircleActionButtonState
    extends State<TripClipLabeledCircleActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final idleFill = isDark
        ? TripClipPalette.neutral900
        : TripClipPalette.neutral100;
    final idleBorder = context.tripClipColors.borderSubtle;
    final idleIcon = context.tripClipColors.textSubtle;

    final idlePressedFill = context.tripClipColors.borderSubtle;
    const activeFill = TripClipPalette.buttonActionActiveFill;
    final activePressedFill =
        Color.lerp(activeFill, Colors.black, 0.12) ?? activeFill;

    final active = widget.selected;
    final interactive = widget.onPressed != null;
    final showPressed = interactive && _pressed;

    final fill = showPressed
        ? (active ? activePressedFill : idlePressedFill)
        : (active ? activeFill : idleFill);
    final activeBorder = TripClipPalette.buttonActionActiveFill;
    final iconColor = active ? Colors.white : idleIcon;
    final iconSize = widget.diameter - 2 * widget.inset;

    final String? svgResolved = widget.svgAsset == null
        ? null
        : (active
              ? (widget.svgAssetSelected ??
                  _defaultFilledSvgPath(widget.svgAsset!))
              : widget.svgAsset);

    final Widget iconChild = svgResolved != null
        ? SvgPicture.asset(
            svgResolved,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          )
        : Icon(widget.icon!, color: iconColor, size: iconSize);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: fill,
          shape: CircleBorder(
            side: BorderSide(color: active ? activeBorder : idleBorder),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          shadowColor: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            customBorder: const CircleBorder(),
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.all<Color?>(Colors.transparent),
            onTapDown: interactive
                ? (_) => setState(() => _pressed = true)
                : null,
            onTapUp: interactive
                ? (_) => setState(() => _pressed = false)
                : null,
            onTapCancel: interactive
                ? () => setState(() => _pressed = false)
                : null,
            child: SizedBox(
              width: widget.diameter,
              height: widget.diameter,
              child: Padding(
                padding: EdgeInsets.all(widget.inset),
                child: iconChild,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          widget.label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: TripClipPalette.buttonActionCaption,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

String _defaultFilledSvgPath(String svgAsset) {
  final i = svgAsset.toLowerCase().lastIndexOf('.svg');
  if (i == -1) {
    return '${svgAsset}_filled.svg';
  }
  return '${svgAsset.substring(0, i)}_filled${svgAsset.substring(i)}';
}

class TripClipFavoriteListButton extends StatelessWidget {
  const TripClipFavoriteListButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
    this.size = 24,
    this.inset = 4,
    this.svgAsset,
    this.svgAssetFavorite,
  }) : assert(size > 2 * inset, 'size must exceed 2 * inset'),
       assert(inset >= 0);

  final bool isFavorite;
  final VoidCallback? onPressed;
  final double size;
  final double inset;
  final String? svgAsset;
  final String? svgAssetFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final idleFill = isDark
        ? TripClipPalette.neutral900
        : TripClipPalette.neutral100;
    final idleBorder = context.tripClipColors.borderSubtle;
    final idleIcon = context.tripClipColors.textSubtle;
    final overlayBase = theme.colorScheme.onSurface;

    final favoriteFill = TripClipPalette.secondary500;
    final fill = isFavorite ? favoriteFill : idleFill;
    final fg = isFavorite ? Colors.white : idleIcon;
    final iconSize = size - 2 * inset;

    final String? svgResolved = svgAsset == null
        ? null
        : (isFavorite
              ? (svgAssetFavorite ?? _defaultFilledSvgPath(svgAsset!))
              : svgAsset);

    final Widget iconChild = svgResolved != null
        ? SvgPicture.asset(
            svgResolved,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
          )
        : Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            size: iconSize,
            color: fg,
          );

    return Material(
      color: fill,
      shape: CircleBorder(
        side: BorderSide(color: isFavorite ? favoriteFill : idleBorder),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shadowColor: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (onPressed == null) return null;
          if (states.contains(WidgetState.pressed)) {
            return overlayBase.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.hovered)) {
            return overlayBase.withValues(alpha: 0.06);
          }
          return null;
        }),
        child: SizedBox(
          width: size,
          height: size,
          child: Padding(padding: EdgeInsets.all(inset), child: iconChild),
        ),
      ),
    );
  }
}

class TripClipSubNavButton extends StatelessWidget {
  const TripClipSubNavButton({
    super.key,
    this.icon,
    this.svgAsset,
    required this.label,
    this.onPressed,
    this.expanded = false,
    this.selected = false,
  }) : assert(
         (icon != null) ^ (svgAsset != null),
         'Provide exactly one of icon or svgAsset',
       );

  final IconData? icon;
  final String? svgAsset;
  final String label;
  final VoidCallback? onPressed;
  final bool expanded;
  final bool selected;

  static const double _radius = 4;
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    vertical: 6,
    horizontal: 8,
  );
  static const double _iconSize = 16;
  static const double _iconGap = 4;

  static const Color _bgLightIdle = Color(0xFFEFF2F5);
  static const Color _bgLightSelected = Color(0xFF141E46);
  static const Color _bgDarkIdle = Color(0xFF1F242B);
  static const Color _bgDarkSelected = Color(0xFF7C86AE);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = selected
        ? (isDark ? _bgDarkSelected : _bgLightSelected)
        : (isDark ? _bgDarkIdle : _bgLightIdle);
    final fg = selected ? Colors.white : context.tripClipColors.textSubtle;
    final overlay = selected || isDark ? Colors.white : Colors.black;

    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: fg,
      fontFeatures: const [
        FontFeature.tabularFigures(),
        FontFeature.liningFigures(),
      ],
    );

    final Widget leadingIcon = svgAsset != null
        ? SvgPicture.asset(
            svgAsset!,
            width: _iconSize,
            height: _iconSize,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
          )
        : Icon(icon!, size: _iconSize, color: fg);

    Widget chip = Material(
      color: bg,
      borderRadius: BorderRadius.circular(_radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(_radius),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (onPressed == null) return null;
          if (states.contains(WidgetState.pressed)) {
            return overlay.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.hovered)) {
            return overlay.withValues(alpha: 0.06);
          }
          return null;
        }),
        child: Padding(
          padding: _padding,
          child: Row(
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leadingIcon,
              const SizedBox(width: _iconGap),
              Text(label, style: labelStyle),
            ],
          ),
        ),
      ),
    );

    if (expanded) {
      return SizedBox(width: double.infinity, child: chip);
    }
    return chip;
  }
}

class TripClipSquareIconButton extends StatefulWidget {
  const TripClipSquareIconButton({
    super.key,
    this.icon,
    this.svgAsset = 'assets/icons/pencil-edit.svg',
    this.onPressed,
    this.size = 32,
    this.radius = 4,
    this.inset = 0,
    this.borderColor,
    this.borderWidth = 1,
    this.backgroundColor,
    this.pressedBackgroundColor,
    this.iconColor,
  }) : assert(
         (icon != null) ^ (svgAsset != null),
         'Provide exactly one of icon or svgAsset',
       );

  final IconData? icon;
  final String? svgAsset;
  final VoidCallback? onPressed;
  final double size;
  final double radius;
  final double inset;
  final Color? borderColor;
  final double borderWidth;
  final Color? backgroundColor;
  final Color? pressedBackgroundColor;
  final Color? iconColor;

  @override
  State<TripClipSquareIconButton> createState() =>
      _TripClipSquareIconButtonState();
}

class _TripClipSquareIconButtonState extends State<TripClipSquareIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final resolvedBorder =
        widget.borderColor ?? context.tripClipColors.borderSubtle;
    final resolvedBg = widget.backgroundColor ??
        (isDark ? TripClipPalette.neutral1000 : Colors.white);
    final resolvedPressed =
        widget.pressedBackgroundColor ??
        (isDark ? TripClipPalette.neutral900 : TripClipPalette.neutral100);
    final resolvedIcon =
        widget.iconColor ?? context.tripClipColors.textSubtle;

    final inner = widget.size - 2 * widget.inset;
    final iconSize = inner * 0.5625;
    final filled = widget.onPressed != null && _pressed;
    final bg = filled ? resolvedPressed : resolvedBg;

    final Widget iconChild = widget.svgAsset != null
        ? SvgPicture.asset(
            widget.svgAsset!,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(resolvedIcon, BlendMode.srcIn),
          )
        : Icon(widget.icon!, size: iconSize, color: resolvedIcon);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(widget.radius),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTapDown: widget.onPressed != null
            ? (_) => setState(() => _pressed = true)
            : null,
        onTapUp: widget.onPressed != null
            ? (_) => setState(() => _pressed = false)
            : null,
        onTapCancel: widget.onPressed != null
            ? () => setState(() => _pressed = false)
            : null,
        child: Container(
          width: widget.size,
          height: widget.size,
          padding: EdgeInsets.all(widget.inset),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(
              color: resolvedBorder,
              width: widget.borderWidth,
            ),
          ),
          alignment: Alignment.center,
          child: iconChild,
        ),
      ),
    );
  }
}
