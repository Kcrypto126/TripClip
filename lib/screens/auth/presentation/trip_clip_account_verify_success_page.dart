import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../../app/trip_clip_app.dart';
import '../../../ui/shell/main_shell_page.dart';
import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';

class TripClipAccountVerifySuccessPage extends StatelessWidget {
  const TripClipAccountVerifySuccessPage({
    super.key,
    this.onGoToAccount,
    this.successMessage,
  });

  final VoidCallback? onGoToAccount;

  final String? successMessage;

  static const String _defaultSuccessMessage =
      'Your mobile number has been verified';

  static const EdgeInsets _pagePadding = EdgeInsets.fromLTRB(16, 48, 16, 48);

  static const Color _pageBlue = Color(0xFF0000D2);

  @override
  Widget build(BuildContext context) {
    final headlineStyle =
        Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: _pageBlue,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: _pageBlue,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _pageBlue,
        body: SizedBox.expand(
          child: ColoredBox(
            color: _pageBlue,
            child: SafeArea(
              top: true,
              bottom: true,
              child: Padding(
                padding: _pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: SizedBox(
                              width: 160,
                              height: 160,
                              child: SvgPicture.asset(
                                'assets/icons/large-ticket-circle.svg',
                                width: 160,
                                height: 160,
                                fit: BoxFit.contain,
                                allowDrawingOutsideViewBox: true,
                                clipBehavior: Clip.none,
                                theme: const SvgTheme(
                                  currentColor: TripClipPalette.secondary500,
                                ),
                                placeholderBuilder: (context) => const SizedBox(
                                  width: 160,
                                  height: 160,
                                ),
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.confirmation_number_outlined,
                                    size: 120,
                                    color: TripClipPalette.secondary500,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            successMessage ?? _defaultSuccessMessage,
                            textAlign: TextAlign.center,
                            style: headlineStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    TripClipButton(
                      variant: TripClipButtonVariant.primaryAlternative,
                      expanded: true,
                      label: 'Go to account',
                      onPressed: () {
                        final go = onGoToAccount;
                        if (go != null) {
                          go();
                        } else {
                          TripClipAppScope.of(context).goToMainShell(
                            initialTabIndex: MainShellPage.accountTabIndex,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
