import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../../ui/components/badges/trip_clip_badge_icon_label.dart';
import '../../../ui/components/buttons/trip_clip_auxiliary_buttons.dart';
import '../../../ui/components/cards/trip_clip_card_divider.dart';
import '../../../ui/components/cards/trip_clip_parcel_info_card.dart';
import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/pages/trip_clip_stepped_title_page_scaffold.dart';
import 'trip_clip_parcels_create_clip_page.dart';
import 'trip_clip_parcels_create_flow_nav.dart';
import 'trip_clip_parcels_create_models.dart';
import 'trip_clip_parcels_create_scope.dart';
import 'trip_clip_parcels_delivery_success_page.dart';

class TripClipParcelsCreateSummaryPage extends StatelessWidget {
  const TripClipParcelsCreateSummaryPage({super.key});

  static const int _stepIndex = 6;
  static const int _totalSteps = 7;
  static const double sectionGap = 24;

  @override
  Widget build(BuildContext context) {
    final c = TripClipParcelsCreateScope.of(context);
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        return _SummaryBody(
          stepIndex: _stepIndex,
          totalSteps: _totalSteps,
          draft: c.draft,
        );
      },
    );
  }
}

String _sizeDimensionsLine(ParcelsItemDraft it) {
  final e = it.exactDimensions.trim();
  if (e.isNotEmpty) return e;
  return it.sizeLabel();
}

String _weightLine(ParcelsItemDraft it) {
  final e = it.exactWeight.trim();
  if (e.isNotEmpty) return e;
  return it.weightBandLabel();
}

String _formatAudDollarsFromCents(int? cents) {
  if (cents == null || cents <= 0) return '';
  return (cents ~/ 100).toString();
}

const double _kSummaryAddressIconBlock = 24;

bool _fitsDateTimeOnOneLine(
  BuildContext context,
  double maxWidth,
  String date,
  String time,
  TextStyle textStyle,
) {
  if (date.isEmpty || time.isEmpty) return true;
  final dir = Directionality.of(context);
  final scaler = MediaQuery.textScalerOf(context);
  double oneLineChipWidth(String text) {
    final painter = TextPainter(
      text: TextSpan(style: textStyle, text: text),
      textDirection: dir,
      textScaler: scaler,
      maxLines: 1,
    )..layout(maxWidth: double.infinity);
    return _kSummaryAddressIconBlock + painter.width;
  }

  return oneLineChipWidth(date) + 16 + oneLineChipWidth(time) <= maxWidth;
}

class _SummaryBody extends StatelessWidget {
  const _SummaryBody({
    required this.stepIndex,
    required this.totalSteps,
    required this.draft,
  });

  final int stepIndex;
  final int totalSteps;
  final ParcelsCreateDraft draft;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final base = context.tripClipColors.textBase;
    final subtle = context.tripClipColors.textSubtle;
    final divider = context.tripClipColors.borderSubtle;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sectionHeading = t.headlineMedium!.copyWith(color: base);
    final nameStyle = t.bodyLarge!.copyWith(color: base);
    final bodyStyle = t.bodyMedium!.copyWith(color: base);
    final clipLabelStyle = t.bodyLarge!.copyWith(color: subtle);
    final clipValueStyle = t.bodyLarge!.copyWith(color: base);
    const bps = 1000;
    final service = draft.serviceFeeCents(bps);
    final totalCents = draft.clipCents != null && service != null
        ? draft.clipCents! + service
        : null;

    void edit(ParcelsCreateFromSummary w, {int itemIndex = 0}) {
      pushParcelsCreateEditFromSummary(context, w, itemIndex: itemIndex);
    }

    void editClip() {
      const args = ParcelsCreatePageArgs(returnToSummary: true);
      pushTripClipParcelsCreateRoute<void>(
        context,
        const TripClipParcelsCreateClipPage(),
        settings: const RouteSettings(arguments: args),
      );
    }

    return TripClipSteppedTitlePageScaffold(
      currentStep: stepIndex,
      totalSteps: totalSteps,
      title: 'Summary',
      onStepChanged: (next) {
        if (next < stepIndex) Navigator.of(context).maybePop();
      },
      onExitAtFirstStep: () => Navigator.of(context).maybePop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          _SectionHeader(
            title: 'Trip Name',
            style: sectionHeading,
            onEdit: () => edit(ParcelsCreateFromSummary.tripName),
          ),
          const SizedBox(height: 16),
          _SummaryText(draft.tripName, nameStyle),
          const SizedBox(height: TripClipParcelsCreateSummaryPage.sectionGap),
          TripClipCardDivider(color: divider),
          const SizedBox(height: TripClipParcelsCreateSummaryPage.sectionGap),
          _SectionHeader(
            title: 'Pickup',
            style: sectionHeading,
            onEdit: () => edit(ParcelsCreateFromSummary.pickup),
          ),
          const SizedBox(height: 16),
          _AddressBlock(
            address: draft.pickup,
            bodyStyle: bodyStyle,
            t: t,
            base: base,
            subtle: subtle,
          ),
          const SizedBox(height: TripClipParcelsCreateSummaryPage.sectionGap),
          TripClipCardDivider(color: divider),
          const SizedBox(height: TripClipParcelsCreateSummaryPage.sectionGap),
          _SectionHeader(
            title: 'Delivery',
            style: sectionHeading,
            onEdit: () => edit(ParcelsCreateFromSummary.delivery),
          ),
          const SizedBox(height: 16),
          _AddressBlock(
            address: draft.delivery,
            bodyStyle: bodyStyle,
            t: t,
            base: base,
            subtle: subtle,
          ),
          const SizedBox(height: TripClipParcelsCreateSummaryPage.sectionGap),
          TripClipCardDivider(color: divider),
          const SizedBox(height: TripClipParcelsCreateSummaryPage.sectionGap),
          _SectionHeader(
            title: 'Recipient',
            style: sectionHeading,
            onEdit: () => edit(ParcelsCreateFromSummary.recipient),
          ),
          const SizedBox(height: 16),
          _IconTextRow(
            icon: 'assets/icons/user1.svg',
            text: draft.recipient.name,
            textStyle: nameStyle,
            iconColor: subtle,
          ),
          const SizedBox(height: 8),
          _IconTextRow(
            icon: 'assets/icons/email.svg',
            text: draft.recipient.email,
            textStyle: nameStyle,
            iconColor: subtle,
          ),
          const SizedBox(height: 8),
          _IconTextRow(
            icon: 'assets/icons/phone.svg',
            text: draft.recipient.mobile,
            textStyle: nameStyle,
            iconColor: subtle,
          ),
          const SizedBox(height: TripClipParcelsCreateSummaryPage.sectionGap),
          TripClipCardDivider(color: divider),
          const SizedBox(height: TripClipParcelsCreateSummaryPage.sectionGap),
          _SectionHeader(
            title: 'Items',
            style: sectionHeading,
            onEdit: () => edit(ParcelsCreateFromSummary.items),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < draft.itemCount; i++) ...[
            if (i > 0) const SizedBox(height: 24),
            _ItemCardForSummary(
              index: i,
              item: i < draft.items.length ? draft.items[i] : const ParcelsItemDraft(),
              onEdit: () => edit(ParcelsCreateFromSummary.item, itemIndex: i),
            ),
          ],
          const SizedBox(height: TripClipParcelsCreateSummaryPage.sectionGap),
          _SectionHeader(
            title: 'Clip',
            style: sectionHeading,
            onEdit: editClip,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Text(r'AUD $', style: clipLabelStyle)),
              Text(
                _formatAudDollarsFromCents(draft.clipCents),
                style: clipValueStyle,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: Text(r'Service Fee $', style: clipLabelStyle)),
              Text(
                _formatAudDollarsFromCents(service),
                style: clipValueStyle,
              ),
            ],
          ),
          if (draft.clipCents != null && draft.clipCents! > 0) ...[
            TripClipCardDivider(color: divider),
            Row(
              children: [
                Expanded(child: Text('Total \$', style: clipLabelStyle)),
                Text(
                  _formatAudDollarsFromCents(totalCents),
                  style: clipValueStyle,
                ),
              ],
            ),
          ],
          if (draft.clipCents != null &&
              draft.clipCents! > 0 &&
              draft.allowAlternativeClip) ...[
            const SizedBox(height: 8),
            Text(
              'Alternative clip offers allowed',
              style: t.bodySmall!.copyWith(color: subtle),
            ),
          ],
          const SizedBox(height: 16),
          if (isDark) const SizedBox(height: 8),
        ],
      ),
      bottomBar: SafeArea(
        top: false,
        minimum: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: TripClipButton(
            variant: TripClipButtonVariant.primary,
            expanded: true,
            label: 'Send',
            onPressed: () {
              final rootNav = Navigator.of(context, rootNavigator: true);
              Navigator.of(context).popUntil((route) => route.isFirst);
              rootNav.push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => const TripClipParcelsDeliverySuccessPage(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SummaryText extends StatelessWidget {
  const _SummaryText(this.text, this.style);

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(text, style: style);
  }
}

class _AddressBlock extends StatelessWidget {
  const _AddressBlock({
    required this.address,
    required this.bodyStyle,
    required this.t,
    required this.base,
    required this.subtle,
  });

  final ParcelsAddressDraft address;
  final TextStyle bodyStyle;
  final TextTheme t;
  final Color base;
  final Color subtle;

  @override
  Widget build(BuildContext context) {
    final line = address.displayAddressLine();
    final date = address.displayDateLabel();
    final time = address.displayTimeLabel(context);
    final notes = address.notes.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TripClipBadgeIconLabel(
            label: address.kind.label,
            svgAsset: address.kind.badgeSvgAsset,
          ),
        ),
        const SizedBox(height: 8),
        if (line.isNotEmpty)
          _IconTextRow(
            icon: 'assets/icons/location.svg',
            text: line,
            textStyle: bodyStyle,
            iconColor: subtle,
          )
        else
          const SizedBox.shrink(),
        if (line.isNotEmpty) const SizedBox(height: 8),
        if (date.isNotEmpty || time.isNotEmpty)
          LayoutBuilder(
            builder: (context, constraints) {
              final maxW = constraints.maxWidth;
              final hasBoth = date.isNotEmpty && time.isNotEmpty;
              final oneLine = hasBoth &&
                  _fitsDateTimeOnOneLine(
                    context,
                    maxW,
                    date,
                    time,
                    bodyStyle,
                  );

              if (hasBoth && oneLine) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _IconTextRow(
                      icon: 'assets/icons/calendar.svg',
                      text: date,
                      textStyle: bodyStyle,
                      iconColor: subtle,
                      expandText: false,
                      textMaxLines: 1,
                    ),
                    const SizedBox(width: 16),
                    _IconTextRow(
                      icon: 'assets/icons/clock.svg',
                      text: time,
                      textStyle: bodyStyle,
                      iconColor: subtle,
                      expandText: false,
                      textMaxLines: 1,
                    ),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (date.isNotEmpty)
                    _IconTextRow(
                      icon: 'assets/icons/calendar.svg',
                      text: date,
                      textStyle: bodyStyle,
                      iconColor: subtle,
                      expandText: true,
                      textMaxLines: 2,
                    ),
                  if (hasBoth) const SizedBox(height: 8),
                  if (time.isNotEmpty)
                    _IconTextRow(
                      icon: 'assets/icons/clock.svg',
                      text: time,
                      textStyle: bodyStyle,
                      iconColor: subtle,
                      expandText: true,
                      textMaxLines: 2,
                    ),
                ],
              );
            },
          ),
        if (date.isNotEmpty || time.isNotEmpty) const SizedBox(height: 16),
        if (notes.isNotEmpty) ...[
          Text(
            'Notes',
            style: t.bodySmall!.copyWith(
              fontWeight: FontWeight.w500,
              color: base,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: TripClipPalette.primary400),
            ),
            child: Text(
              address.notes,
              style: bodyStyle,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${address.notes.length}/600',
            style: t.bodySmall!.copyWith(color: subtle),
          ),
        ],
      ],
    );
  }
}

class _ItemCardForSummary extends StatelessWidget {
  const _ItemCardForSummary({
    required this.index,
    required this.item,
    required this.onEdit,
  });

  final int index;
  final ParcelsItemDraft item;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final providers = <ImageProvider<Object>>[
      for (final p in item.imagePaths) FileImage(File(p)),
    ];
    final dim = _sizeDimensionsLine(item).trim();
    final wt = _weightLine(item).trim();
    return TripClipParcelInfoCard(
      indexLabel: '${index + 1}',
      title: item.name,
      parcelImages: providers,
      description: item.description,
      typeLabel: item.typeLabel().isNotEmpty ? item.typeLabel() : ' ',
      sizeDimensions: dim.isEmpty ? ' ' : dim,
      weightLabel: wt.isEmpty ? ' ' : wt,
      insuranceLabel: item.insuranceShortLabel(),
      onEditPressed: onEdit,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.style,
    required this.onEdit,
  });

  final String title;
  final TextStyle style;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: style)),
        TripClipSquareIconButton(size: 32, onPressed: onEdit),
      ],
    );
  }
}

class _IconTextRow extends StatelessWidget {
  const _IconTextRow({
    required this.icon,
    required this.text,
    required this.textStyle,
    required this.iconColor,
    this.expandText = true,
    this.textMaxLines = 2,
  });

  final String icon;
  final String text;
  final TextStyle textStyle;
  final Color iconColor;
  final bool expandText;
  final int textMaxLines;

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      maxLines: textMaxLines,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      style: textStyle,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon,
          width: 20,
          height: 20,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        const SizedBox(width: 4),
        if (expandText) Expanded(child: textWidget) else textWidget,
      ],
    );
  }
}
