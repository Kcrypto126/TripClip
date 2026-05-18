import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/navigation/trip_clip_navigator.dart';
import '../../../app/theme/trip_clip_colors.dart';
import '../../../ui/components/cards/trip_clip_heading_card.dart';
import '../search/trip_clip_trip_search.dart';
import 'trip_clip_trips_scope_args.dart';
import 'trip_clip_trips_sub_page.dart';

class TripClipFavouriteTripsPage extends StatelessWidget {
  const TripClipFavouriteTripsPage({super.key, required this.trips});

  final List<TripClipFavouriteTripCardData> trips;

  @override
  Widget build(BuildContext context) {
    final headerBorder = context.tripClipColors.borderSubtle;
    final headerStyle = Theme.of(context).textTheme.headlineLarge!.copyWith(
          color: context.tripClipColors.heading,
        );

    return Scaffold(
      backgroundColor: context.tripClipColors.pageBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 44,
              padding: const EdgeInsets.only(left: 4, right: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: headerBorder, width: 1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: () => Navigator.of(context).maybePop(),
                      customBorder: const CircleBorder(),
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/chevron-left.svg',
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            colorFilter: ColorFilter.mode(
                              context.tripClipColors.heading,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Favourite Trips',
                      style: headerStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: trips.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final t = trips[i];
                  return TripClipHeadingCard(
                    width: double.infinity,
                    height: 204,
                    heading: t.heading,
                    body: t.body,
                    backgroundImage: t.image,
                    initialFavorite: true,
                    onTap: () {
                      tripClipPushMaterialPage<void>(
                        context,
                        TripClipTripsSubPage(
                          args: TripClipTripsScopeArgs(
                            scopeTitle: t.heading,
                            tripCount: tripClipTripCountFromBody(t.body),
                          ),
                        ),
                        shellNavHighlightTabIndex:
                            TripClipShellNavRoutes.tripsTabIndex,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TripClipFavouriteTripCardData {
  const TripClipFavouriteTripCardData({
    required this.heading,
    required this.body,
    required this.image,
  });

  final String heading;
  final String body;
  final ImageProvider<Object> image;
}
