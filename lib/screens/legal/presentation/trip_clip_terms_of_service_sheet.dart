import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../../ui/components/trip_clip_title_bar.dart';

/// Presents a modal bottom sheet with the TripClip Terms of Service.
void showTripClipTermsOfServiceSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final height = MediaQuery.sizeOf(sheetContext).height * 0.92;
      return Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: height,
          child: const TripClipTermsOfServiceSheet(),
        ),
      );
    },
  );
}

class TripClipTermsOfServiceSheet extends StatelessWidget {
  const TripClipTermsOfServiceSheet({super.key});

  static const _sectionGap = 40.0;
  static const _headingBodyGap = 12.0;
  static const _bodyPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBg = context.tripClipColors.pageBackground;
    final border = context.tripClipColors.borderSubtle;
    final light = Theme.of(context).brightness == Brightness.light;
    final closeIconColor = light ? TripClipPalette.tertiary500 : Colors.white;
    final mainTitleColor =
        isDark ? TripClipPalette.primary400 : TripClipPalette.primary500;

    void dismiss() => Navigator.of(context).maybePop();

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Material(
        color: pageBg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TripClipTitleBar(
              includeStatusBarInset: false,
              title: 'Terms of Service',
              onBack: dismiss,
              trailing: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    icon: Icon(Icons.close, color: closeIconColor, size: 24),
                    onPressed: dismiss,
                    tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  ),
                ),
              ),
            ),
            Divider(height: 1, thickness: 1, color: border),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(_bodyPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terms of Service',
                      style: GoogleFonts.rubik(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        height: 32 / 28,
                        letterSpacing: 0,
                        color: mainTitleColor,
                      ),
                    ),
                    const SizedBox(height: _sectionGap),
                    _TermsSection(
                      heading: '1. Acceptance of Terms',
                      body:
                          'By accessing and using TripClip ("the Service"), you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
                    ),
                    const SizedBox(height: _sectionGap),
                    _TermsSection(
                      heading: '2. Use License',
                      body:
                          'Permission is granted to temporarily use the TripClip platform for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:',
                      bullets: const [
                        'Modify or copy the materials',
                        'Use the materials for any commercial purpose or for any public display',
                        'Attempt to reverse engineer any software contained within TripClip',
                        'Remove any copyright or other proprietary notations from the materials',
                      ],
                    ),
                    const SizedBox(height: _sectionGap),
                    _TermsSection(
                      heading: '3. User Accounts',
                      body:
                          'When you create an account with us, you must provide us with information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account on our Service.',
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Last updated: 1 November 2024',
                      style: GoogleFonts.rubik(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        letterSpacing: 0,
                        color: context.tripClipColors.textSubtle,
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

class _TermsSection extends StatelessWidget {
  const _TermsSection({
    required this.heading,
    required this.body,
    this.bullets,
  });

  final String heading;
  final String body;
  final List<String>? bullets;

  static const _sectionHeadingColor = TripClipPalette.tertiary500;

  @override
  Widget build(BuildContext context) {
    final bulletLines = bullets;
    final headingStyle = GoogleFonts.rubik(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 26 / 22,
      letterSpacing: 0,
      color: _sectionHeadingColor,
    );
    final bodyStyle = GoogleFonts.rubik(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 24 / 16,
      letterSpacing: 0,
      color: _sectionHeadingColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading, style: headingStyle),
        const SizedBox(height: TripClipTermsOfServiceSheet._headingBodyGap),
        Text(body, style: bodyStyle),
        if (bulletLines != null && bulletLines.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...bulletLines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: bodyStyle),
                  Expanded(child: Text(line, style: bodyStyle)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
