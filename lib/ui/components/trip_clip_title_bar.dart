import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme/trip_clip_colors.dart';
import '../../app/theme/trip_clip_palette.dart';

/// Title bar with optional status-bar inset + 56px toolbar: back chevron, centered
/// title only (no drawer / end actions). Metrics match [TripClipHomeAppBar]
/// (padding **16**, toolbar height **56**; chevron tap **40×40**, icon **24** like
/// the steps bar).
///
/// Set [includeStatusBarInset] to **false** when placing this below another bar that
/// already accounts for the system status bar (e.g. [TripClipHomeAppBar]).
///
/// Title: **18px / 22px line / w600 / letter-spacing 0** — **#141E46** light,
/// **#FFFFFF** dark.
class TripClipTitleBar extends StatelessWidget implements PreferredSizeWidget {
  const TripClipTitleBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.onBack,
    this.includeStatusBarInset = true,
    this.clipBorderRadius,
  });

  final String title;
  final bool showBack;
  final VoidCallback? onBack;

  /// When **true** (default), prepends the system status-bar spacer. Use **false**
  /// under another header that already includes it.
  final bool includeStatusBarInset;

  /// When set, clips the bar (e.g. modal sheet top corners).
  final BorderRadius? clipBorderRadius;

  static const double toolbarHeight = 56;

  static const double _horizontalPadding = 16;
  static const double _chevronTapSize = 40;
  static const double _chevronIconSize = 24;

  static double _statusBarHeightLogicalPx() {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return 0;
    final view = views.first;
    return view.padding.top / view.devicePixelRatio;
  }

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight +
            (includeStatusBarInset ? _statusBarHeightLogicalPx() : 0),
      );

  static TextStyle titleTextStyle(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    return GoogleFonts.rubik(
      fontSize: 18,
      height: 22 / 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: light ? TripClipPalette.tertiary500 : Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = context.tripClipColors.pageBackground;
    final light = Theme.of(context).brightness == Brightness.light;
    final iconColor = light ? TripClipPalette.tertiary500 : Colors.white;

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (includeStatusBarInset)
          SizedBox(height: MediaQuery.paddingOf(context).top),
        Material(
          color: bg,
          child: SizedBox(
            height: toolbarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  showBack
                      ? SizedBox(
                          width: _chevronTapSize,
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: _TitleBarBackButton(
                              iconColor: iconColor,
                              onPressed: () {
                                if (onBack != null) {
                                  onBack!();
                                } else {
                                  Navigator.maybePop(context);
                                }
                              },
                            ),
                          ),
                        )
                      : const SizedBox(width: _chevronTapSize),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: titleTextStyle(context),
                    ),
                  ),
                  const SizedBox(width: _chevronTapSize),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    if (clipBorderRadius != null) {
      return ClipRRect(
        borderRadius: clipBorderRadius!,
        child: column,
      );
    }
    return column;
  }
}

class _TitleBarBackButton extends StatelessWidget {
  const _TitleBarBackButton({
    required this.iconColor,
    required this.onPressed,
  });

  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: TripClipTitleBar._chevronTapSize,
          height: TripClipTitleBar._chevronTapSize,
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/chevron-left.svg',
              width: TripClipTitleBar._chevronIconSize,
              height: TripClipTitleBar._chevronIconSize,
              alignment: Alignment.center,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
