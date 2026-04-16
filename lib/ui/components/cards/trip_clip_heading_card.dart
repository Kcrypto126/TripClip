import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../buttons/trip_clip_auxiliary_buttons.dart';
import 'trip_clip_card_shadows.dart';

class TripClipHeadingCard extends StatefulWidget {
  const TripClipHeadingCard({
    super.key,
    required this.heading,
    required this.body,
    this.width,
    this.height = 150,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = 12,
    this.backgroundImage = const AssetImage('assets/images/bridge.jpg'),
    this.initialFavorite = false,
    this.onFavoriteChanged,
    this.favoriteButtonSize = 24,
    this.favoriteButtonInset = 4,
  });

  final String heading;
  final String body;

  /// If null, expands to the max available width.
  final double? width;
  final double height;

  final EdgeInsets padding;
  final double borderRadius;

  final ImageProvider<Object> backgroundImage;

  final bool initialFavorite;
  final ValueChanged<bool>? onFavoriteChanged;

  final double favoriteButtonSize;
  final double favoriteButtonInset;

  @override
  State<TripClipHeadingCard> createState() => _TripClipHeadingCardState();
}

class _TripClipHeadingCardState extends State<TripClipHeadingCard> {
  late bool _favorite;

  @override
  void initState() {
    super.initState();
    _favorite = widget.initialFavorite;
  }

  @override
  void didUpdateWidget(covariant TripClipHeadingCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialFavorite != widget.initialFavorite) {
      _favorite = widget.initialFavorite;
    }
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
    final r = BorderRadius.circular(widget.borderRadius);
    final light = Theme.of(context).brightness == Brightness.light;

    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedWidth = widget.width ?? constraints.maxWidth;

        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: r,
            boxShadow: TripClipCardShadows.whenLight(light),
          ),
          child: ClipRRect(
            borderRadius: r,
            child: SizedBox(
              width: resolvedWidth,
              height: widget.height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image(image: widget.backgroundImage, fit: BoxFit.cover),
                  // Helps keep text legible on bright images.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color(0xB3000000),
                          Color(0x40000000),
                          Color(0x00000000),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: widget.padding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: TripClipFavoriteListButton(
                            isFavorite: _favorite,
                            size: widget.favoriteButtonSize,
                            inset: widget.favoriteButtonInset,
                            onPressed: () {
                              setState(() => _favorite = !_favorite);
                              widget.onFavoriteChanged?.call(_favorite);
                            },
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.heading,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _rubik(
                            size: 16,
                            lineHeight: 20,
                            weight: FontWeight.w600,
                            letterSpacing: 0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.body,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _rubik(
                            size: 14,
                            lineHeight: 20,
                            weight: FontWeight.w400,
                            letterSpacing: 0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
