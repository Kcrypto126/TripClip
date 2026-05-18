import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/trip_clip_colors.dart';
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
    final headerBorder = context.tripClipColors.borderSubtle;
    final topTextColor = context.tripClipColors.textBase;

    final headerStyle = Theme.of(context).textTheme.headlineLarge!.copyWith(
          color: context.tripClipColors.heading,
        );

    final topStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: topTextColor,
        );

    final optionTextStyle = Theme.of(context).textTheme.headlineSmall!.copyWith(
          color: context.tripClipColors.textBase,
        );

    return Scaffold(
      backgroundColor: context.tripClipColors.pageBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 44,
              padding: const EdgeInsets.only(left: 4, right: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: headerBorder, width: 1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: () => Navigator.of(context).maybePop(),
                      customBorder: const CircleBorder(),
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/chevron-left.svg',
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            colorFilter: ColorFilter.mode(
                              context.tripClipColors.heading,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Create Account',
                      style: headerStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
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
                        Navigator.of(context, rootNavigator: true).push<void>(
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
