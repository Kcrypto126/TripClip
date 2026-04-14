import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme/trip_clip_palette.dart';
import 'trip_clip_avatar.dart';

enum TripClipChatBubbleSide { left, right }

class TripClipChatBubble extends StatelessWidget {
  const TripClipChatBubble({
    super.key,
    required this.text,
    required this.side,
    this.avatarImage,
  });

  final String text;
  final TripClipChatBubbleSide side;
  final ImageProvider<Object>? avatarImage;

  static const double _gap = 8;
  static const double _bubbleWidth = 240;
  static const double _bubblePadding = 12;
  static const double _bubbleRadius = 8;

  static TextStyle _textStyle(Color color) => GoogleFonts.rubik(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: color,
      );

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;

    final (bg, fg) = switch (side) {
      TripClipChatBubbleSide.left => (
          light ? TripClipPalette.neutral100 : TripClipPalette.neutral900,
          light ? TripClipPalette.tertiary500 : Colors.white,
        ),
      TripClipChatBubbleSide.right => (
          light ? TripClipPalette.primary500 : TripClipPalette.primary400,
          Colors.white,
        ),
    };

    final avatar = TripClipAvatar(
      size: TripClipAvatarSize.s32,
      image: avatarImage,
    );

    final bubble = ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: _bubbleWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(_bubbleRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(_bubblePadding),
          child: Text(
            text,
            style: _textStyle(fg),
          ),
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

