import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../ui/components/buttons/trip_clip_auxiliary_buttons.dart';
import 'trip_clip_trips_scope_args.dart';

class TripClipTripsDrillShell extends StatefulWidget {
  const TripClipTripsDrillShell({
    super.key,
    required this.args,
    required this.body,
    this.initialSubNavIndex = 0,
    this.expandBodyBelowHeading = false,
    this.onViewPressed,
    this.onListPressed,
    this.onMapPressed,
    this.onSortPressed,
    this.onFilterPressed,
    this.showViewNavButton = true,
    this.showListNavButton = false,
  });

  final TripClipTripsScopeArgs args;
  final Widget body;

  final int initialSubNavIndex;

  final bool expandBodyBelowHeading;

  final VoidCallback? onViewPressed;
  final VoidCallback? onListPressed;
  final VoidCallback? onMapPressed;
  final VoidCallback? onSortPressed;
  final VoidCallback? onFilterPressed;

  final bool showViewNavButton;
  final bool showListNavButton;

  @override
  State<TripClipTripsDrillShell> createState() => _TripClipTripsDrillShellState();
}

class _TripClipTripsDrillShellState extends State<TripClipTripsDrillShell> {
  static const double _headerRowHeight = 44;
  static const double _headerDividerHeight = 1;

  late int _viewOrMapIndex;

  @override
  void initState() {
    super.initState();
    _viewOrMapIndex = widget.initialSubNavIndex.clamp(0, 1);
  }

  @override
  void didUpdateWidget(covariant TripClipTripsDrillShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSubNavIndex != widget.initialSubNavIndex) {
      _viewOrMapIndex = widget.initialSubNavIndex.clamp(0, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final headerBorder = context.tripClipColors.borderSubtle;
    final headerStyle = Theme.of(context).textTheme.headlineLarge!.copyWith(
          color: context.tripClipColors.heading,
        );

    final headingColor = context.tripClipColors.textBase;
    final countColor = context.tripClipColors.textBase;
    final backIconColor = context.tripClipColors.textSubtle;

    final bodyHeadingStyle =
        Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: headingColor,
              height: 24 / 22,
            );
    final countStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
          color: countColor,
        );

    final tripCountLabel = '${widget.args.tripCount} Trips';
    final pinnedTop = _headerRowHeight + _headerDividerHeight;

    final headingRow = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          style: IconButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: const Size(24, 24),
            visualDensity: VisualDensity.compact,
          ),
          icon: SvgPicture.asset(
            'assets/icons/chevron-left.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              backIconColor,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            widget.args.scopeTitle,
            style: bodyHeadingStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(tripCountLabel, style: countStyle),
      ],
    );

    final Widget mainContent;
    if (widget.expandBodyBelowHeading) {
      mainContent = Padding(
        padding: EdgeInsets.only(top: pinnedTop + 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: headingRow,
            ),
            const SizedBox(height: 16),
            Expanded(child: widget.body),
          ],
        ),
      );
    } else {
      mainContent = SingleChildScrollView(
        padding: EdgeInsets.only(
          top: pinnedTop + 16,
          bottom: 16,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              headingRow,
              const SizedBox(height: 16),
              widget.body,
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.tripClipColors.pageBackground,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(child: mainContent),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: ColoredBox(
                color: context.tripClipColors.pageBackground,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: _headerRowHeight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Trips', style: headerStyle),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                reverse: true,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (widget.showViewNavButton) ...[
                                      TripClipSubNavButton(
                                        svgAsset:
                                            'assets/icons/view-agenda.svg',
                                        label: 'View',
                                        selected: _viewOrMapIndex == 0,
                                        onPressed: () {
                                          if (widget.onViewPressed != null) {
                                            widget.onViewPressed!();
                                          } else {
                                            setState(
                                                () => _viewOrMapIndex = 0);
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    if (widget.showListNavButton) ...[
                                      TripClipSubNavButton(
                                        svgAsset: 'assets/icons/list.svg',
                                        label: 'List',
                                        selected: false,
                                        onPressed:
                                            widget.onListPressed ?? () {},
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    TripClipSubNavButton(
                                      svgAsset: 'assets/icons/map-search.svg',
                                      label: 'Map',
                                      selected: _viewOrMapIndex == 1,
                                      onPressed: () {
                                        if (widget.onMapPressed != null) {
                                          widget.onMapPressed!();
                                        } else {
                                          setState(() => _viewOrMapIndex = 1);
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    TripClipSubNavButton(
                                      svgAsset:
                                          'assets/icons/arrow-up-down.svg',
                                      label: 'Sort',
                                      selected: false,
                                      onPressed:
                                          widget.onSortPressed ?? () {},
                                    ),
                                    const SizedBox(width: 8),
                                    TripClipSubNavButton(
                                      svgAsset: 'assets/icons/filter.svg',
                                      label: 'Filter',
                                      selected: false,
                                      onPressed:
                                          widget.onFilterPressed ?? () {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _headerDividerHeight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: headerBorder),
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
