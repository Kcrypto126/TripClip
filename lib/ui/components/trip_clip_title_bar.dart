import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/trip_clip_colors.dart';

class TripClipTitleBar extends StatelessWidget implements PreferredSizeWidget {
  const TripClipTitleBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.onBack,
    this.includeStatusBarInset = true,
    this.clipBorderRadius,
    this.trailing,
  });

  final String title;
  final bool showBack;
  final VoidCallback? onBack;

  final bool includeStatusBarInset;
  final BorderRadius? clipBorderRadius;

  final Widget? trailing;

  static const double toolbarHeight = 40;

  static const double _horizontalPadding = 10;
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
    toolbarHeight + (includeStatusBarInset ? _statusBarHeightLogicalPx() : 0),
  );

  static TextStyle titleTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          color: context.tripClipColors.textBase,
        );
  }

  @override
  Widget build(BuildContext context) {
    final bg = context.tripClipColors.pageBackground;
    final iconColor = context.tripClipColors.textBase;

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
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
              ),
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
                  trailing != null
                      ? SizedBox(
                          width: _chevronTapSize,
                          child: Center(child: trailing!),
                        )
                      : const SizedBox(width: _chevronTapSize),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    if (clipBorderRadius != null) {
      return ClipRRect(borderRadius: clipBorderRadius!, child: column);
    }
    return column;
  }
}

class _TitleBarBackButton extends StatelessWidget {
  const _TitleBarBackButton({required this.iconColor, required this.onPressed});

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
