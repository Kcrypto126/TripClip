import 'package:flutter/material.dart';

import '../../../../app/theme/trip_clip_colors.dart';
import '../../../../ui/components/pages/trip_clip_content_page_scaffold.dart';

class TripClipContactPage extends StatelessWidget {
  const TripClipContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TripClipContentPageScaffold(
      appBarTitle: 'Contact',
      heading: 'Contact',
      body: Text(
        'Content coming soon.',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: context.tripClipColors.textBase,
            ),
      ),
    );
  }
}

