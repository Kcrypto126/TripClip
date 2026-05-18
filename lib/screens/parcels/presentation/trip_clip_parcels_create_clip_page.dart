import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/forms/trip_clip_atom_input.dart';
import '../../../ui/components/forms/trip_clip_form_checkbox.dart';
import '../../../ui/components/forms/trip_clip_form_models.dart';
import '../../../ui/components/pages/trip_clip_stepped_title_page_scaffold.dart';
import 'trip_clip_parcels_create_models.dart';
import 'trip_clip_parcels_create_scope.dart';
import 'trip_clip_parcels_create_summary_page.dart' deferred as parcels_summary;

class TripClipParcelsCreateClipPage extends StatefulWidget {
  const TripClipParcelsCreateClipPage({super.key});

  static const int totalSteps = 7;

  @override
  State<TripClipParcelsCreateClipPage> createState() =>
      _TripClipParcelsCreateClipPageState();
}

class _TripClipParcelsCreateClipPageState
    extends State<TripClipParcelsCreateClipPage> {
  static const int _stepIndex = 5;
  static const int _kServiceFeeBps = 1000;

  late final TextEditingController _clip;
  bool _allowAlternativeOffers = false;
  int? _clipCents;
  int? _serviceFeeCents;
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    _clip = TextEditingController();
    _clip.addListener(_recompute);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    final c = TripClipParcelsCreateScope.maybeOf(context);
    if (c == null) return;
    _seeded = true;
    final d = c.draft;
    if (d.clipCents != null && d.clipCents! > 0) {
      final dollars = d.clipCents! / 100.0;
      _clip.text = dollars == dollars.truncateToDouble()
          ? dollars.toInt().toString()
          : dollars.toStringAsFixed(2);
    }
    if (d.allowAlternativeClip) {
      _allowAlternativeOffers = true;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _recompute();
    });
  }

  @override
  void dispose() {
    _clip.removeListener(_recompute);
    _clip.dispose();
    super.dispose();
  }

  int? _parseCentsFromDisplay(String s) {
    final digits = s.replaceAll(RegExp(r'[^0-9.]'), '');
    if (digits.isEmpty) return null;
    if (RegExp(r'\.').allMatches(digits).length > 1) {
      return null;
    }
    final parts = digits.split('.');
    final whole = int.tryParse(parts[0].isEmpty ? '0' : parts[0]) ?? 0;
    if (parts.length == 1) {
      return whole * 100;
    }
    final fracRaw = parts[1];
    final padded = '${fracRaw}00'.substring(0, 2);
    final frac = int.tryParse(padded) ?? 0;
    if (frac >= 100) return null;
    return whole * 100 + frac;
  }

  void _recompute() {
    final cents = _parseCentsFromDisplay(_clip.text);
    if (cents == null) {
      if (!mounted) return;
      if (_clipCents != null || _serviceFeeCents != null) {
        setState(() {
          _clipCents = null;
          _serviceFeeCents = null;
        });
      }
      return;
    }

    final service = (cents * _kServiceFeeBps / 10000).round();
    if (!mounted) return;
    if (cents == _clipCents && service == _serviceFeeCents) return;
    setState(() {
      _clipCents = cents;
      _serviceFeeCents = service;
    });
  }

  String _formatAudDollars(int cents) {
    return (cents ~/ 100).toString();
  }

  bool get _returnToSummary {
    final a = ModalRoute.of(context)?.settings.arguments;
    return a is ParcelsCreatePageArgs && a.returnToSummary;
  }

  bool get _canContinue {
    return _clipCents != null &&
        _clipCents! > 0 &&
        _allowAlternativeOffers;
  }

  void _goNext() {
    if (!_canContinue) return;
    TripClipParcelsCreateScope.of(context).setClip(
      clipCents: _clipCents,
      allowAlternative: _allowAlternativeOffers,
    );
    if (_returnToSummary) {
      Navigator.of(context).pop();
      return;
    }
    unawaited(_openSummary());
  }

  Future<void> _openSummary() async {
    try {
      await parcels_summary.loadLibrary();
      if (!mounted) {
        return;
      }
      pushTripClipParcelsCreateRouteRaw<void>(
        context,
        parcels_summary.TripClipParcelsCreateSummaryPage(),
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final base = context.tripClipColors.textBase;
    final subtle = context.tripClipColors.textSubtle;

    final bodyStyle = t.bodyMedium!.copyWith(color: base);
    final sectionLabelStyle = t.headlineMedium!.copyWith(
      color: base,
    );

    final serviceText = _serviceFeeCents == null
        ? r'Service Fee $'
        : 'Service Fee \$ ${_formatAudDollars(_serviceFeeCents!)}';

    return TripClipSteppedTitlePageScaffold(
      currentStep: _stepIndex,
      totalSteps: TripClipParcelsCreateClipPage.totalSteps,
      title: 'Clip',
      onStepChanged: (next) {
        if (next < _stepIndex) Navigator.of(context).maybePop();
      },
      onExitAtFirstStep: () => Navigator.of(context).maybePop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Clip amount', style: sectionLabelStyle),
          const SizedBox(height: 8),
          Text(
            'Enter a starting clip amount you’re willing to pay for delivery.',
            style: bodyStyle,
          ),
          const SizedBox(height: 24),
          TripClipAtomInput(
            controller: _clip,
            hintText: r'AUD $100',
            showLeading: false,
            showTrailing: false,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            density: TripClipFormDensity.large,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/australia.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r'AUD $',
                      style: t.bodySmall!.copyWith(
                        color: subtle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        r'Australian dollar',
                        style: t.bodySmall!.copyWith(
                          color: base,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            serviceText,
            style: t.bodySmall!.copyWith(
              color: _serviceFeeCents == null ? subtle : base,
            ),
          ),
          const SizedBox(height: 40),
          Text('Flexible clip', style: sectionLabelStyle),
          const SizedBox(height: 8),
          Text(
            'Allow travellers to suggest a different clip amount. This can increase the chance of delivery. You choose whether to accept.',
            style: bodyStyle,
          ),
          const SizedBox(height: 8),
          TripClipFormCheckbox(
            value: _allowAlternativeOffers,
            onChanged: (v) => setState(() => _allowAlternativeOffers = v),
            label: 'Allow alternative clip offers',
          ),
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
            label: 'Summary',
            iconPlacement: TripClipButtonIconPlacement.trailing,
            svgAsset: 'assets/icons/chevron-right.svg',
            onPressed: _canContinue ? _goNext : null,
          ),
        ),
      ),
    );
  }
}
