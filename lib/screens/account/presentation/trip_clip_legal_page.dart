import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/navigation/trip_clip_navigator.dart';
import '../../../app/theme/trip_clip_colors.dart';
import '../../../ui/components/pages/trip_clip_content_page_scaffold.dart';
import 'legal/trip_clip_community_guidelines_page.dart';
import 'legal/trip_clip_privacy_policy_page.dart';
import 'legal/trip_clip_terms_of_service_page.dart';

class TripClipLegalPage extends StatelessWidget {
  const TripClipLegalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuIconColor = context.tripClipColors.textSubtle;
    final menuTextColor = context.tripClipColors.textBase;
    final menuDividerColor = context.tripClipColors.borderSubtle;
    final menuTextStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: menuTextColor,
        );

    return TripClipContentPageScaffold(
      appBarTitle: 'Legal',
      heading: 'Legal',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32), // scaffold already adds 24px
          _LegalMenuRow(
            iconAsset: 'assets/icons/legal.svg',
            label: 'Community Guidelines',
            iconColor: menuIconColor,
            textStyle: menuTextStyle,
            borderColor: menuDividerColor,
            onTap: () => tripClipPushMaterialPage<void>(
              context,
              const TripClipCommunityGuidelinesPage(),
              shellNavHighlightTabIndex:
                  TripClipShellNavRoutes.accountTabIndex,
            ),
          ),
          _LegalMenuRow(
            iconAsset: 'assets/icons/legal.svg',
            label: 'Terms of Service',
            iconColor: menuIconColor,
            textStyle: menuTextStyle,
            borderColor: menuDividerColor,
            onTap: () => tripClipPushMaterialPage<void>(
              context,
              const TripClipTermsOfServicePage(),
              shellNavHighlightTabIndex:
                  TripClipShellNavRoutes.accountTabIndex,
            ),
          ),
          _LegalMenuRow(
            iconAsset: 'assets/icons/secure-shield.svg',
            label: 'Privacy Policy',
            iconColor: menuIconColor,
            textStyle: menuTextStyle,
            borderColor: menuDividerColor,
            onTap: () => tripClipPushMaterialPage<void>(
              context,
              const TripClipPrivacyPolicyPage(),
              shellNavHighlightTabIndex:
                  TripClipShellNavRoutes.accountTabIndex,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalMenuRow extends StatelessWidget {
  const _LegalMenuRow({
    required this.iconAsset,
    required this.label,
    required this.iconColor,
    required this.textStyle,
    required this.borderColor,
    required this.onTap,
  });

  final String iconAsset;
  final String label;
  final Color iconColor;
  final TextStyle textStyle;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconFilter = ColorFilter.mode(iconColor, BlendMode.srcIn);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: borderColor, width: 1)),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                iconAsset,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                colorFilter: iconFilter,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: textStyle)),
              SvgPicture.asset(
                'assets/icons/chevron-right.svg',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                colorFilter: iconFilter,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

