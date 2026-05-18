import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../sheets/trip_clip_modal_sheet.dart';
import '../../sheets/trip_clip_sheet_layout.dart';
import '../trip_clip_avatar.dart';

void showTripClipTripsShareSheet(BuildContext context) {
  TripClipModalSheet.show<void>(
    context,
    heightFraction: 0.3,
    builder: (sheetContext) => const TripClipTripsShareSheet(),
  );
}

class TripClipTripsShareSheet extends StatelessWidget {
  const TripClipTripsShareSheet({super.key});

  static const String _kSampleAvatarUrl =
      'https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/john-doe.webp';

  static const List<String> _kContactNames = [
    'John Smith',
    'Nathan Trembath',
    'Robert Nicholson',
    'Jodie Simpson',
    'Alex Morgan',
  ];

  @override
  Widget build(BuildContext context) {
    void dismiss() => Navigator.of(context).maybePop();

    return TripClipTermsStyleSheet(
      title: 'Share',
      onBack: dismiss,
      onClose: dismiss,
      body: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        itemCount: _kContactNames.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return _ShareContactTile(
            name: _kContactNames[index],
            imageUrl: _kSampleAvatarUrl,
          );
        },
      ),
    );
  }
}

class _ShareContactTile extends StatelessWidget {
  const _ShareContactTile({required this.name, required this.imageUrl});

  final String name;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TripClipAvatar(
            size: TripClipAvatarSize.s48,
            imageUrl: imageUrl,
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: context.tripClipColors.textSubtle,
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
