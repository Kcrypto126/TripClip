import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/trip_clip_palette.dart';
import 'trip_clip_form_models.dart';

/// Eye icon used with [TripClipAtomInput] for password fields (matches login).
class TripClipPasswordVisibilityToggle extends StatelessWidget {
  const TripClipPasswordVisibilityToggle({
    super.key,
    required this.shown,
    required this.onPressed,
    required this.active,
    required this.status,
  });

  final bool shown;
  final VoidCallback onPressed;
  final bool active;
  final TripClipFormStatus status;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SvgPicture.asset(
            shown ? 'assets/icons/view-off.svg' : 'assets/icons/view.svg',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(_iconColor(), BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  Color _iconColor() {
    return switch (status) {
      TripClipFormStatus.error => const Color(0xFFA4332B),
      TripClipFormStatus.warning => const Color(0xFF9E6E0F),
      TripClipFormStatus.success => const Color(0xFF1C845C),
      TripClipFormStatus.none =>
        active ? TripClipPalette.tertiary500 : TripClipPalette.neutral600,
    };
  }
}
