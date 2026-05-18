import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_colors.dart';

enum TripClipAvatarSize {
  s28(28),
  s32(32),
  s40(40),
  s48(48),
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
    this.imageUrl,
    this.child,
    this.backgroundColor,
    this.placeholder,
  });

  static const String defaultAvatarUrl =
      'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/john-doe.webp';

  final TripClipAvatarSize size;
  final ImageProvider<Object>? image;

  final String? imageUrl;

  final Widget? child;

  final Color? backgroundColor;

  final Widget? placeholder;

  static ImageProvider<Object>? imageProviderFromUrlOrAsset(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) return null;

    if (value.startsWith('assets/')) {
      return AssetImage(value);
    }

    final uri = Uri.tryParse(value);
    final scheme = uri?.scheme.toLowerCase();
    if (scheme == 'http' || scheme == 'https') {
      return NetworkImage(value);
    }

    return null;
  }

  ImageProvider<Object> _resolvedProvider() {
    if (image != null) return image!;
    final fromUrl = imageProviderFromUrlOrAsset(imageUrl);
    if (fromUrl != null) return fromUrl;
    return NetworkImage(defaultAvatarUrl);
  }

  Widget _avatarImage(ImageProvider<Object> provider) {
    return Image(
      image: provider,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(color: Color(0xFF1C2430)),
            ),
            Positioned.fill(child: child),
          ],
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return child ?? const DecoratedBox(
          decoration: BoxDecoration(color: Color(0xFF1C2430)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.tripClipColors;
    final borderColor = colors.borderSubtle;
    final bg = backgroundColor ?? colors.surfaceMuted;

    final inner = placeholder != null
        ? ClipOval(
            child: SizedBox(
              width: size.px - 2, // account for 1px border on both sides
              height: size.px - 2,
              child: DecoratedBox(
                decoration: BoxDecoration(color: bg),
                child: Center(child: placeholder!),
              ),
            ),
          )
        : ClipOval(
            child: SizedBox(
              width: size.px - 2, // account for 1px border on both sides
              height: size.px - 2,
              child: DecoratedBox(
                decoration: BoxDecoration(color: bg),
                child: _avatarImage(_resolvedProvider()),
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
