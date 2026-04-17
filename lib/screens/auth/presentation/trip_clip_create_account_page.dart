import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/trip_clip_palette.dart';
import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/forms/trip_clip_form_radio_button.dart';
import 'trip_clip_account_type.dart';
import 'trip_clip_create_account_details_page.dart';

class TripClipCreateAccountPage extends StatefulWidget {
  const TripClipCreateAccountPage({super.key});

  @override
  State<TripClipCreateAccountPage> createState() =>
      _TripClipCreateAccountPageState();
}

class _TripClipCreateAccountPageState extends State<TripClipCreateAccountPage> {
  TripClipAccountType _selected = TripClipAccountType.individual;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final headerBorder = isDark
        ? const Color(0xFF2E343D)
        : const Color(0xFFDCE1E6);
    final headerColor = isDark
        ? TripClipPalette.primary400
        : TripClipPalette.primary500;

    final topTextColor = isDark ? Colors.white : TripClipPalette.tertiary500;

    final headerStyle = GoogleFonts.rubik(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 32 / 28,
      letterSpacing: 0,
      color: headerColor,
    );

    final topStyle = GoogleFonts.rubik(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 24 / 16,
      letterSpacing: 0,
      color: topTextColor,
    );

    final optionTextStyle = GoogleFonts.rubik(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 22 / 18,
      letterSpacing: 0,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 44,
              padding: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: headerBorder, width: 1),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Text('Create Account', style: headerStyle),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Which type of account would you like to set up?',
                      style: topStyle,
                    ),
                    const SizedBox(height: 24),
                    TripClipFormRadioButton(
                      width: double.infinity,
                      radius: 12,
                      padding: const EdgeInsets.all(16),
                      iconSize: 48,
                      gap: 16,
                      contentAlignment: MainAxisAlignment.start,
                      textStyle: optionTextStyle,
                      iconAsset: 'assets/icons/user1.svg',
                      label: 'Individual Account',
                      selected: _selected == TripClipAccountType.individual,
                      onPressed: () => setState(
                        () => _selected = TripClipAccountType.individual,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TripClipFormRadioButton(
                      width: double.infinity,
                      radius: 12,
                      padding: const EdgeInsets.all(16),
                      iconSize: 48,
                      gap: 16,
                      contentAlignment: MainAxisAlignment.start,
                      textStyle: optionTextStyle,
                      iconAsset: 'assets/icons/apartment.svg',
                      label: 'Business Account',
                      selected: _selected == TripClipAccountType.business,
                      onPressed: () => setState(
                        () => _selected = TripClipAccountType.business,
                      ),
                    ),
                    const Spacer(),
                    TripClipButton(
                      variant: TripClipButtonVariant.primary,
                      expanded: true,
                      label: 'Continue',
                      onPressed: () {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (_) => TripClipCreateAccountDetailsPage(
                              accountType: _selected,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
