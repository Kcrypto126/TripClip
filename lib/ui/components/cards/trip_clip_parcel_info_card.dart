import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../buttons/trip_clip_auxiliary_buttons.dart';
import '../buttons/trip_clip_button.dart';
import '../buttons/trip_clip_button_models.dart';
import '../../foundations/app_spacing.dart';
import 'trip_clip_card_shadows.dart';

class TripClipParcelInfoCard extends StatefulWidget {
  const TripClipParcelInfoCard({
    super.key,
    required this.indexLabel,
    required this.title,
    this.parcelImages = const [],
    required this.description,
    this.seeMoreLabel = 'See more',
    this.onSeeMore,
    this.descriptionMaxWords = 20,
    required this.typeLabel,
    required this.sizeDimensions,
    required this.weightLabel,
    required this.insuranceLabel,
    this.onEditPressed,
    this.borderRadius = 8,
  });

  final String indexLabel;

  final String title;

  final List<ImageProvider<Object>> parcelImages;

  final String description;
  final String seeMoreLabel;
  final VoidCallback? onSeeMore;
  final int descriptionMaxWords;

  final String typeLabel;
  final String sizeDimensions;
  final String weightLabel;
  final String insuranceLabel;
  final VoidCallback? onEditPressed;

  final double borderRadius;

  static const double _cardPadding = 24;
  static const double _sectionGap = 24;
  static const double _headingBodyGap = 8;
  static const double _imageW = 86;
  static const double _imageH = 64;
  static const double _imageGap = 8;
  static const double _iconTextGap = 4;
  static const double _iconSize = 20;
  static const double _badgeSize = 36;
  static const Color _bodyBackgroundLight = Color(0xFFF0F4F7);

  static const String _kPackage = 'assets/icons/package.svg';
  static const String _kPackageDimensions =
      'assets/icons/package-dimensions.svg';
  static const String _kWeight = 'assets/icons/weight.svg';
  static const String _kVerify = 'assets/icons/verify-outline.svg';

  @override
  State<TripClipParcelInfoCard> createState() => _TripClipParcelInfoCardState();
}

class _TripClipParcelInfoCardState extends State<TripClipParcelInfoCard> {
  bool _expandedDescription = false;

  ({String preview, bool isTruncated}) _truncateByWords(
    String input, {
    required int maxWords,
  }) {
    final t = input.trim();
    if (t.isEmpty) return (preview: '', isTruncated: false);

    final words = t.split(RegExp(r'\s+'));
    if (words.length <= maxWords) return (preview: t, isTruncated: false);

    return (preview: '${words.take(maxWords).join(' ')}...', isTruncated: true);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final isDark = !isLight;

    final bodyBg = isLight
        ? TripClipParcelInfoCard._bodyBackgroundLight
        : TripClipPalette.neutral900;
    final onBodyPrimary = context.tripClipColors.textBase;
    final onBodySecondary = context.tripClipColors.textSubtle;
    final iconOnBody = context.tripClipColors.textSubtle;
    const badgeNumberOnOrange = Color(0xFFFFFFFF);

    final truncated = _truncateByWords(
      widget.description,
      maxWords: widget.descriptionMaxWords,
    );
    final showSeeMore = truncated.isTruncated && !_expandedDescription;
    final descriptionText = _expandedDescription
        ? widget.description.trim()
        : truncated.preview;

    final r = BorderRadius.circular(widget.borderRadius);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: r,
        boxShadow: TripClipCardShadows.whenLight(isLight),
      ),
      child: ClipRRect(
        borderRadius: r,
        child: Container(
          color: bodyBg,
          width: double.infinity,
          padding: const EdgeInsets.all(TripClipParcelInfoCard._cardPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _titleRow(
                t: t,
                titleColor: onBodyPrimary,
                badgeNumberColor: badgeNumberOnOrange,
              ),
              const SizedBox(height: TripClipParcelInfoCard._sectionGap),
              _body(
                t: t,
                isDark: isDark,
                onBodyPrimary: onBodyPrimary,
                onBodySecondary: onBodySecondary,
                iconOnBody: iconOnBody,
                descriptionText: descriptionText,
                showSeeMore: showSeeMore,
                onSeeMore: () {
                  setState(() => _expandedDescription = true);
                  widget.onSeeMore?.call();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleRow({
    required TextTheme t,
    required Color titleColor,
    required Color badgeNumberColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: TripClipParcelInfoCard._badgeSize,
          height: TripClipParcelInfoCard._badgeSize,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: TripClipPalette.secondary500,
            shape: BoxShape.circle,
          ),
          child: Text(
            widget.indexLabel,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: t.headlineMedium!.copyWith(color: badgeNumberColor),
          ),
        ),
        const SizedBox(width: TripClipParcelInfoCard._imageGap),
        Expanded(
          child: Text(
            widget.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: t.headlineMedium!.copyWith(color: titleColor),
          ),
        ),
        if (widget.onEditPressed != null) ...[
          const SizedBox(width: TripClipParcelInfoCard._imageGap),
          TripClipSquareIconButton(
            size: 32,
            onPressed: widget.onEditPressed,
          ),
        ],
      ],
    );
  }

  Widget _body({
    required TextTheme t,
    required bool isDark,
    required Color onBodyPrimary,
    required Color onBodySecondary,
    required Color iconOnBody,
    required String descriptionText,
    required bool showSeeMore,
    required VoidCallback onSeeMore,
  }) {
    final sectionHeadingStyle = t.headlineSmall!.copyWith(color: onBodyPrimary);
    final bodyStyle = t.bodyMedium!.copyWith(color: onBodyPrimary);
    final seeMoreStyle = t.bodyMedium!.copyWith(
      fontWeight: FontWeight.w400,
      color: onBodySecondary,
    );

    Widget vGap8() =>
        const SizedBox(height: TripClipParcelInfoCard._headingBodyGap);
    Widget sectionGap() =>
        const SizedBox(height: TripClipParcelInfoCard._sectionGap);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Images', style: sectionHeadingStyle),
        vGap8(),
        _imageRow(isDark: isDark),
        sectionGap(),
        Text('Description', style: sectionHeadingStyle),
        vGap8(),
        Text(descriptionText, style: bodyStyle),
        if (showSeeMore) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: TripClipButton(
              variant: TripClipButtonVariant.tertiary,
              label: widget.seeMoreLabel,
              onPressed: onSeeMore,
              styleOverride: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: onBodySecondary,
                textStyle: seeMoreStyle,
              ),
            ),
          ),
        ],
        if (showSeeMore) ...[
          const SizedBox(height: AppSpacing.sm),
        ] else ...[
          sectionGap(),
        ],
        Text('Type, Size & Weight', style: sectionHeadingStyle),
        vGap8(),
        _iconRow(
          iconAsset: TripClipParcelInfoCard._kPackage,
          text: widget.typeLabel,
          color: iconOnBody,
          mainTextStyle: bodyStyle,
        ),
        const SizedBox(height: AppSpacing.sm),
        _iconRow(
          iconAsset: TripClipParcelInfoCard._kPackageDimensions,
          text: widget.sizeDimensions,
          color: iconOnBody,
          mainTextStyle: bodyStyle,
        ),
        const SizedBox(height: AppSpacing.sm),
        _iconRow(
          iconAsset: TripClipParcelInfoCard._kWeight,
          text: widget.weightLabel,
          color: iconOnBody,
          mainTextStyle: bodyStyle,
        ),
        sectionGap(),
        Text('Insurance', style: sectionHeadingStyle),
        vGap8(),
        _iconRow(
          iconAsset: TripClipParcelInfoCard._kVerify,
          text: widget.insuranceLabel,
          color: iconOnBody,
          mainTextStyle: bodyStyle,
        ),
      ],
    );
  }

  Widget _imageRow({required bool isDark}) {
    final ph = isDark ? TripClipPalette.neutral800 : TripClipPalette.neutral200;
    if (widget.parcelImages.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: TripClipParcelInfoCard._imageGap,
      runSpacing: TripClipParcelInfoCard._imageGap,
      children: [
        for (final provider in widget.parcelImages)
          _imageCell(
            isDark: isDark,
            provider: provider,
            placeholderColor: ph,
          ),
      ],
    );
  }

  Widget _imageCell({
    required bool isDark,
    required ImageProvider<Object> provider,
    required Color placeholderColor,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image(
        image: provider,
        width: TripClipParcelInfoCard._imageW,
        height: TripClipParcelInfoCard._imageH,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _imagePlaceholder(placeholderColor),
        loadingBuilder: (c, w, p) {
          if (p == null) return w;
          return SizedBox(
            width: TripClipParcelInfoCard._imageW,
            height: TripClipParcelInfoCard._imageH,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isDark
                      ? TripClipPalette.neutral500
                      : TripClipPalette.neutral400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _imagePlaceholder(Color ph) {
    return Container(
      width: TripClipParcelInfoCard._imageW,
      height: TripClipParcelInfoCard._imageH,
      color: ph,
    );
  }

  Widget _iconRow({
    required String iconAsset,
    required String text,
    required Color color,
    required TextStyle mainTextStyle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          iconAsset,
          width: TripClipParcelInfoCard._iconSize,
          height: TripClipParcelInfoCard._iconSize,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        const SizedBox(width: TripClipParcelInfoCard._iconTextGap),
        Expanded(child: Text(text, style: mainTextStyle)),
      ],
    );
  }
}
