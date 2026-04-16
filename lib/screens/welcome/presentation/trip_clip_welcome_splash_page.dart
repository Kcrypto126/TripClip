import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TripClipWelcomeSplashPage extends StatelessWidget {
  const TripClipWelcomeSplashPage({super.key, required this.onContinue});

  final VoidCallback onContinue;

  static const Color _background = Color(0xFF0000D2);
  static const double _pagePadding = 32;

  static const double _navySize = 280;
  static const double _orangeSize = 200;
  static const Color _navyStroke = Color(0xFF141E46);
  static const Color _orangeStroke = Color(0xFFFA782D);
  static const double _strokeWidth = 1.5;
  static const double _rectRadius = 16;

  static const double _navyVerticalLift = 80;
  static const double _orangeBottomInset = 190;

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.rubik(
      fontSize: 60,
      fontWeight: FontWeight.w600,
      height: 64 / 60,
      letterSpacing: 0,
      color: Colors.white,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _background,
        systemNavigationBarColor: _background,
      ),
      child: Scaffold(
        backgroundColor: _background,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onContinue,
          child: SizedBox.expand(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final h = constraints.maxHeight;
                  final w = constraints.maxWidth;
                  final navyLeft = w - _navySize * 0.88;
                  final navyTop = (h - _navySize) / 2 - _navyVerticalLift;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: navyLeft,
                        top: navyTop,
                        child: _StrokeFrame(
                          size: _navySize,
                          color: _navyStroke,
                          borderWidth: _strokeWidth,
                          borderRadius: _rectRadius,
                        ),
                      ),
                      Positioned(
                        left: _pagePadding,
                        bottom: _orangeBottomInset,
                        child: _StrokeFrame(
                          size: _orangeSize,
                          color: _orangeStroke,
                          borderWidth: _strokeWidth,
                          borderRadius: _rectRadius,
                        ),
                      ),
                      Positioned(
                        left: _pagePadding,
                        top: _pagePadding,
                        child: SvgPicture.asset(
                          'assets/icons/home-logo-dark.svg',
                          width: 200,
                          height: 44,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        left: _pagePadding,
                        bottom: _pagePadding,
                        right: _pagePadding,
                        child: Text(
                          'Turn trips\ninto clips',
                          textAlign: TextAlign.left,
                          style: textStyle,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StrokeFrame extends StatelessWidget {
  const _StrokeFrame({
    required this.size,
    required this.color,
    required this.borderWidth,
    required this.borderRadius,
  });

  final double size;
  final Color color;
  final double borderWidth;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: color, width: borderWidth),
        ),
      ),
    );
  }
}
