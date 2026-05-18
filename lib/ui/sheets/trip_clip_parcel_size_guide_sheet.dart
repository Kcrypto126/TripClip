import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_colors.dart';
import '../components/badges/trip_clip_badge_icon_label.dart';
import 'trip_clip_modal_sheet.dart';
import 'trip_clip_sheet_layout.dart';

Future<void> showTripClipParcelSizeGuideSheet(BuildContext context) {
  return TripClipModalSheet.show<void>(
    context,
    wrapToContent: false,
    builder: (sheetContext) {
      return TripClipTermsStyleSheet(
        title: 'Size Guide',
        expandBody: true,
        body: const _TripClipParcelSizeGuideBody(),
      );
    },
  );
}

class _TripClipParcelSizeGuideBody extends StatelessWidget {
  const _TripClipParcelSizeGuideBody();

  static const double _sectionGap = 48;
  static const double _imageH = 200;
  static const double _imageRadius = 8;
  static const String _boxIcon = 'assets/icons/package-dimensions.svg';

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final onBody = context.tripClipColors.textBase;
    final subtle = context.tripClipColors.textSubtle;

    final titleStyle = t.headlineSmall!.copyWith(
      color: onBody,
    );
    final detailStyle = t.bodyMedium!.copyWith(color: onBody);
    final exampleStyle = t.bodyMedium!.copyWith(color: subtle);

    Widget image(String asset) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(_imageRadius),
        child: ColoredBox(
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: _imageH,
            child: Image.asset(
              asset,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
          ),
        ),
      );
    }

    Widget titleRowWithBadge({
      required String code,
      required String heading,
    }) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TripClipBadgeIconLabel(label: code, svgAsset: _boxIcon),
          const SizedBox(width: 8),
          Expanded(
            child: Text(heading, style: titleStyle, maxLines: 2),
          ),
        ],
      );
    }

    Widget titleTextOnly(String text) {
      return Text(text, style: titleStyle);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          image('assets/icons/size-guide-1.png'),
          const SizedBox(height: 16),
          titleRowWithBadge(code: 'XS', heading: 'Extra Small'),
          const SizedBox(height: 4),
          Text('Up to: 20cm W x 15cm H x 5cm D', style: detailStyle),
          const SizedBox(height: 4),
          Text('Examples: Phone box, small envelope', style: exampleStyle),
          const SizedBox(height: _sectionGap),
          image('assets/icons/size-guide-2.png'),
          const SizedBox(height: 16),
          titleRowWithBadge(code: 'SM', heading: 'Small'),
          const SizedBox(height: 4),
          Text('Up to: 35cm W x 25cm H x 10cm D', style: detailStyle),
          const SizedBox(height: 4),
          Text('Examples: A4 satchel, book, small gift box', style: exampleStyle),
          const SizedBox(height: _sectionGap),
          titleTextOnly('SM: Small'),
          const SizedBox(height: 4),
          Text('Up to: 35cm W x 25cm H x 10cm D', style: detailStyle),
          const SizedBox(height: 4),
          Text('Examples: A4 satchel, book, small gift box', style: exampleStyle),
          const SizedBox(height: _sectionGap),
          titleTextOnly('MD: Medium'),
          const SizedBox(height: 4),
          Text('Up to: 45cm W x 30cm H x 20cm D', style: detailStyle),
          const SizedBox(height: 4),
          Text('Examples: Shoe box, medium parcel', style: exampleStyle),
          const SizedBox(height: _sectionGap),
          titleTextOnly('LG: Large'),
          const SizedBox(height: 4),
          Text('Up to: 60cm W x 40cm H x 30cm D', style: detailStyle),
          const SizedBox(height: 4),
          Text('Examples: Kitchen appliance box', style: exampleStyle),
          const SizedBox(height: _sectionGap),
          titleTextOnly('XL: Extra Large'),
          const SizedBox(height: 4),
          Text('Up to: 80cm W x 50cm H x 40cm D', style: detailStyle),
          const SizedBox(height: 4),
          Text('Examples: large parcel box, bulky items', style: exampleStyle),
        ],
      ),
    );
  }
}
