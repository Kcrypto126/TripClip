import 'package:flutter/material.dart';

import '../../../ui/components/trip_clip_title_bar.dart';

class ComponentsPage extends StatelessWidget {
  const ComponentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TripClipTitleBar(
            title: 'Components',
            includeStatusBarInset: true,
            onBack: () => Navigator.of(context).maybePop(),
          ),
          const Expanded(child: Center(child: Text('Component page'))),
        ],
      ),
    );
  }
}
