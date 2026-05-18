import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../ui/components/trip_clip_avatar.dart';
import '../../../ui/components/trip_clip_chat_bubble.dart';
import '../../../ui/components/trip_clip_title_bar.dart';

class TripClipMessagePage extends StatefulWidget {
  const TripClipMessagePage({
    super.key,
    this.userName = 'John Smith',
    this.avatarUrl,
    this.ratingText = '4.8 (8)',
  });

  final String userName;
  final String? avatarUrl;
  final String ratingText;

  @override
  State<TripClipMessagePage> createState() => _TripClipMessagePageState();
}

class _TripClipMessagePageState extends State<TripClipMessagePage> {
  static const String _kDefaultPhoto =
      'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/john-doe.webp';

  static const double _sendSize = 44;

  late final TextEditingController _messageController;
  late final List<_ChatItem> _items;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _items = _parseChatPayload(_kMockBackendResponseJson);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _items.add(_ChatItem.message(side: _ChatSide.me, text: text));
      _messageController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final textSubtle = context.tripClipColors.textSubtle;
    final heading = context.tripClipColors.heading;
    final textBase = context.tripClipColors.textBase;
    final border = context.tripClipColors.borderSubtle;
    final pageBg = context.tripClipColors.pageBackground;

    final peerUrl = (widget.avatarUrl != null &&
            widget.avatarUrl!.trim().isNotEmpty)
        ? widget.avatarUrl!.trim()
        : _kDefaultPhoto;

    final nameLinkStyle = t.bodySmall!.copyWith(
      color: heading,
      decoration: TextDecoration.underline,
      decorationColor: heading,
    );
    final ratingStyle = t.bodySmall!.copyWith(color: textSubtle);
    final timestampStyle = t.bodySmall!.copyWith(color: textSubtle);

    final meAvatarUrl = _kDefaultPhoto;

    return Scaffold(
      backgroundColor: pageBg,
      resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TripClipTitleBar(
            title: 'Message',
            includeStatusBarInset: true,
            onBack: () => Navigator.of(context).maybePop(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: _peerHeader(
              userName: widget.userName,
              nameStyle: nameLinkStyle,
              ratingStyle: ratingStyle,
              ratingText: widget.ratingText,
              subtleColor: textSubtle,
              peerUrl: peerUrl,
            ),
          ),
          Divider(height: 1, thickness: 1, color: border),
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemCount: _items.length,
              separatorBuilder: (context, index) => SizedBox(
                height: _items[index].kind == _ChatItemKind.timestamp
                    ? 12
                    : 12,
              ),
              itemBuilder: (context, index) {
                final item = _items[index];
                return switch (item.kind) {
                  _ChatItemKind.timestamp => _timestampLabel(
                      item.timestampText!,
                      timestampStyle,
                    ),
                  _ChatItemKind.message => TripClipChatBubble(
                      side: item.side == _ChatSide.peer
                          ? TripClipChatBubbleSide.left
                          : TripClipChatBubbleSide.right,
                      text: item.text!,
                      avatarSize: TripClipAvatarSize.s28,
                      avatarUrl: item.side == _ChatSide.peer
                          ? peerUrl
                          : meAvatarUrl,
                    ),
                };
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Material(
        color: pageBg,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(height: 1, thickness: 1, color: border),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        minLines: 1,
                        maxLines: 4,
                        style: t.bodyMedium!.copyWith(color: textBase),
                        decoration: InputDecoration(
                          hintText: 'Type message',
                          hintStyle:
                              t.bodyMedium!.copyWith(color: textSubtle),
                          isDense: true,
                          filled: true,
                          fillColor: pageBg,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: heading, width: 1),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: border),
                          ),
                        ),
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: _sendSize,
                      height: _sendSize,
                      child: Material(
                        color: heading,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: _sendMessage,
                          customBorder: const CircleBorder(),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/send.svg',
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _peerHeader({
    required String userName,
    required TextStyle nameStyle,
    required TextStyle ratingStyle,
    required String ratingText,
    required Color subtleColor,
    required String peerUrl,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TripClipAvatar(
          size: TripClipAvatarSize.s28,
          imageUrl: peerUrl,
        ),
        Expanded(
          child: Text(
            userName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: nameStyle,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _svgIcon('assets/icons/rating-star.svg', color: subtleColor),
            const SizedBox(width: 4),
            Text(ratingText, style: ratingStyle),
            const SizedBox(width: 6),
            Text(
              '·',
              style: ratingStyle.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 6),
            SvgPicture.asset(
              'assets/icons/passport-valid.svg',
              width: 16,
              height: 16,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(subtleColor, BlendMode.srcIn),
            ),
          ],
        ),
      ],
    );
  }

  Widget _timestampLabel(String text, TextStyle style) {
    return Center(
      child: Text(text, textAlign: TextAlign.center, style: style),
    );
  }

  static Widget _svgIcon(String asset, {required Color color, double size = 16}) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

enum _ChatSide { peer, me }

enum _ChatItemKind { timestamp, message }

class _ChatItem {
  const _ChatItem._({
    required this.kind,
    this.side,
    this.text,
    this.timestampText,
  });

  final _ChatItemKind kind;
  final _ChatSide? side;
  final String? text;
  final String? timestampText;

  factory _ChatItem.timestamp(String value) =>
      _ChatItem._(kind: _ChatItemKind.timestamp, timestampText: value);

  factory _ChatItem.message({required _ChatSide side, required String text}) =>
      _ChatItem._(kind: _ChatItemKind.message, side: side, text: text);
}

const String _kMockBackendResponseJson = r'''
{
  "threadId": "t_123",
  "participants": {
    "peer": {"id": "u_peer", "name": "John Smith"},
    "me": {"id": "u_me", "name": "You"}
  },
  "items": [
    {"type": "timestamp", "text": "January 14, 2026 at 10:45 AM"},
    {"type": "message", "from": "peer", "text": "Hi, are you free to pick up the parcel on Friday?"},
    {"type": "message", "from": "me", "text": "Yes, I can — what time are you available?"},
    {"type": "timestamp", "text": "January 14, 2026 at 2:20 PM"},
    {"type": "message", "from": "peer", "text": "Can we pick it up in the next few days, around the same time? That's good for you, right? I've added this information to the listing."}
  ]
}
''';

List<_ChatItem> _parseChatPayload(String rawJson) {
  final decoded = jsonDecode(rawJson);
  if (decoded is! Map<String, Object?>) return const [];
  final items = decoded['items'];
  if (items is! List) return const [];

  final out = <_ChatItem>[];
  for (final entry in items) {
    if (entry is! Map) continue;
    final type = entry['type'];

    if (type == 'timestamp') {
      final text = entry['text'];
      if (text is String && text.trim().isNotEmpty) {
        out.add(_ChatItem.timestamp(text.trim()));
      }
      continue;
    }

    if (type == 'message') {
      final from = entry['from'];
      final text = entry['text'];
      if (from is! String || text is! String) continue;
      final body = text.trim();
      if (body.isEmpty) continue;

      out.add(
        _ChatItem.message(
          side: from == 'peer' ? _ChatSide.peer : _ChatSide.me,
          text: body,
        ),
      );
    }
  }

  return out;
}
