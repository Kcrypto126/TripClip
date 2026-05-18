import 'package:flutter/material.dart';
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
    this.backgroundImage = const NetworkImage('https://raw.githubusercontent.com/Kcrypto126/TripClip/refs/heads/main/assets/images/melbourne.webp'),
    this.initialFavorite = false,
    this.onFavoriteChanged,
    this.favoriteButtonSize = 24,
    this.favoriteButtonInset = 4,
    this.onTap,
  });

  final String heading;
  final String body;

  final double? width;
  final double height;

  final EdgeInsets padding;
  final double borderRadius;

  final ImageProvider<Object> backgroundImage;

  final bool initialFavorite;
  final ValueChanged<bool>? onFavoriteChanged;

  final double favoriteButtonSize;
  final double favoriteButtonInset;

  final VoidCallback? onTap;

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

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final headingTextStyle = t.titleLarge!.copyWith(color: Colors.white);
    final bodyTextStyle = t.bodySmall!.copyWith(color: Colors.white);
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
                  Image(
                    image: widget.backgroundImage,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color(0xFF1C2430),
                            ),
                          ),
                          Positioned.fill(child: child),
                        ],
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const DecoratedBox(
                        decoration: BoxDecoration(color: Color(0xFF1C2430)),
                      );
                    },
                  ),
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
                  if (widget.onTap != null)
                    Positioned.fill(
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: widget.onTap,
                          splashFactory: NoSplash.splashFactory,
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
                          style: headingTextStyle,
                        ),
                        Text(
                          widget.body,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: bodyTextStyle,
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
