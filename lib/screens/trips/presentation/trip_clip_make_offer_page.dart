import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../ui/components/forms/trip_clip_atom_input.dart';
import '../../../ui/components/forms/trip_clip_form_models.dart';
import '../../../ui/components/pages/trip_clip_content_page_scaffold.dart';

class TripClipMakeOfferPage extends StatefulWidget {
  const TripClipMakeOfferPage({
    super.key,
    this.currentClipDisplay = r'AUD $175',
    this.initialOfferDisplay = r'AUD $200',
  });

  final String currentClipDisplay;
  final String initialOfferDisplay;

  @override
  State<TripClipMakeOfferPage> createState() => _TripClipMakeOfferPageState();
}

class _TripClipMakeOfferPageState extends State<TripClipMakeOfferPage> {
  static const double _sectionGap = 24;

  late final TextEditingController _newClipController;
  late final TextEditingController _currentClipController;

  @override
  void initState() {
    super.initState();
    _newClipController = TextEditingController(text: widget.initialOfferDisplay);
    _currentClipController = TextEditingController(
      text: widget.currentClipDisplay,
    );
  }

  @override
  void dispose() {
    _newClipController.dispose();
    _currentClipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final base = context.tripClipColors.textBase;

    final bodyTextStyle = t.bodyMedium!.copyWith(color: base);
    final labelStyle = t.bodySmall!.copyWith(
      fontWeight: FontWeight.w500,
      color: base,
    );

    return TripClipContentPageScaffold(
      appBarTitle: 'Make an offer',
      heading: 'Make an offer',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Offer an alternative amount you\'re willing to accept to '
            'deliver these items.',
            style: bodyTextStyle,
          ),
          const SizedBox(height: _sectionGap),
          Text('New Clip', style: labelStyle),
          const SizedBox(height: 8),
          TripClipAtomInput(
            controller: _newClipController,
            density: TripClipFormDensity.large,
            showLeading: false,
            showTrailing: false,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: _sectionGap),
          Text('Current Clip', style: labelStyle),
          const SizedBox(height: 8),
          TripClipAtomInput(
            controller: _currentClipController,
            density: TripClipFormDensity.large,
            readOnly: true,
            showLeading: false,
            showTrailing: false,
            enabled: false,
          ),
        ],
      ),
    );
  }
}
