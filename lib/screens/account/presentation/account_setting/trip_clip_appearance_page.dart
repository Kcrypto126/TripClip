import 'package:flutter/material.dart';

import '../../../../app/trip_clip_app.dart';
import '../../../../ui/components/forms/trip_clip_form_radio.dart';
import '../../../../ui/components/pages/trip_clip_content_page_scaffold.dart';

class TripClipAppearancePage extends StatelessWidget {
  const TripClipAppearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = TripClipAppScope.of(context);
    final selected = scope.themeMode;

    void onModeChanged(ThemeMode? mode) {
      if (mode != null) scope.applyThemeMode(mode);
    }

    return TripClipContentPageScaffold(
      appBarTitle: 'Appearance',
      heading: 'Appearance',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          TripClipFormRadio<ThemeMode>(
            value: ThemeMode.system,
            groupValue: selected,
            onChanged: onModeChanged,
            label: 'System (Automatic)',
          ),
          const SizedBox(height: 24),
          TripClipFormRadio<ThemeMode>(
            value: ThemeMode.light,
            groupValue: selected,
            onChanged: onModeChanged,
            label: 'Light Mode',
          ),
          const SizedBox(height: 24),
          TripClipFormRadio<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: selected,
            onChanged: onModeChanged,
            label: 'Dark Mode',
          ),
        ],
      ),
    );
  }
}
