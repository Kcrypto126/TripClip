import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/trip_clip_palette.dart';
import 'trip_clip_form_models.dart';
import 'trip_clip_form_tokens.dart';

/// Eye icon used with [TripClipAtomInput] for password fields.
///
/// Icon tint matches the leading icon rules in [TripClipAtomInput] for every
/// [TripClipFormStatus].
class TripClipPasswordVisibilityToggle extends StatelessWidget {
  const TripClipPasswordVisibilityToggle({
    super.key,
    required this.shown,
    required this.onPressed,
    required this.focused,
    required this.hasValue,
    required this.status,
  });

  final bool shown;
  final VoidCallback onPressed;
  final bool focused;
  final bool hasValue;
  final TripClipFormStatus status;

  Color _leadingMatchIconColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dec = TripClipFormFieldDecoration.atom(
      isDark: isDark,
      enabled: true,
      focused: focused,
      hasValue: hasValue,
      status: status,
    );
    if (status != TripClipFormStatus.none) {
      return dec.hintOrPlaceholder;
    }
    return (focused || hasValue) ? dec.foreground : TripClipPalette.neutral500;
  }

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
            colorFilter: ColorFilter.mode(
              _leadingMatchIconColor(context),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
