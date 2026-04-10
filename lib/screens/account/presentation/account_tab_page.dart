import 'package:flutter/material.dart';

import '../../../ui/foundations/app_spacing.dart';

class AccountTabPage extends StatelessWidget {
  const AccountTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          'Account',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
