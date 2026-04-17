import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/onboarding/trip_clip_onboarding_feature_section.dart';
import '../../../ui/components/trip_clip_steps_status_bar.dart';

class TripClipOnboardingSplashPage extends StatefulWidget {
  const TripClipOnboardingSplashPage({
    super.key,
    required this.onComplete,
    required this.onBackToWelcome,
  });

  final VoidCallback onComplete;
  final VoidCallback onBackToWelcome;

  static const Color backgroundColor = Color(0xFF0000D2);

  /// Track tint for the step bar on brand blue (light grey segment).
  static const Color stepBarTrackOnBlue = Color(0x4DFFFFFF);

  static const EdgeInsets bodyPadding = EdgeInsets.fromLTRB(24, 16, 24, 32);

  @override
  State<TripClipOnboardingSplashPage> createState() =>
      _TripClipOnboardingSplashPageState();
}

class _TripClipOnboardingSplashPageState
    extends State<TripClipOnboardingSplashPage> {
  int _step = 0;

  /// When true, the shared-axis transition runs in "pop" direction (step back).
  bool _reverseStepTransition = false;

  static const Duration _stepSwitchDuration = Duration(milliseconds: 340);

  static const List<_OnboardingStepData> _steps = [
    _OnboardingStepData(
      imageAsset: 'assets/images/step1.webp',
      imageCircular: false,
      heading: 'Send with ease. Travel and earn.',
      description: 'A smarter way to send parcels and make your trips count.',
    ),
    _OnboardingStepData(
      imageAsset: 'assets/images/step2.webp',
      imageCircular: true,
      heading: 'Got a parcel? Send it easily.',
      description:
          'Travellers already heading your way can take care of it for you.',
    ),
    _OnboardingStepData(
      imageAsset: 'assets/images/step3.webp',
      imageCircular: false,
      heading: 'Taking a trip? Earn a clip.',
      description:
          'Choose deliveries that fit your journey and get paid for them.',
    ),
    _OnboardingStepData(
      imageAsset: 'assets/images/step4.webp',
      imageCircular: true,
      heading: 'People-powered delivery.',
      description: 'Smarter delivery, empowering you to move parcels your way.',
    ),
  ];

  void _setStep(int value) {
    final next = TripClipStepsStatusBar.clampStep(
      value,
      totalSteps: _steps.length,
    );
    if (next == _step) return;
    setState(() {
      _reverseStepTransition = next < _step;
      _step = next;
    });
  }

  void _onPrimaryPressed() {
    if (_step < _steps.length - 1) {
      _setStep(_step + 1);
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _steps[_step];
    final isLast = _step == _steps.length - 1;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: TripClipOnboardingSplashPage.backgroundColor,
        systemNavigationBarColor: TripClipOnboardingSplashPage.backgroundColor,
      ),
      child: Scaffold(
        backgroundColor: TripClipOnboardingSplashPage.backgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TripClipStepsStatusBar(
                currentStep: _step,
                totalSteps: _steps.length,
                showRightChevron: false,
                chevronColor: Colors.white,
                trackColor: TripClipOnboardingSplashPage.stepBarTrackOnBlue,
                onStepChanged: _setStep,
                onExitAtFirstStep: widget.onBackToWelcome,
              ),
              Expanded(
                child: Padding(
                  padding: TripClipOnboardingSplashPage.bodyPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRect(
                          child: PageTransitionSwitcher(
                            duration: _stepSwitchDuration,
                            reverse: _reverseStepTransition,
                            layoutBuilder: (List<Widget> entries) {
                              return Stack(
                                alignment: Alignment.topCenter,
                                fit: StackFit.passthrough,
                                children: entries,
                              );
                            },
                            transitionBuilder:
                                (
                                  Widget child,
                                  Animation<double> primaryAnimation,
                                  Animation<double> secondaryAnimation,
                                ) {
                              return SharedAxisTransition(
                                animation: primaryAnimation,
                                secondaryAnimation: secondaryAnimation,
                                transitionType:
                                    SharedAxisTransitionType.horizontal,
                                fillColor:
                                    TripClipOnboardingSplashPage.backgroundColor,
                                child: child,
                              );
                            },
                            child: KeyedSubtree(
                              key: ValueKey<int>(_step),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: TripClipOnboardingFeatureSection(
                                    imageAsset: data.imageAsset,
                                    imageCircular: data.imageCircular,
                                    heading: data.heading,
                                    description: data.description,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      TripClipButton(
                        variant: TripClipButtonVariant.primaryAlternative,
                        expanded: true,
                        label: isLast ? 'Get Started' : 'Continue',
                        onPressed: _onPrimaryPressed,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingStepData {
  const _OnboardingStepData({
    required this.imageAsset,
    required this.imageCircular,
    required this.heading,
    required this.description,
  });

  final String imageAsset;
  final bool imageCircular;
  final String heading;
  final String description;
}
