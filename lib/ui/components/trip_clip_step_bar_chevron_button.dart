import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/trip_clip_colors.dart';

class TripClipStepBarChevronButton extends StatelessWidget {
  const TripClipStepBarChevronButton({
    super.key,
    required this.asset,
    required this.iconColor,
    this.onTap,
    this.alignEnd = false,
    this.materialColor,
  });

  static const double tapSize = 40;
  static const double iconSize = 24;

  final String asset;
  final Color iconColor;
  final VoidCallback? onTap;

  final bool alignEnd;

  final Color? materialColor;

  @override
  Widget build(BuildContext context) {
    final bg = materialColor ?? context.tripClipColors.pageBackground;
    final alignment = alignEnd
        ? AlignmentDirectional.centerEnd
        : AlignmentDirectional.centerStart;

    return SizedBox(
      width: tapSize,
      child: Align(
        alignment: alignment,
        child: Material(
          color: bg,
          surfaceTintColor: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: tapSize,
              height: tapSize,
              child: Center(
                child: SvgPicture.asset(
                  asset,
                  width: iconSize,
                  height: iconSize,
                  alignment: Alignment.center,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
