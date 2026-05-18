import 'package:flutter/material.dart';

import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/pages/trip_clip_stepped_title_page_scaffold.dart';
import 'trip_clip_parcels_create_clip_page.dart';
import 'trip_clip_parcels_create_models.dart';
import 'trip_clip_parcels_create_scope.dart';
import 'trip_clip_parcels_item_details_form.dart';

class TripClipParcelsItemDetailsPage extends StatefulWidget {
  const TripClipParcelsItemDetailsPage({
    super.key,
    required this.itemIndex,
    required this.controllers,
    required this.totalItems,
  });

  final int itemIndex;
  final TripClipParcelsItemDetailsControllers controllers;
  final int totalItems;

  static const int totalSteps = 7;

  @override
  State<TripClipParcelsItemDetailsPage> createState() =>
      _TripClipParcelsItemDetailsPageState();
}

class _TripClipParcelsItemDetailsPageState
    extends State<TripClipParcelsItemDetailsPage> {
  static const int _stepIndex = 4;

  final GlobalKey<TripClipParcelsItemDetailsFormState> _formKey =
      GlobalKey<TripClipParcelsItemDetailsFormState>();
  final ValueNotifier<bool> _stepValid = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _stepValid.dispose();
    super.dispose();
  }

  bool get _returnToSummary {
    final a = ModalRoute.of(context)?.settings.arguments;
    return a is ParcelsCreatePageArgs && a.returnToSummary;
  }

  String _primaryLabel() {
    if (_returnToSummary) return 'Summary';
    final isLast = widget.itemIndex >= widget.totalItems - 1;
    if (isLast) return 'Clip Details';
    return 'Item ${widget.itemIndex + 2}';
  }

  void _onPrimaryPressed() {
    final form = _formKey.currentState;
    if (form == null || !_stepValid.value) return;
    final draft = form.buildDraft();
    final scope = TripClipParcelsCreateScope.of(context);
    scope.setItem(widget.itemIndex, draft);

    if (_returnToSummary) {
      Navigator.of(context).pop();
      return;
    }

    final isLast = widget.itemIndex >= widget.totalItems - 1;
    if (isLast) {
      pushTripClipParcelsCreateRoute<void>(
        context,
        const TripClipParcelsCreateClipPage(),
      );
      return;
    }

    final nextDraft = scope.itemOrNull(widget.itemIndex + 1);
    pushTripClipParcelsCreateRoute<void>(
      context,
      TripClipParcelsItemDetailsPage(
        itemIndex: widget.itemIndex + 1,
        totalItems: widget.totalItems,
        controllers:
            TripClipParcelsItemDetailsControllers.fromDraft(nextDraft),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemNumber = widget.itemIndex + 1;
    final initial =
        TripClipParcelsCreateScope.of(context).itemOrNull(widget.itemIndex);

    return TripClipSteppedTitlePageScaffold(
      currentStep: _stepIndex,
      totalSteps: TripClipParcelsItemDetailsPage.totalSteps,
      title: 'Item $itemNumber',
      onStepChanged: (next) {
        if (next < _stepIndex) Navigator.of(context).maybePop();
      },
      onExitAtFirstStep: () => Navigator.of(context).maybePop(),
      body: TripClipParcelsItemDetailsForm(
        key: _formKey,
        itemIndex: widget.itemIndex,
        controllers: widget.controllers,
        stepValid: _stepValid,
        initialDraft: initial,
      ),
      bottomBar: SafeArea(
        top: false,
        minimum: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: ValueListenableBuilder<bool>(
            valueListenable: _stepValid,
            builder: (context, canGo, _) {
              return TripClipButton(
                variant: TripClipButtonVariant.primary,
                expanded: true,
                label: _primaryLabel(),
                iconPlacement: TripClipButtonIconPlacement.trailing,
                svgAsset: 'assets/icons/chevron-right.svg',
                onPressed: canGo ? _onPrimaryPressed : null,
              );
            },
          ),
        ),
      ),
    );
  }
}
