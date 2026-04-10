import 'package:flutter/material.dart';

import '../../../ui/foundations/app_spacing.dart';

class ParcelsTabPage extends StatelessWidget {
  const ParcelsTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          'Parcels',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
