import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/navigation/trip_clip_navigator.dart';
import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../../ui/components/app_toast.dart';
import '../../../ui/components/buttons/trip_clip_auxiliary_buttons.dart';
import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/trip_clip_avatar.dart';
import 'trip_clip_account_settings_page.dart';
import 'trip_clip_addresses_page.dart';
import 'trip_clip_business_details_page.dart';
import 'trip_clip_help_support_page.dart';
import 'trip_clip_legal_page.dart';
import 'trip_clip_personal_details_page.dart';
import 'trip_clip_payments_page.dart';
import 'trip_clip_privacy_page.dart';
import 'id_verification/trip_clip_id_verification_flow_page.dart';
import 'trip_clip_users_page.dart';

class AccountTabPage extends StatefulWidget {
  const AccountTabPage({super.key, this.isVerified = false, this.profileImage});

  final bool isVerified;
  final ImageProvider<Object>? profileImage;

  @override
  State<AccountTabPage> createState() => _AccountTabPageState();
}

class _AccountTabPageState extends State<AccountTabPage> {
  static const double _bodyPadding = 16;

  final ImagePicker _imagePicker = ImagePicker();

  ImageProvider<Object>? _avatarImage;

  static final List<({String asset, String label})> _menuItems = [
    (asset: 'assets/icons/user1.svg', label: 'Personal Details'),
    (asset: 'assets/icons/briefcase.svg', label: 'Business Details'),
    (asset: 'assets/icons/location.svg', label: 'Addresses'),
    (asset: 'assets/icons/wallet.svg', label: 'Payments'),
    (asset: 'assets/icons/users.svg', label: 'Users'),
    (asset: 'assets/icons/secure-shield.svg', label: 'Privacy'),
    (asset: 'assets/icons/legal.svg', label: 'Legal'),
    (asset: 'assets/icons/help-circle.svg', label: 'Help & Support'),
    (asset: 'assets/icons/settings.svg', label: 'Account Settings'),
  ];

  @override
  void initState() {
    super.initState();
    _avatarImage = widget.profileImage;
  }

  @override
  void didUpdateWidget(covariant AccountTabPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profileImage != widget.profileImage &&
        widget.profileImage != null) {
      _avatarImage = widget.profileImage;
    }
  }

  Future<void> _pickAvatarFromGallery(BuildContext context) async {
    try {
      final file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 88,
      );
      if (!context.mounted || file == null) return;

      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) return;

      setState(() => _avatarImage = MemoryImage(bytes));
    } catch (e, st) {
      assert(() {
        debugPrint('Avatar pick failed: $e\n$st');
        return true;
      }());
      if (context.mounted) {
        AppToast.show(
          context,
          message: 'Could not open your photo library. Please try again.',
          kind: AppToastKind.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final headerBorder = context.tripClipColors.borderSubtle;
    final headerStyle = Theme.of(context).textTheme.headlineLarge!.copyWith(
          color: context.tripClipColors.heading,
        );

    final menuIconColor = context.tripClipColors.textSubtle;
    final menuTextColor = context.tripClipColors.textBase;
    final menuDividerColor = context.tripClipColors.borderSubtle;

    final menuTextStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: menuTextColor,
        );

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
              child: Text('Account', style: headerStyle),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(_bodyPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _AccountProfileCard(
                      isVerified: widget.isVerified,
                      profileImage: _avatarImage,
                      onAvatarEdit: () => _pickAvatarFromGallery(context),
                      onVerifyId: () {
                        tripClipPushMaterialPage<void>(
                          context,
                          const TripClipIdVerificationFlowPage(),
                          shellNavHighlightTabIndex:
                              TripClipShellNavRoutes.accountTabIndex,
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    ..._menuItems.map(
                      (e) => _AccountMenuRow(
                        iconAsset: e.asset,
                        label: e.label,
                        iconColor: menuIconColor,
                        textStyle: menuTextStyle,
                        borderColor: menuDividerColor,
                        onTap: () {
                          if (e.label == 'Personal Details') {
                            tripClipPushMaterialPage<void>(
                              context,
                              const TripClipPersonalDetailsPage(),
                              shellNavHighlightTabIndex:
                                  TripClipShellNavRoutes.accountTabIndex,
                            );
                          } else if (e.label == 'Business Details') {
                            tripClipPushMaterialPage<void>(
                              context,
                              const TripClipBusinessDetailsPage(),
                              shellNavHighlightTabIndex:
                                  TripClipShellNavRoutes.accountTabIndex,
                            );
                          } else if (e.label == 'Addresses') {
                            tripClipPushMaterialPage<void>(
                              context,
                              const TripClipAddressesPage(),
                              shellNavHighlightTabIndex:
                                  TripClipShellNavRoutes.accountTabIndex,
                            );
                          } else if (e.label == 'Payments') {
                            tripClipPushMaterialPage<void>(
                              context,
                              const TripClipPaymentsPage(),
                              shellNavHighlightTabIndex:
                                  TripClipShellNavRoutes.accountTabIndex,
                            );
                          } else if (e.label == 'Users') {
                            tripClipPushMaterialPage<void>(
                              context,
                              const TripClipUsersPage(),
                              shellNavHighlightTabIndex:
                                  TripClipShellNavRoutes.accountTabIndex,
                            );
                          } else if (e.label == 'Privacy') {
                            tripClipPushMaterialPage<void>(
                              context,
                              const TripClipPrivacyPage(),
                              shellNavHighlightTabIndex:
                                  TripClipShellNavRoutes.accountTabIndex,
                            );
                          } else if (e.label == 'Legal') {
                            tripClipPushMaterialPage<void>(
                              context,
                              const TripClipLegalPage(),
                              shellNavHighlightTabIndex:
                                  TripClipShellNavRoutes.accountTabIndex,
                            );
                          } else if (e.label == 'Help & Support') {
                            tripClipPushMaterialPage<void>(
                              context,
                              const TripClipHelpSupportPage(),
                              shellNavHighlightTabIndex:
                                  TripClipShellNavRoutes.accountTabIndex,
                            );
                          } else if (e.label == 'Account Settings') {
                            tripClipPushMaterialPage<void>(
                              context,
                              const TripClipAccountSettingsPage(),
                              shellNavHighlightTabIndex:
                                  TripClipShellNavRoutes.accountTabIndex,
                            );
                          }
                        },
                      ),
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

class _AccountProfileCard extends StatelessWidget {
  const _AccountProfileCard({
    required this.isVerified,
    this.profileImage,
    required this.onAvatarEdit,
    required this.onVerifyId,
  });

  final bool isVerified;
  final ImageProvider<Object>? profileImage;
  final VoidCallback onAvatarEdit;
  final VoidCallback onVerifyId;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = context.tripClipColors.heading;
    final accountTypeColor = isDark
        ? TripClipPalette.accent400
        : TripClipPalette.accent500;
    final dividerColor = accountTypeColor;

    final accountTypeStyle = Theme.of(context).textTheme.titleSmall!.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 12 * 0.05,
          color: accountTypeColor,
        );
    final nameStyle = Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: Colors.white,
        );
    final ratingStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Colors.white,
        );
    final verificationTitleStyle =
        Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Colors.white,
            );
    final verificationBodyStyle =
        Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.white,
            );

    const whiteFilter = ColorFilter.mode(Colors.white, BlendMode.srcIn);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: TripClipAvatarSize.s128.px,
                  height: TripClipAvatarSize.s128.px,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      TripClipAvatar(
                        size: TripClipAvatarSize.s128,
                        image: profileImage,
                      ),
                      PositionedDirectional(
                        start: 0,
                        top: 0,
                        child: TripClipSquareIconButton(
                          svgAsset: 'assets/icons/pencil-edit.svg',
                          onPressed: onAvatarEdit,
                        ),
                      ),
                      if (isVerified)
                        PositionedDirectional(
                          end: 0,
                          bottom: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: TripClipPalette.secondary500,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              'assets/icons/verify.svg',
                              width: 24,
                              height: 24,
                              colorFilter: whiteFilter,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('INDIVIDUAL ACCOUNT', style: accountTypeStyle),
                      const SizedBox(height: 8),
                      Text('John Smith', style: nameStyle),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/rating-star.svg',
                            width: 16,
                            height: 16,
                            colorFilter: whiteFilter,
                          ),
                          const SizedBox(width: 6),
                          Text('4.8 (8)', style: ratingStyle),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!isVerified) ...[
              const SizedBox(height: 16),
              Divider(height: 1, thickness: 1, color: dividerColor),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/check-circle.svg',
                    width: 24,
                    height: 24,
                    colorFilter: whiteFilter,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Verification', style: verificationTitleStyle),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Verify your identity to start sending and delivering '
                'parcels. It only takes a few minutes and helps keep '
                'everyone safe.',
                style: verificationBodyStyle,
              ),
              const SizedBox(height: 24),
              TripClipButton(
                variant: TripClipButtonVariant.primaryAlternative,
                expanded: true,
                label: 'Verify ID',
                onPressed: onVerifyId,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AccountMenuRow extends StatelessWidget {
  const _AccountMenuRow({
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
