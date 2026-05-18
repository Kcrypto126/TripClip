import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/navigation/trip_clip_navigator.dart';
import '../../../app/theme/trip_clip_colors.dart';
import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/forms/trip_clip_atom_input.dart';
import 'trip_clip_parcels_create_scope.dart';
import 'trip_clip_parcels_create_trip_name_page.dart';

class ParcelsTabPage extends StatelessWidget {
  const ParcelsTabPage({super.key});

  static const double _bodyPadding = 16;
  static const double _sectionGap = 16;

  @override
  Widget build(BuildContext context) {
    final headerBorder = context.tripClipColors.borderSubtle;
    final headerStyle = Theme.of(
      context,
    ).textTheme.headlineLarge!.copyWith(color: context.tripClipColors.heading);

    final iconTint = context.tripClipColors.textSubtle;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final parcelsBg = isDark
        ? const Color(0xFF1F242B)
        : const Color(0xFFEFF2F5);

    final headingStyle = Theme.of(context).textTheme.headlineMedium!.copyWith(
      color: context.tripClipColors.textBase,
    );
    final bodyStyle = Theme.of(
      context,
    ).textTheme.bodyMedium!.copyWith(color: context.tripClipColors.textSubtle);

    return Scaffold(
      backgroundColor: context.tripClipColors.pageBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 44,
              padding: const EdgeInsets.only(left: _bodyPadding),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: headerBorder, width: 1),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Text('Parcels', style: headerStyle),
            ),
            Padding(
              padding: const EdgeInsets.all(_bodyPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TripClipAtomInput(
                    hintText: 'Search Parcels',
                    showTrailing: false,
                    showLeading: true,
                    leadingIconAsset: 'assets/icons/search.svg',
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: _bodyPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: parcelsBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/package-large.svg',
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.contain,
                                  colorFilter: ColorFilter.mode(
                                    iconTint,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No parcels yet',
                                  textAlign: TextAlign.center,
                                  style: headingStyle,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Create you first item to get started',
                                  textAlign: TextAlign.center,
                                  style: bodyStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: _sectionGap),
                    TripClipButton(
                      variant: TripClipButtonVariant.primary,
                      expanded: true,
                      label: 'Create Listing',
                      onPressed: () {
                        tripClipPushMaterialPage<void>(
                          context,
                          const TripClipParcelsCreateScopeHost(
                            child: TripClipParcelsCreateTripNamePage(),
                          ),
                          shellNavHighlightTabIndex:
                              TripClipShellNavRoutes.parcelsTabIndex,
                        );
                      },
                    ),
                    const SizedBox(height: _sectionGap),
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
