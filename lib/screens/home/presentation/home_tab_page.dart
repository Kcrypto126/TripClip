import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../../ui/components/cards/trip_clip_heading_card.dart';
import '../../../ui/components/cards/trip_clip_semi_feature_card.dart';
import '../../../ui/components/forms/trip_clip_atom_input.dart';
import '../../../ui/components/trip_clip_home_app_bar.dart';
import '../../components/presentation/components_page.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  static const int _favorites = 3;
  static const int _notifications = 9;

  /// Vertical space for [TripClipSemiFeatureCard] in the parcels carousel.
  static const double _homeParcelCarouselHeight = 280;

  final TextEditingController _searchController = TextEditingController();

  // Static data for now (easy to replace with backend models later).
  final List<_ParcelCardData> _parcels = const [
    _ParcelCardData(
      heading: 'Spare Ute Parts',
      priceLabel: r'$50',
      pickupLocation: 'Fitzroy VIC 3065',
      deliveryLocation: 'Ringwood North VIC 3134',
      itemsText: '3 Items',
      weightText: '35 kg',
      footerDateText: 'Feb 17, 2026',
    ),
    _ParcelCardData(
      heading: 'Spare Engine Parts',
      priceLabel: r'$750',
      pickupLocation: 'Brighton-Le-Sands NSW',
      deliveryLocation: 'Ringwood North VIC',
      itemsText: '3 Items',
      weightText: 'XX kg',
      footerDateText: 'Jan 14, 2026',
    ),
  ];

  final List<_TripCardData> _trips = const [
    _TripCardData(
      heading: 'Melbourne CBD',
      body: '150 Trips',
      image: AssetImage('assets/images/bridge.jpg'),
    ),
    _TripCardData(
      heading: 'Fitzroy',
      body: '10 Trips',
      image: AssetImage('assets/images/s_street.jpg'),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static TextStyle _rubik({
    required double size,
    required double lineHeight,
    required FontWeight weight,
    required Color color,
    double letterSpacing = 0,
  }) => GoogleFonts.rubik(
    fontSize: size,
    height: lineHeight / size,
    fontWeight: weight,
    letterSpacing: letterSpacing,
    color: color,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.tripClipColors;
    final light = Theme.of(context).brightness == Brightness.light;

    // Spec: #141E46 (light), #ffffff (dark)
    final greetingColor = light ? const Color(0xFF141E46) : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TripClipHomeAppBar(
          favoritesCount: _favorites,
          notificationsCount: _notifications,
          onNotificationsPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ComponentsPage()),
            );
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Good morning, John',
                  style: _rubik(
                    size: 16,
                    lineHeight: 24,
                    weight: FontWeight.w600,
                    letterSpacing: 0,
                    color: greetingColor,
                  ),
                ),
                const SizedBox(height: 8),
                TripClipAtomInput(
                  controller: _searchController,
                  hintText: 'Search TripClip',
                  showTrailing: false,
                  showLeading: true,
                  leading: SvgPicture.asset(
                    'assets/icons/search.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      light
                          ? TripClipPalette.neutral600
                          : TripClipPalette.neutral300,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const _SectionHeader(title: 'My Parcels'),
                const SizedBox(height: 12),
                SizedBox(
                  height: _homeParcelCarouselHeight,
                  child: PageView.builder(
                    itemCount: _parcels.length,
                    controller: PageController(viewportFraction: 1),
                    itemBuilder: (context, i) {
                      final p = _parcels[i];
                      return TripClipSemiFeatureCard(
                        heading: p.heading,
                        badgeLabel: p.priceLabel,
                        userName: 'User Name',
                        ratingText: '4.8 (55)',
                        pickupLocation: p.pickupLocation,
                        deliveryLocation: p.deliveryLocation,
                        itemsText: p.itemsText,
                        weightText: p.weightText,
                        footerDateText: p.footerDateText,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                const _SectionHeader(title: 'Recommend Trips'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    itemCount: _trips.length,
                    padEnds: false,
                    controller: PageController(viewportFraction: 0.62),
                    itemBuilder: (context, i) {
                      final t = _trips[i];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: i == _trips.length - 1 ? 0 : 12,
                        ),
                        child: TripClipHeadingCard(
                          width: 200,
                          height: 150,
                          heading: t.heading,
                          body: t.body,
                          backgroundImage: t.image,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Static data for now (backend integration coming soon).',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.textSubtle,
                    height: 20 / 12,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final titleColor = light ? TripClipPalette.tertiary500 : Colors.white;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.rubik(
              fontSize: 22,
              height: 26 / 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
              color: titleColor,
            ),
          ),
        ),
        const SizedBox(width: 40, height: 40),
      ],
    );
  }
}

class _ParcelCardData {
  const _ParcelCardData({
    required this.heading,
    required this.priceLabel,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.itemsText,
    required this.weightText,
    required this.footerDateText,
  });

  final String heading;
  final String priceLabel;
  final String pickupLocation;
  final String deliveryLocation;
  final String itemsText;
  final String weightText;
  final String footerDateText;
}

class _TripCardData {
  const _TripCardData({
    required this.heading,
    required this.body,
    required this.image,
  });

  final String heading;
  final String body;
  final ImageProvider<Object> image;
}

/*
// NOTE: File was duplicated multiple times by a previous edit.
// It is intentionally overwritten in full by Cursor tooling to keep a single
// implementation. If you see this line, something went wrong with the overwrite.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../../ui/components/cards/trip_clip_heading_card.dart';
import '../../../ui/components/cards/trip_clip_semi_feature_card.dart';
import '../../../ui/components/forms/trip_clip_atom_input.dart';
import '../../../ui/components/trip_clip_home_app_bar.dart';
import '../../components/presentation/components_page.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  static const int _favorites = 3;
  static const int _notifications = 9;

  final TextEditingController _searchController = TextEditingController();

  // Static data for now (easy to replace with backend models later).
  final List<_ParcelCardData> _parcels = const [
    _ParcelCardData(
      heading: 'Spare Ute Parts',
      priceLabel: r'$50',
      pickupLocation: 'Fitzroy VIC 3065',
      deliveryLocation: 'Ringwood North VIC 3134',
      itemsText: '3 Items',
      weightText: '35 kg',
      footerDateText: 'Feb 17, 2026',
    ),
    _ParcelCardData(
      heading: 'Spare Engine Parts',
      priceLabel: r'$750',
      pickupLocation: 'Brighton-Le-Sands NSW',
      deliveryLocation: 'Ringwood North VIC',
      itemsText: '3 Items',
      weightText: 'XX kg',
      footerDateText: 'Jan 14, 2026',
    ),
  ];

  final List<_TripCardData> _trips = const [
    _TripCardData(
      heading: 'Melbourne CBD',
      body: '150 Trips',
      image: AssetImage('assets/images/bridge.jpg'),
    ),
    _TripCardData(
      heading: 'Fitzroy',
      body: '10 Trips',
      image: AssetImage('assets/images/s_street.jpg'),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static TextStyle _rubik({
    required double size,
    required double lineHeight,
    required FontWeight weight,
    required Color color,
    double letterSpacing = 0,
  }) =>
      GoogleFonts.rubik(
        fontSize: size,
        height: lineHeight / size,
        fontWeight: weight,
        letterSpacing: letterSpacing,
        color: color,
      );

  @override
  Widget build(BuildContext context) {
    final colors = context.tripClipColors;
    final light = Theme.of(context).brightness == Brightness.light;

    final greetingColor = light ? const Color(0xFF141E46) : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TripClipHomeAppBar(
          favoritesCount: _favorites,
          notificationsCount: _notifications,
          onNotificationsPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ComponentsPage()),
            );
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Good morning, John',
                  style: _rubik(
                    size: 16,
                    lineHeight: 24,
                    weight: FontWeight.w600,
                    letterSpacing: 0,
                    color: greetingColor,
                  ),
                ),
                const SizedBox(height: 8),
                TripClipAtomInput(
                  controller: _searchController,
                  hintText: 'Search TripClip',
                  showTrailing: false,
                  showLeading: true,
                  leading: SvgPicture.asset(
                    'assets/icons/search.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      light
                          ? TripClipPalette.neutral600
                          : TripClipPalette.neutral300,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                _SectionHeader(
                  title: 'My Parcels',
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 170,
                  child: PageView.builder(
                    itemCount: _parcels.length,
                    controller: PageController(viewportFraction: 1),
                    itemBuilder: (context, i) {
                      final p = _parcels[i];
                      return TripClipSemiFeatureCard(
                        heading: p.heading,
                        badgeLabel: p.priceLabel,
                        userName: 'User Name',
                        ratingText: '4.8 (55)',
                        pickupLocation: p.pickupLocation,
                        deliveryLocation: p.deliveryLocation,
                        itemsText: p.itemsText,
                        weightText: p.weightText,
                        footerDateText: p.footerDateText,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                _SectionHeader(
                  title: 'Recommend Trips',
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    itemCount: _trips.length,
                    padEnds: false,
                    controller: PageController(viewportFraction: 0.62),
                    itemBuilder: (context, i) {
                      final t = _trips[i];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: i == _trips.length - 1 ? 0 : 12,
                        ),
                        child: TripClipHeadingCard(
                          width: 200,
                          height: 150,
                          heading: t.heading,
                          body: t.body,
                          backgroundImage: t.image,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                // Placeholder for upcoming backend integration.
                Text(
                  'Static data for now (backend integration coming soon).',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.textSubtle,
                        height: 20 / 12,
                        letterSpacing: 0,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final titleColor = light ? TripClipPalette.tertiary500 : Colors.white;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.rubik(
              fontSize: 22,
              height: 26 / 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
              color: titleColor,
            ),
          ),
        ),
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Icon(Icons.chevron_right),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ParcelCardData {
  const _ParcelCardData({
    required this.heading,
    required this.priceLabel,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.itemsText,
    required this.weightText,
    required this.footerDateText,
  });

  final String heading;
  final String priceLabel;
  final String pickupLocation;
  final String deliveryLocation;
  final String itemsText;
  final String weightText;
  final String footerDateText;
}

class _TripCardData {
  const _TripCardData({
    required this.heading,
    required this.body,
    required this.image,
  });

  final String heading;
  final String body;
  final ImageProvider<Object> image;
}

import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../ui/components/trip_clip_home_app_bar.dart';
import '../../components/presentation/components_page.dart';

class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key});

  static const int _favorites = 3;
  static const int _notifications = 9;

  @override
  Widget build(BuildContext context) {
    final colors = context.tripClipColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TripClipHomeAppBar(
          favoritesCount: _favorites,
          notificationsCount: _notifications,
          onNotificationsPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ComponentsPage()),
            );
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                'Tap the bell icon to open Components.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: 0,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/trip_clip_app.dart';
import '../../../ui/components/app_card.dart';
import '../../../ui/components/app_toast.dart';
import '../../../ui/components/buttons/trip_clip_auxiliary_buttons.dart';
import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/badges/trip_clip_badges.dart';
import '../../../ui/components/trip_clip_chat_bubble.dart';
import '../../../ui/components/trip_clip_avatar.dart';
import '../../../ui/components/cards/trip_clip_feature_card.dart';
import '../../../ui/components/cards/trip_clip_heading_card.dart';
import '../../../ui/components/cards/trip_clip_result_card.dart';
import '../../../ui/components/cards/trip_clip_semi_feature_card.dart';
import '../../../ui/components/forms/trip_clip_forms.dart';
import '../../../ui/components/trip_clip_home_app_bar.dart';
import '../../../ui/components/trip_clip_steps_status_bar.dart';
import '../../../ui/components/trip_clip_title_bar.dart';
import '../../../ui/foundations/app_spacing.dart';
import '../../components/presentation/components_page.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  static const int _flowTotalSteps = 5;
  static const int _favorites = 3;
  static const int _notifications = 9;

  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.tripClipColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TripClipHomeAppBar(
          favoritesCount: _favorites,
          notificationsCount: _notifications,
          onNotificationsPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ComponentsPage()),
            );
          },
        ),
        TripClipTitleBar(
          title: 'Title',
          includeStatusBarInset: false,
          onBack: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Title bar: back')));
          },
        ),
        TripClipStepsStatusBar(
          totalSteps: _flowTotalSteps,
          currentStep: _currentStep,
          showRightChevron: true,
          onStepChanged: (next) => setState(
            () => _currentStep = TripClipStepsStatusBar.clampStep(
              next,
              totalSteps: _flowTotalSteps,
            ),
          ),
          onExitAtFirstStep: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Flow: already on step 0')),
            );
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            child: AppCard(
              bordered: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xl),

                  Text('Avatar', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: AppSpacing.sm),
                  const Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      TripClipAvatar(size: TripClipAvatarSize.s32),
                      TripClipAvatar(size: TripClipAvatarSize.s40),
                      TripClipAvatar(size: TripClipAvatarSize.s64),
                      TripClipAvatar(size: TripClipAvatarSize.s128),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  Text(
                    'Chat bubble',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const TripClipChatBubble(
                    side: TripClipChatBubbleSide.right,
                    text:
                        'Insert traveller text here...Insert traveller text here...Insert traveller text here...',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const TripClipChatBubble(
                    side: TripClipChatBubbleSide.left,
                    text: 'Insert sender text here...',
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  Text(
                    'Feature card',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const TripClipFeatureCard(
                    images: [
                      AssetImage('assets/images/pump.png'),
                      AssetImage('assets/images/pump.png'),
                      AssetImage('assets/images/pump.png'),
                      AssetImage('assets/images/pump.png'),
                    ],
                    heading: 'Spare Engine Parts:\nMelbourne to Cairns',
                    badgeLabel: r'$750',
                    badgeFlexibleLabel: 'Flexible',
                    userName: 'Firstname Verylonglastname…',
                    ratingText: '4.8 (55)',
                    pickupLocation: 'Something Long G…',
                    pickupDate: 'Something Long G…',
                    pickupTime: 'Something Long G…',
                    deliveryLocation: 'Something Long G…',
                    deliveryDate: 'Something Long G…',
                    deliveryTime: 'Something Long G…',
                    itemsText: '5 Items',
                    weightText: '10 kg',
                    footerDateText: 'Jan 14, 2026',
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  Text(
                    'Semi feature card',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const TripClipSemiFeatureCard(
                    heading: 'Spare Engine Parts:\nMelbourne to Cairns',
                    badgeLabel: r'$750',
                    badgeFlexibleLabel: 'Flexible',
                    userName: 'User Name',
                    ratingText: '4.8 (55)',
                    pickupLocation: 'Brighton-Le-Sands NSW',
                    deliveryLocation: 'Ringwood North VIC',
                    itemsText: '3 Items',
                    weightText: 'XX kg',
                    footerDateText: 'Jan 14, 2026',
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  Text(
                    'Result card',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const TripClipResultCard(
                    heading: 'Spare Engine Parts: Melbourne to Cairns',
                    badgeLabel: r'$750',
                    badgeFlexibleLabel: 'Flexible',
                    pickupLocation: 'Brighton-Le-Sands…',
                    deliveryLocation: 'Ringwood North VIC',
                    itemsText: '3 Items',
                    weightText: 'XX kg',
                    footerDateText: 'Jan 14, 2026',
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  Text(
                    'Heading card',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const TripClipHeadingCard(
                    heading: 'Title',
                    body: 'XXX Trips',
                    width: 200,
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  Text(
                    'Form calendar',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const _TripClipFormCalendarDemo(),
                  const SizedBox(height: AppSpacing.xl),
                  Text('Badges', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: AppSpacing.sm),
                  const Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      TripClipBadgeFilter(
                        svgAsset: 'assets/icons/house.svg',
                        label: 'Residential',
                      ),
                      TripClipBadgeFilter(
                        svgAsset: 'assets/icons/clock.svg',
                        label: 'Resi',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Badge status',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      TripClipBadgeStatus(
                        label: 'Label',
                        tone: TripClipBadgeStatusTone.danger,
                        showLeadingIcon: false,
                      ),
                      TripClipBadgeStatus(
                        label: 'Label',
                        tone: TripClipBadgeStatusTone.warning,
                        showTrailingIcon: false,
                        svgAsset: 'assets/icons/house.svg',
                      ),
                      TripClipBadgeStatus(
                        label: 'Label',
                        tone: TripClipBadgeStatusTone.success,
                      ),
                      TripClipBadgeStatus(
                        label: 'Label',
                        tone: TripClipBadgeStatusTone.primary,
                      ),
                      TripClipBadgeStatus(
                        label: 'Label',
                        tone: TripClipBadgeStatusTone.neutral,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Badge clip',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      TripClipBadgeClip(label: r'$xxx'),
                      TripClipBadgeClip(
                        label: r'$xxx',
                        flexibleLabel: 'Flexible',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Badge delivery timing',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [TripClipBadgeDeliveryTiming(label: 'Urgent')],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Badge counter',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      TripClipBadgeCounter(count: 9),
                      TripClipBadgeCounter(count: 12),
                      TripClipBadgeCounter(count: 100),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text('Theme', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: AppSpacing.sm),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Light'),
                      ),
                      ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('System'),
                      ),
                    ],
                    selected: {TripClipAppScope.of(context).themeMode},
                    onSelectionChanged: (s) {
                      TripClipAppScope.of(context).applyThemeMode(s.first);
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Pill buttons',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      TripClipButton(
                        variant: TripClipButtonVariant.primary,
                        label: 'Primary',
                        onPressed: () {},
                      ),
                      TripClipButton(
                        variant: TripClipButtonVariant.primary,
                        label: 'Primary',
                        svgAsset: 'assets/icons/heart24.svg',
                        iconPlacement: TripClipButtonIconPlacement.leading,
                        onPressed: () {},
                      ),
                      TripClipButton(
                        variant: TripClipButtonVariant.primaryAlternative,
                        label: 'Orange',
                        onPressed: () {},
                      ),
                      TripClipButton(
                        variant: TripClipButtonVariant.secondary,
                        label: 'Outlined',
                        onPressed: () {},
                      ),
                      TripClipButton(
                        variant: TripClipButtonVariant.tertiary,
                        label: 'Tertiary',
                        onPressed: () {},
                      ),
                      TripClipButton(
                        variant: TripClipButtonVariant.destructive,
                        label: 'Delete',
                        onPressed: () {},
                      ),
                      TripClipButton(
                        variant: TripClipButtonVariant.primary,
                        svgAsset: 'assets/icons/heart24.svg',
                        iconPlacement: TripClipButtonIconPlacement.iconOnly,
                        onPressed: () {},
                      ),
                      TripClipButton(
                        variant: TripClipButtonVariant.destructive,
                        label: 'Delete',
                        svgAsset: 'assets/icons/heart24.svg',
                        iconPlacement: TripClipButtonIconPlacement.trailing,
                        onPressed: () {},
                      ),
                      TripClipButton(
                        variant: TripClipButtonVariant.primary,
                        label: 'Delete',
                        svgAsset: 'assets/icons/heart24.svg',
                        iconPlacement: TripClipButtonIconPlacement.trailing,
                        onPressed: null,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TripClipButton(
                    variant: TripClipButtonVariant.primary,
                    label: 'Full width primary',
                    expanded: true,
                    onPressed: () {},
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Auxiliary controls',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TripClipLabeledCircleActionButton(
                        svgAsset: 'assets/icons/heart24.svg',
                        label: 'Label',
                        onPressed: () {},
                      ),
                      TripClipLabeledCircleActionButton(
                        svgAsset: 'assets/icons/heart24.svg',
                        label: 'Active',
                        selected: true,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.sm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      TripClipFavoriteListButton(
                        isFavorite: false,
                        svgAsset: 'assets/icons/heart24.svg',
                        onPressed: () {},
                      ),
                      TripClipFavoriteListButton(
                        isFavorite: true,
                        svgAsset: 'assets/icons/heart24.svg',
                        onPressed: () {},
                      ),
                      TripClipSubNavButton(
                        svgAsset: 'assets/icons/arrow-up-down.svg',
                        label: 'Sort',
                        onPressed: () {},
                      ),
                      TripClipSubNavButton(
                        svgAsset: 'assets/icons/arrow-up-down.svg',
                        label: 'Label',
                        selected: true,
                        onPressed: () {},
                      ),
                      TripClipSquareIconButton(
                        svgAsset: 'assets/icons/pencil-edit.svg',
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text('Toasts', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      TripClipButton(
                        variant: TripClipButtonVariant.secondary,
                        label: 'Error',
                        onPressed: () => AppToast.show(
                          context,
                          message: 'Something went wrong.',
                          kind: AppToastKind.error,
                        ),
                      ),
                      TripClipButton(
                        variant: TripClipButtonVariant.secondary,
                        label: 'Warning',
                        onPressed: () => AppToast.show(
                          context,
                          message: 'Please review this action.',
                          kind: AppToastKind.warning,
                        ),
                      ),
                      TripClipButton(
                        variant: TripClipButtonVariant.secondary,
                        label: 'Success',
                        onPressed: () => AppToast.show(
                          context,
                          message: 'Saved successfully.',
                          kind: AppToastKind.success,
                        ),
                      ),
                      TripClipButton(
                        variant: TripClipButtonVariant.secondary,
                        label: 'Info',
                        onPressed: () => AppToast.show(
                          context,
                          message: 'FYI: new policy is available.',
                          kind: AppToastKind.info,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Form inputs',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TripClipFormInput(
                    label: 'Insert Label',
                    hintText: 'Insert placeholder...',
                    helperText: 'Insert text',
                    onSubmitted: (_) {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TripClipFormInput(
                    label: 'Insert Label',
                    hintText: 'Insert placeholder...',
                    helperText: 'Insert text',
                    status: TripClipFormStatus.error,
                    onSubmitted: (_) {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TripClipFormInput(
                    label: 'Insert Label',
                    hintText: 'Insert placeholder...',
                    helperText: 'Insert text',
                    status: TripClipFormStatus.warning,
                    onSubmitted: (_) {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TripClipFormInput(
                    label: 'Insert Label',
                    hintText: 'Insert placeholder...',
                    helperText: 'Insert text',
                    status: TripClipFormStatus.success,
                    onSubmitted: (_) {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TripClipFormInput(
                    label: 'Insert Label',
                    hintText: 'Insert placeholder...',
                    helperText: 'Disabled field',
                    enabled: false,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TripClipFormInput(
                    label: 'Large field',
                    hintText: 'Insert placeholder...',
                    helperText: 'Insert text',
                    density: TripClipFormDensity.large,
                    onSubmitted: (_) {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TripClipFormInput(
                    label: 'Large error field',
                    hintText: 'Insert placeholder...',
                    helperText: 'Insert text',
                    status: TripClipFormStatus.error,
                    density: TripClipFormDensity.large,
                    onSubmitted: (_) {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TripClipFormInput(
                    label: 'Large warning field',
                    hintText: 'Insert placeholder...',
                    helperText: 'Insert text',
                    status: TripClipFormStatus.warning,
                    density: TripClipFormDensity.large,
                    onSubmitted: (_) {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TripClipFormInput(
                    label: 'Large success field',
                    hintText: 'Insert placeholder...',
                    helperText: 'Insert text',
                    status: TripClipFormStatus.success,
                    density: TripClipFormDensity.large,
                    onSubmitted: (_) {},
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Form textarea',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TripClipFormTextarea(
                    label: 'Insert Text',
                    hintText: 'Enter description',
                    helperText: 'Insert text',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TripClipFormTextarea(
                    label: 'Insert Text',
                    hintText: 'Enter description',
                    helperText: 'Insert text',
                    status: TripClipFormStatus.error,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TripClipFormTextarea(
                    label: 'Insert Text',
                    hintText: 'Enter description',
                    helperText: 'Insert text',
                    status: TripClipFormStatus.warning,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TripClipFormTextarea(
                    label: 'Insert Text',
                    hintText: 'Enter description',
                    helperText: 'Insert text',
                    status: TripClipFormStatus.success,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TripClipFormTextarea(
                    label: 'Insert Text',
                    hintText: 'Enter description',
                    helperText: 'Disabled field',
                    enabled: false,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Checkbox & radio',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const _TripClipSelectionDemo(),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Form toggle & radio button',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const _TripClipTogglePillDemo(),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Form slider',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const _TripClipSliderDemo(),
                  const SizedBox(height: AppSpacing.xl),
                  Text('Theme', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: AppSpacing.sm),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Light'),
                      ),
                      ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('System'),
                      ),
                    ],
                    selected: {TripClipAppScope.of(context).themeMode},
                    onSelectionChanged: (s) {
                      TripClipAppScope.of(context).applyThemeMode(s.first);
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Atom input',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TripClipAtomInput(
                    hintText: 'Insert placeholder...',
                    onSubmitted: (_) {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TripClipAtomInput(
                    hintText: 'Insert placeholder...',
                    status: TripClipFormStatus.error,
                    onSubmitted: (_) {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TripClipAtomInput(
                    hintText: 'Insert placeholder...',
                    status: TripClipFormStatus.warning,
                    onSubmitted: (_) {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TripClipAtomInput(
                    hintText: 'Insert placeholder...',
                    status: TripClipFormStatus.success,
                    onSubmitted: (_) {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TripClipAtomInput(
                    hintText: 'XXX',
                    enabled: false,
                    onSubmitted: (_) {},
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Form messages',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const TripClipFormMessage(
                    text: 'Insert text',
                    kind: TripClipFormMessageKind.neutral,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const TripClipFormMessage(
                    text: 'Insert text',
                    kind: TripClipFormMessageKind.error,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const TripClipFormMessage(
                    text: 'Insert text',
                    kind: TripClipFormMessageKind.warning,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const TripClipFormMessage(
                    text: 'Insert text',
                    kind: TripClipFormMessageKind.success,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const TripClipFormMessage(
                    text: 'Insert text',
                    kind: TripClipFormMessageKind.info,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    height: 160,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.surfaceMuted,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colors.borderSubtle,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Text(
                      'Placeholder surface',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TripClipSliderDemo extends StatefulWidget {
  const _TripClipSliderDemo();

  @override
  State<_TripClipSliderDemo> createState() => _TripClipSliderDemoState();
}

class _TripClipSliderDemoState extends State<_TripClipSliderDemo> {
  double _distance = 25;
  double _clip = 25;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TripClipFormSlider(
          title: 'Distance from your location',
          labelLeft: '1km',
          labelRight: '50km',
          value: _distance,
          min: 1,
          max: 50,
          onChanged: (v) => setState(() => _distance = v),
        ),
        const SizedBox(height: AppSpacing.md),
        TripClipFormSlider(
          title: r'$ Clip',
          labelLeft: r'AUD $1',
          labelRight: r'AUD $50',
          value: _clip,
          min: 1,
          max: 50,
          onChanged: (v) => setState(() => _clip = v),
        ),
      ],
    );
  }
}

class _TripClipTogglePillDemo extends StatefulWidget {
  const _TripClipTogglePillDemo();

  @override
  State<_TripClipTogglePillDemo> createState() =>
      _TripClipTogglePillDemoState();
}

class _TripClipTogglePillDemoState extends State<_TripClipTogglePillDemo> {
  bool _toggleOff = false;
  bool _toggleOn = true;
  int _pill = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TripClipFormToggle(
          label: 'Toggle label',
          value: _toggleOff,
          onChanged: (v) => setState(() => _toggleOff = v),
        ),
        const SizedBox(height: AppSpacing.md),
        TripClipFormToggle(
          label: 'Toggle label',
          value: _toggleOn,
          onChanged: (v) => setState(() => _toggleOn = v),
        ),
        const SizedBox(height: AppSpacing.md),
        TripClipFormToggle(
          label: 'Toggle label',
          value: false,
          onChanged: null,
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            TripClipFormRadioButton(
              selected: _pill == 0,
              onPressed: () => setState(() => _pill = 0),
              label: 'Business',
            ),
            TripClipFormRadioButton(
              selected: _pill == 1,
              onPressed: () => setState(() => _pill = 1),
              label: 'Business',
            ),
          ],
        ),
      ],
    );
  }
}

class _TripClipFormCalendarDemo extends StatelessWidget {
  const _TripClipFormCalendarDemo();

  @override
  Widget build(BuildContext context) {
    return const TripClipFormCalendar();
  }
}

class _TripClipSelectionDemo extends StatefulWidget {
  const _TripClipSelectionDemo();

  @override
  State<_TripClipSelectionDemo> createState() => _TripClipSelectionDemoState();
}

class _TripClipSelectionDemoState extends State<_TripClipSelectionDemo> {
  bool _unchecked = false;
  bool _checked = true;
  int _radioGroup = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TripClipFormCheckbox(
          value: _unchecked,
          onChanged: (v) => setState(() => _unchecked = v),
          label: 'Checkbox option label',
        ),
        const SizedBox(height: AppSpacing.md),
        TripClipFormCheckbox(
          value: _checked,
          onChanged: (v) => setState(() => _checked = v),
          label: 'Checkbox option label',
        ),
        const SizedBox(height: AppSpacing.md),
        TripClipFormCheckbox(
          value: false,
          onChanged: null,
          label: 'Checkbox option label',
        ),
        const SizedBox(height: AppSpacing.lg),
        TripClipFormRadio<int>(
          value: 0,
          groupValue: _radioGroup,
          onChanged: (v) {
            if (v != null) setState(() => _radioGroup = v);
          },
          label: 'Radio option label',
        ),
        const SizedBox(height: AppSpacing.md),
        TripClipFormRadio<int>(
          value: 1,
          groupValue: _radioGroup,
          onChanged: (v) {
            if (v != null) setState(() => _radioGroup = v);
          },
          label: 'Radio option label',
        ),
        const SizedBox(height: AppSpacing.md),
        TripClipFormRadio<int>(
          value: 2,
          groupValue: _radioGroup,
          onChanged: null,
          label: 'Radio option label',
        ),
      ],
    );
  }
}
*/
