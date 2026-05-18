import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/forms/trip_clip_atom_input.dart';
import '../../../ui/components/pages/trip_clip_stepped_title_page_scaffold.dart';
import 'trip_clip_parcels_create_models.dart';
import 'trip_clip_parcels_create_pickup_page.dart';
import 'trip_clip_parcels_create_scope.dart';

class TripClipParcelsCreateTripNamePage extends StatefulWidget {
  const TripClipParcelsCreateTripNamePage({super.key});

  static const int totalSteps = 7;

  @override
  State<TripClipParcelsCreateTripNamePage> createState() =>
      _TripClipParcelsCreateTripNamePageState();
}

class _TripClipParcelsCreateTripNamePageState
    extends State<TripClipParcelsCreateTripNamePage> {
  static const int _stepIndex = 0;

  late final TextEditingController _nameController;
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool _hasTrimmedName(String text) => text.trim().isNotEmpty;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    final c = TripClipParcelsCreateScope.maybeOf(context);
    if (c == null) return;
    _seeded = true;
    final t = c.draft.tripName;
    if (t.isNotEmpty) {
      _nameController.text = t;
    }
  }

  bool get _returnToSummary {
    final a = ModalRoute.of(context)?.settings.arguments;
    return a is ParcelsCreatePageArgs && a.returnToSummary;
  }

  void _goNext() {
    if (!_hasTrimmedName(_nameController.text)) return;
    final scope = TripClipParcelsCreateScope.of(context);
    scope.setTripName(_nameController.text);
    if (_returnToSummary) {
      Navigator.of(context).pop();
      return;
    }
    pushTripClipParcelsCreateRoute<void>(
      context,
      const TripClipParcelsCreatePickupPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final promptStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
      fontWeight: FontWeight.w500,
      color: context.tripClipColors.textBase,
    );

    return TripClipSteppedTitlePageScaffold(
      currentStep: _stepIndex,
      totalSteps: TripClipParcelsCreateTripNamePage.totalSteps,
      title: 'Trip Name',
      onExitAtFirstStep: () => Navigator.of(context).maybePop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('What would you like to call your trip?', style: promptStyle),
          const SizedBox(height: 8),
          TripClipAtomInput(
            controller: _nameController,
            hintText: 'Eg. Christmas Presents',
            showLeading: false,
            showTrailing: false,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
      bottomBar: SafeArea(
        top: false,
        minimum: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _nameController,
            builder: (context, value, _) {
              final canContinue = _hasTrimmedName(value.text);
              return TripClipButton(
                variant: TripClipButtonVariant.primary,
                expanded: true,
                label: _returnToSummary ? 'Summary' : 'Pickup Details',
                iconPlacement: TripClipButtonIconPlacement.trailing,
                svgAsset: 'assets/icons/chevron-right.svg',
                onPressed: canContinue ? _goNext : null,
              );
            },
          ),
        ),
      ),
    );
  }
}
