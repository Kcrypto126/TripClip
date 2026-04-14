import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_colors.dart';

enum TripClipAvatarSize {
  s32(32),
  s40(40),
  s64(64),
  s128(128);

  const TripClipAvatarSize(this.px);
  final double px;
}

class TripClipAvatar extends StatelessWidget {
  const TripClipAvatar({
    super.key,
    this.size = TripClipAvatarSize.s40,
    this.image,
    this.child,
    this.backgroundColor,
  });

  static const String defaultAssetPath = 'assets/images/avatar1.jpg';

  final TripClipAvatarSize size;
  final ImageProvider<Object>? image;

  final Widget? child;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.tripClipColors;
    final borderColor = colors.borderSubtle;
    final bg = backgroundColor ?? colors.surfaceMuted;

    final inner = ClipOval(
      child: SizedBox(
        width: size.px - 2, // account for 1px border on both sides
        height: size.px - 2,
        child: DecoratedBox(
          decoration: BoxDecoration(color: bg),
          child: image != null
              ? Image(image: image!, fit: BoxFit.cover)
              : Image.asset(
                  defaultAssetPath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => child ?? const SizedBox.shrink(),
                ),
        ),
      ),
    );

    return SizedBox(
      width: size.px,
      height: size.px,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Center(child: inner),
      ),
    );
  }
}

