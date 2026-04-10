import 'package:flutter/material.dart';

import '../../../ui/foundations/app_spacing.dart';

class ActivityTabPage extends StatelessWidget {
  const ActivityTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          'Activity',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
