import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Semantic tone for [TripClipBadgeStatus] (red → grey in design order).
enum TripClipBadgeStatusTone {
  danger,
  warning,
  success,
  primary,
  neutral,
}

@immutable
class _StatusToneColors {
  const _StatusToneColors({
    required this.lightBorder,
    required this.lightBackground,
    required this.lightForeground,
    required this.darkBorder,
    required this.darkBackground,
    required this.darkForeground,
  });

  final Color lightBorder;
  final Color lightBackground;
  final Color lightForeground;
  final Color darkBorder;
  final Color darkBackground;
  final Color darkForeground;
}

const Map<TripClipBadgeStatusTone, _StatusToneColors> _kToneColors = {
  TripClipBadgeStatusTone.danger: _StatusToneColors(
    lightBorder: Color(0xFFA4332B),
    lightBackground: Color(0xFFFFE4E1),
    lightForeground: Color(0xFFA4332B),
    darkBorder: Color(0xFFF66659),
    darkBackground: Color(0xFF5E1C16),
    darkForeground: Color(0xFFFFBFB9),
  ),
  TripClipBadgeStatusTone.warning: _StatusToneColors(
    lightBorder: Color(0xFF9E6E0F),
    lightBackground: Color(0xFFFFF8E1),
    lightForeground: Color(0xFF9E6E0F),
    darkBorder: Color(0xFFF6CA54),
    darkBackground: Color(0xFF7A5207),
    darkForeground: Color(0xFFFDEEB3),
  ),
  TripClipBadgeStatusTone.success: _StatusToneColors(
    lightBorder: Color(0xFF1C845C),
    lightBackground: Color(0xFFD9F4E7),
    lightForeground: Color(0xFF1C845C),
    darkBorder: Color(0xFF52C890),
    darkBackground: Color(0xFF0C4D35),
    darkForeground: Color(0xFFB4E8CF),
  ),
  TripClipBadgeStatusTone.primary: _StatusToneColors(
    lightBorder: Color(0xFF0000A3),
    lightBackground: Color(0xFFDCE3FF),
    lightForeground: Color(0xFF0000A3),
    darkBorder: Color(0xFF3F5BFF),
    darkBackground: Color(0xFF000066),
    darkForeground: Color(0xFFBFCBFF),
  ),
  TripClipBadgeStatusTone.neutral: _StatusToneColors(
    lightBorder: Color(0xFF5B636F),
    lightBackground: Color(0xFFEFF2F5),
    lightForeground: Color(0xFF5B636F),
    darkBorder: Color(0xFF8E97A3),
    darkBackground: Color(0xFF1F242B),
    darkForeground: Color(0xFF8E97A3),
  ),
};

/// `badge-status` — optional leading/trailing heart icons around the label.
class TripClipBadgeStatus extends StatelessWidget {
  const TripClipBadgeStatus({
    super.key,
    required this.label,
    required this.tone,
    this.svgAsset = 'assets/icons/heart24.svg',
    this.showLeadingIcon = true,
    this.showTrailingIcon = true,
  });

  final String label;
  final TripClipBadgeStatusTone tone;

  /// Defaults to [heart24.svg] at **16×16** display size.
  final String svgAsset;

  /// Heart before the label. Use with [showTrailingIcon] for left-only / right-only / both / none.
  final bool showLeadingIcon;

  /// Heart after the label.
  final bool showTrailingIcon;

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final c = _kToneColors[tone]!;
    final borderColor = light ? c.lightBorder : c.darkBorder;
    final background = light ? c.lightBackground : c.darkBackground;
    final foreground = light ? c.lightForeground : c.darkForeground;

    final text = Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 20 / 14,
            letterSpacing: 0,
            color: foreground,
          ),
    );

    final icon = SvgPicture.asset(
      svgAsset,
      width: 16,
      height: 16,
      colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
    );

    final rowChildren = <Widget>[
      if (showLeadingIcon) ...[
        icon,
        const SizedBox(width: 4),
      ],
      text,
      if (showTrailingIcon) ...[
        const SizedBox(width: 4),
        icon,
      ],
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: rowChildren,
      ),
    );
  }
}
