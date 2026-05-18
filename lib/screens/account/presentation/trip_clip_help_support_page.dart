import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/navigation/trip_clip_navigator.dart';
import '../../../app/theme/trip_clip_colors.dart';
import '../../../ui/components/pages/trip_clip_content_page_scaffold.dart';
import 'help_support/trip_clip_contact_page.dart';
import 'help_support/trip_clip_faq_page.dart';
import 'help_support/trip_clip_safety_guidelines_page.dart';

class TripClipHelpSupportPage extends StatelessWidget {
  const TripClipHelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuIconColor = context.tripClipColors.textSubtle;
    final menuTextColor = context.tripClipColors.textBase;
    final menuDividerColor = context.tripClipColors.borderSubtle;
    final menuTextStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: menuTextColor,
        );

    return TripClipContentPageScaffold(
      appBarTitle: 'Help & Support',
      heading: 'Help & Support',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          _HelpMenuRow(
            iconAsset: 'assets/icons/customer-service.svg',
            label: 'Contact',
            iconColor: menuIconColor,
            textStyle: menuTextStyle,
            borderColor: menuDividerColor,
            onTap: () {
              tripClipPushMaterialPage<void>(
                context,
                const TripClipContactPage(),
                shellNavHighlightTabIndex:
                    TripClipShellNavRoutes.accountTabIndex,
              );
            },
          ),
          _HelpMenuRow(
            iconAsset: 'assets/icons/help-circle.svg',
            label: 'FAQs',
            iconColor: menuIconColor,
            textStyle: menuTextStyle,
            borderColor: menuDividerColor,
            onTap: () {
              tripClipPushMaterialPage<void>(
                context,
                const TripClipFaqPage(),
                shellNavHighlightTabIndex:
                    TripClipShellNavRoutes.accountTabIndex,
              );
            },
          ),
          _HelpMenuRow(
            iconAsset: 'assets/icons/secure-shield.svg',
            label: 'Safety Guidelines',
            iconColor: menuIconColor,
            textStyle: menuTextStyle,
            borderColor: menuDividerColor,
            onTap: () {
              tripClipPushMaterialPage<void>(
                context,
                const TripClipSafetyGuidelinesPage(),
                shellNavHighlightTabIndex:
                    TripClipShellNavRoutes.accountTabIndex,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HelpMenuRow extends StatelessWidget {
  const _HelpMenuRow({
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

