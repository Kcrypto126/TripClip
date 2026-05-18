import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/pages/trip_clip_stepped_title_page_scaffold.dart';
import 'trip_clip_parcels_item_details_form.dart';
import 'trip_clip_parcels_item_details_page.dart';
import 'trip_clip_parcels_create_models.dart';
import 'trip_clip_parcels_create_scope.dart';

class TripClipParcelsCreateItemsPage extends StatefulWidget {
  const TripClipParcelsCreateItemsPage({super.key});

  static const int totalSteps = 7;

  @override
  State<TripClipParcelsCreateItemsPage> createState() =>
      _TripClipParcelsCreateItemsPageState();
}

class _TripClipParcelsCreateItemsPageState
    extends State<TripClipParcelsCreateItemsPage> {
  static const int _stepIndex = 4;

  static const double _kCellSize = 80;

  static const int _kMinCount = 1;
  static const int _kMaxCount = 999;

  int _count = 1;
  final TextEditingController _countController = TextEditingController(text: '1');
  final FocusNode _countFocus = FocusNode();
  bool _syncingText = false;
  bool _seeded = false;

  bool get _returnToSummary {
    final a = ModalRoute.of(context)?.settings.arguments;
    return a is ParcelsCreatePageArgs && a.returnToSummary;
  }

  Color get _counterBg => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF1F242B)
      : const Color(0xFFEFF2F5);

  @override
  void initState() {
    super.initState();
    _countController.addListener(_onCountTextChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    final scope = TripClipParcelsCreateScope.maybeOf(context);
    if (scope == null) return;
    _seeded = true;
    _setCount(scope.draft.itemCount);
  }

  @override
  void dispose() {
    _countController.removeListener(_onCountTextChanged);
    _countController.dispose();
    _countFocus.dispose();
    super.dispose();
  }

  void _setCount(int next) {
    final clamped = next.clamp(_kMinCount, _kMaxCount);
    if (clamped == _count) return;
    setState(() => _count = clamped);

    final nextText = '$clamped';
    if (_countController.text == nextText) return;
    _syncingText = true;
    _countController.value = TextEditingValue(
      text: nextText,
      selection: TextSelection.collapsed(offset: nextText.length),
    );
    _syncingText = false;
  }

  void _onCountTextChanged() {
    if (_syncingText) return;
    final raw = _countController.text.trim();
    if (raw.isEmpty) return;
    final parsed = int.tryParse(raw);
    if (parsed == null) return;
    _setCount(parsed);
  }

  void _normalizeCountField() {
    if (_countController.text.trim().isEmpty) {
      _setCount(_kMinCount);
      return;
    }
    _setCount(_count);
  }

  void _dec() => _setCount(_count - 1);
  void _inc() => _setCount(_count + 1);

  bool _canContinue() {
    final raw = _countController.text.trim();
    if (raw.isEmpty) return false;
    final parsed = int.tryParse(raw);
    if (parsed == null) return false;
    return parsed >= _kMinCount && parsed <= _kMaxCount;
  }

  void _goNext() {
    _normalizeCountField();
    final scope = TripClipParcelsCreateScope.of(context);
    scope.setItemCount(_count);
    if (_returnToSummary) {
      Navigator.of(context).pop();
      return;
    }
    final first = scope.itemOrNull(0);
    pushTripClipParcelsCreateRoute<void>(
      context,
      TripClipParcelsItemDetailsPage(
        itemIndex: 0,
        totalItems: _count,
        controllers: TripClipParcelsItemDetailsControllers.fromDraft(first),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    final bodyStyle = t.bodyMedium!.copyWith(
      color: context.tripClipColors.textBase,
    );

    final numberStyle = t.headlineLarge!.copyWith(
      color: context.tripClipColors.textBase,
      fontWeight: FontWeight.w600,
    );

    final border = context.tripClipColors.heading;

    return TripClipSteppedTitlePageScaffold(
      currentStep: _stepIndex,
      totalSteps: TripClipParcelsCreateItemsPage.totalSteps,
      title: 'Items',
      onStepChanged: (next) {
        if (next < _stepIndex) Navigator.of(context).maybePop();
      },
      onExitAtFirstStep: () => Navigator.of(context).maybePop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How many items do you want to send?', style: bodyStyle),
          const SizedBox(height: 16),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CounterIconButton(
                  size: _kCellSize,
                  svgAsset: 'assets/icons/minus.svg',
                  background: _counterBg,
                  radius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  onPressed: _dec,
                ),
                _CounterValueBox(
                  size: _kCellSize,
                  controller: _countController,
                  focusNode: _countFocus,
                  background: _counterBg,
                  borderColor: border,
                  textStyle: numberStyle,
                  onEditingComplete: _normalizeCountField,
                ),
                _CounterIconButton(
                  size: _kCellSize,
                  svgAsset: 'assets/icons/plus.svg',
                  background: _counterBg,
                  radius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  onPressed: _inc,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomBar: SafeArea(
        top: false,
        minimum: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: AnimatedBuilder(
            animation: _countController,
            builder: (context, _) {
              return TripClipButton(
                variant: TripClipButtonVariant.primary,
                expanded: true,
                label: _returnToSummary ? 'Summary' : 'Item Details',
                iconPlacement: TripClipButtonIconPlacement.trailing,
                svgAsset: 'assets/icons/chevron-right.svg',
                onPressed: _canContinue() ? _goNext : null,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CounterIconButton extends StatelessWidget {
  const _CounterIconButton({
    required this.size,
    required this.svgAsset,
    required this.background,
    required this.radius,
    required this.onPressed,
  });

  final double size;
  final String svgAsset;
  final Color background;
  final BorderRadius radius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final iconColor = context.tripClipColors.textSubtle;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: radius,
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: background,
            borderRadius: radius,
          ),
          child: Center(
            child: SvgPicture.asset(
              svgAsset,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}

class _CounterValueBox extends StatelessWidget {
  const _CounterValueBox({
    required this.size,
    required this.controller,
    required this.focusNode,
    required this.background,
    required this.borderColor,
    required this.textStyle,
    required this.onEditingComplete,
  });

  final double size;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color background;
  final Color borderColor;
  final TextStyle textStyle;
  final VoidCallback onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: textStyle,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          onEditingComplete: onEditingComplete,
        ),
      ),
    );
  }
}

