import 'package:flutter/material.dart';
import '../../app/theme/trip_clip_colors.dart';
import '../../app/theme/trip_clip_palette.dart';
import 'trip_clip_avatar.dart';

enum TripClipChatBubbleSide { left, right }

class TripClipChatBubble extends StatelessWidget {
  const TripClipChatBubble({
    super.key,
    required this.text,
    required this.side,
    this.avatarImage,
    this.avatarUrl,
    this.avatarSize = TripClipAvatarSize.s32,
  });

  final String text;
  final TripClipChatBubbleSide side;
  final ImageProvider<Object>? avatarImage;

  final String? avatarUrl;

  final TripClipAvatarSize avatarSize;

  static const double _gap = 8;
  static const double _bubbleMaxWidth = 240;
  static const double _bubblePadding = 12;
  static const double _bubbleRadius = 8;

  static TextStyle _textStyle(BuildContext context, Color color) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(color: color);

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;

    final (bg, fg) = switch (side) {
      TripClipChatBubbleSide.left => (
        light ? TripClipPalette.neutral100 : TripClipPalette.neutral900,
        context.tripClipColors.textBase,
      ),
      TripClipChatBubbleSide.right => (
        context.tripClipColors.heading,
        Colors.white,
      ),
    };

    final avatar = TripClipAvatar(
      size: avatarSize,
      image: avatarImage,
      imageUrl: avatarUrl,
    );

    final bubble = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _bubbleMaxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(_bubbleRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(_bubblePadding),
          child: Text(text, style: _textStyle(context, fg)),
        ),
      ),
    );

    if (side == TripClipChatBubbleSide.left) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          avatar,
          const SizedBox(width: _gap),
          bubble,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        bubble,
        const SizedBox(width: _gap),
        avatar,
      ],
    );
  }
}
