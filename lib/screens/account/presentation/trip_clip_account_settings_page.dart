import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/navigation/trip_clip_navigator.dart';
import '../../../app/theme/trip_clip_colors.dart';
import '../../../ui/components/pages/trip_clip_content_page_scaffold.dart';
import 'account_setting/trip_clip_change_password_page.dart';
import 'email_verification/trip_clip_verify_email_page.dart';
import 'mobile_verification/trip_clip_verify_mobile_number_page.dart';
import 'account_setting/trip_clip_appearance_page.dart';
import 'account_setting/trip_clip_notifications_page.dart';

class TripClipAccountSettingsPage extends StatelessWidget {
  const TripClipAccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuIconColor = context.tripClipColors.textSubtle;
    final menuTextColor = context.tripClipColors.textBase;
    final menuDividerColor = context.tripClipColors.borderSubtle;
    final menuTextStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: menuTextColor,
        );

    return TripClipContentPageScaffold(
      appBarTitle: 'Account Settings',
      heading: 'Account Settings',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          _SettingsMenuRow(
            iconAsset: 'assets/icons/secure-lock.svg',
            label: 'Password',
            iconColor: menuIconColor,
            textStyle: menuTextStyle,
            borderColor: menuDividerColor,
            onTap: () {
              tripClipPushMaterialPage<void>(
                context,
                const TripClipChangePasswordPage(),
                shellNavHighlightTabIndex:
                    TripClipShellNavRoutes.accountTabIndex,
              );
            },
          ),
          _SettingsMenuRow(
            iconAsset: 'assets/icons/phone.svg',
            label: 'Verify mobile number',
            iconColor: menuIconColor,
            textStyle: menuTextStyle,
            borderColor: menuDividerColor,
            onTap: () {
              tripClipPushMaterialPage<void>(
                context,
                const TripClipVerifyMobileNumberPage(),
                shellNavHighlightTabIndex:
                    TripClipShellNavRoutes.accountTabIndex,
              );
            },
          ),
          _SettingsMenuRow(
            iconAsset: 'assets/icons/email.svg',
            label: 'Verify email',
            iconColor: menuIconColor,
            textStyle: menuTextStyle,
            borderColor: menuDividerColor,
            onTap: () {
              tripClipPushMaterialPage<void>(
                context,
                const TripClipVerifyEmailPage(),
                shellNavHighlightTabIndex:
                    TripClipShellNavRoutes.accountTabIndex,
              );
            },
          ),
          _SettingsMenuRow(
            iconAsset: 'assets/icons/bell.svg',
            label: 'Notifications',
            iconColor: menuIconColor,
            textStyle: menuTextStyle,
            borderColor: menuDividerColor,
            onTap: () {
              tripClipPushMaterialPage<void>(
                context,
                const TripClipNotificationsPage(),
                shellNavHighlightTabIndex:
                    TripClipShellNavRoutes.accountTabIndex,
              );
            },
          ),
          _SettingsMenuRow(
            iconAsset: 'assets/icons/sun.svg',
            label: 'Appearance',
            iconColor: menuIconColor,
            textStyle: menuTextStyle,
            borderColor: menuDividerColor,
            onTap: () {
              tripClipPushMaterialPage<void>(
                context,
                const TripClipAppearancePage(),
                shellNavHighlightTabIndex:
                    TripClipShellNavRoutes.accountTabIndex,
              );
            },
          ),
          _SettingsMenuRow(
            iconAsset: 'assets/icons/delete-account.svg',
            label: 'Delete Account',
            iconColor: menuIconColor,
            textStyle: menuTextStyle,
            borderColor: menuDividerColor,
            onTap: () {
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsMenuRow extends StatelessWidget {
  const _SettingsMenuRow({
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

