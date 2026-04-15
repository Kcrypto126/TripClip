import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../../app/trip_clip_app.dart';
import '../../../ui/components/app_card.dart';
import '../../../ui/components/app_toast.dart';
import '../../../ui/components/badges/trip_clip_badges.dart';
import '../../../ui/components/buttons/trip_clip_auxiliary_buttons.dart';
import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/cards/trip_clip_feature_card.dart';
import '../../../ui/components/cards/trip_clip_heading_card.dart';
import '../../../ui/components/cards/trip_clip_result_card.dart';
import '../../../ui/components/cards/trip_clip_semi_feature_card.dart';
import '../../../ui/components/forms/trip_clip_forms.dart';
import '../../../ui/components/trip_clip_avatar.dart';
import '../../../ui/components/trip_clip_chat_bubble.dart';
import '../../../ui/components/trip_clip_steps_status_bar.dart';
import '../../../ui/components/trip_clip_title_bar.dart';
import '../../../ui/foundations/app_spacing.dart';

class TripClipComponentsContent extends StatefulWidget {
  const TripClipComponentsContent({super.key});

  @override
  State<TripClipComponentsContent> createState() =>
      _TripClipComponentsContentState();
}

class _TripClipComponentsContentState extends State<TripClipComponentsContent> {
  static const int _flowTotalSteps = 5;
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.tripClipColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TripClipTitleBar(
          title: 'Components',
          includeStatusBarInset: true,
          onBack: () => Navigator.of(context).maybePop(),
          trailing: const _ComponentsThemeToggleButton(),
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
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Buttons',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      TripClipButton(
                        label: 'Primary',
                        onPressed: () {},
                        variant: TripClipButtonVariant.primary,
                      ),
                      TripClipButton(
                        label: 'Secondary',
                        onPressed: () {},
                        variant: TripClipButtonVariant.secondary,
                      ),
                      TripClipButton(
                        label: 'Disabled',
                        onPressed: null,
                        variant: TripClipButtonVariant.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text('Toasts', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: AppSpacing.sm),
                  _ToastDemoRow(
                    label: 'Show toast',
                    onPressed: () => AppToast.show(
                      context,
                      message: 'Message',
                      kind: AppToastKind.info,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text('Forms', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: AppSpacing.sm),
                  const _TripClipSliderDemo(),
                  const SizedBox(height: AppSpacing.lg),
                  const _TripClipTogglePillDemo(),
                  const SizedBox(height: AppSpacing.lg),
                  const _TripClipSelectionDemo(),
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
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
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ToastDemoRow extends StatelessWidget {
  const _ToastDemoRow({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        TripClipSquareIconButton(
          svgAsset: 'assets/icons/house.svg',
          onPressed: onPressed,
          size: 40,
          radius: 8,
          borderColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.transparent
              : Theme.of(context).dividerColor,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.white,
          iconColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
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

/// Switches app theme between light and dark (matches title bar icon colors).
class _ComponentsThemeToggleButton extends StatelessWidget {
  const _ComponentsThemeToggleButton();

  static const double _tapSize = 40;
  static const double _iconSize = 22;

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final iconColor = light ? TripClipPalette.tertiary500 : Colors.white;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          TripClipAppScope.of(
            context,
          ).applyThemeMode(light ? ThemeMode.dark : ThemeMode.light);
        },
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: _tapSize,
          height: _tapSize,
          child: Icon(
            light ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            size: _iconSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
