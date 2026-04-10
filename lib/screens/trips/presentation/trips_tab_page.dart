import 'package:flutter/material.dart';

import '../../../ui/foundations/app_spacing.dart';

class TripsTabPage extends StatelessWidget {
  const TripsTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          'Trips',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
