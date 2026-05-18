import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../app/theme/trip_clip_colors.dart';
import 'trip_clip_parcels_create_models.dart';
import '../../../ui/components/cards/trip_clip_card_shadows.dart';
import '../../../ui/components/forms/trip_clip_form_checkbox.dart';
import '../../../ui/components/forms/trip_clip_form_input.dart';
import '../../../ui/components/forms/trip_clip_form_radio_button.dart';
import '../../../ui/components/forms/trip_clip_form_textarea.dart';
import '../../../ui/sheets/trip_clip_parcel_size_guide_sheet.dart';

class TripClipParcelsItemDetailsControllers {
  TripClipParcelsItemDetailsControllers({
    String? initialName,
    String? initialDescription,
    List<ImageProvider>? initialImages,
    List<String> initialImagePaths = const [],
  })  : name = TextEditingController(text: initialName ?? ''),
        description = TextEditingController(text: initialDescription ?? ''),
        images = ValueNotifier<List<ImageProvider>>(
          initialImages ??
              initialImagePaths
                  .map((p) => FileImage(File(p)) as ImageProvider)
                  .toList(),
        );

  final TextEditingController name;
  final TextEditingController description;
  final ValueNotifier<List<ImageProvider>> images;

  factory TripClipParcelsItemDetailsControllers.fromDraft(
    ParcelsItemDraft? d,
  ) {
    if (d == null) return TripClipParcelsItemDetailsControllers();
    return TripClipParcelsItemDetailsControllers(
      initialName: d.name,
      initialDescription: d.description,
      initialImagePaths: d.imagePaths,
    );
  }

  void dispose() {
    name.dispose();
    description.dispose();
    images.dispose();
  }
}

class TripClipParcelsItemDetailsForm extends StatefulWidget {
  const TripClipParcelsItemDetailsForm({
    super.key,
    required this.itemIndex,
    required this.controllers,
    required this.stepValid,
    this.initialDraft,
    this.onAddImage,
    this.onRemoveImage,
  });

  final int itemIndex;
  final TripClipParcelsItemDetailsControllers controllers;
  final ValueNotifier<bool> stepValid;
  final ParcelsItemDraft? initialDraft;

  final Future<void> Function()? onAddImage;
  final Future<void> Function(int index)? onRemoveImage;

  @override
  State<TripClipParcelsItemDetailsForm> createState() =>
      TripClipParcelsItemDetailsFormState();
}

class TripClipParcelsItemDetailsFormState
    extends State<TripClipParcelsItemDetailsForm> {
  static const double _chipSpacing = 8;

  static const List<String> _kTypeOptions = [
    'Box',
    'Envelope',
    'Satchel',
    'Fragile',
    'Perishable',
    'Bulky',
  ];

  static const List<String> _kSizeOptions = ['XS', 'SM', 'MD', 'LG', 'XL'];

  static const List<String> _kWeightOptions = [
    '<3kg',
    '3–10kg',
    '10–20kg',
    '20kg+',
  ];

  static const List<String> _kInsuranceOptions = [
    'Basic\nIncluded',
    'Standard\nAUD \$4.00',
    'Premium\nAUD \$8.00',
  ];

  int _typeSelection = 0;
  int _sizeSelection = 1;
  int _weightSelection = 0;
  int _insuranceSelection = 0;

  final TextEditingController _exactDimensions = TextEditingController();
  final TextEditingController _exactWeight = TextEditingController();

  bool _confirmNoProhibited = false;
  bool _d1 = false;
  bool _d2 = false;
  bool _d3 = false;
  bool _d4 = false;

  void _onControllersChanged() => _recomputeStepValid();

  @override
  void initState() {
    super.initState();
    final d = widget.initialDraft;
    if (d != null) {
      _typeSelection = d.typeSelection;
      _sizeSelection = d.sizeSelection;
      _weightSelection = d.weightSelection;
      _insuranceSelection = d.insuranceSelection;
      _exactDimensions.text = d.exactDimensions;
      _exactWeight.text = d.exactWeight;
      _confirmNoProhibited = d.confirmNoProhibited;
      _d1 = d.d1;
      _d2 = d.d2;
      _d3 = d.d3;
      _d4 = d.d4;
    }
    widget.controllers.name.addListener(_onControllersChanged);
    widget.controllers.description.addListener(_onControllersChanged);
    widget.controllers.images.addListener(_onControllersChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _recomputeStepValid());
  }

  @override
  void dispose() {
    widget.controllers.name.removeListener(_onControllersChanged);
    widget.controllers.description.removeListener(_onControllersChanged);
    widget.controllers.images.removeListener(_onControllersChanged);
    _exactDimensions.dispose();
    _exactWeight.dispose();
    super.dispose();
  }

  void _recomputeStepValid() {
    final nameOk = widget.controllers.name.text.trim().isNotEmpty;
    final descOk = widget.controllers.description.text.trim().isNotEmpty;
    final imagesOk = widget.controllers.images.value.isNotEmpty;
    final checksOk = _confirmNoProhibited && _d1 && _d2 && _d3 && _d4;
    final v = nameOk && descOk && imagesOk && checksOk;
    if (widget.stepValid.value != v) {
      widget.stepValid.value = v;
    }
  }

  List<String> _imagePathsFromProviders(List<ImageProvider> list) {
    final out = <String>[];
    for (final p in list) {
      if (p is FileImage) {
        out.add(p.file.path);
      }
    }
    return out;
  }

  ParcelsItemDraft buildDraft() {
    return ParcelsItemDraft(
      name: widget.controllers.name.text,
      description: widget.controllers.description.text,
      imagePaths: _imagePathsFromProviders(widget.controllers.images.value),
      typeSelection: _typeSelection,
      sizeSelection: _sizeSelection,
      weightSelection: _weightSelection,
      insuranceSelection: _insuranceSelection,
      exactDimensions: _exactDimensions.text,
      exactWeight: _exactWeight.text,
      confirmNoProhibited: _confirmNoProhibited,
      d1: _d1,
      d2: _d2,
      d3: _d3,
      d4: _d4,
    );
  }

  TextStyle _sectionHeadingStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
      color: context.tripClipColors.textBase,
    );
  }

  TextStyle _linkStyle(BuildContext context) {
    final h = context.tripClipColors.heading;
    return Theme.of(context).textTheme.bodySmall!.copyWith(
      color: h,
      decoration: TextDecoration.underline,
      decorationColor: h,
    );
  }

  Widget _iconSectionTitle(
    BuildContext context, {
    required String svgAsset,
    required String title,
    Widget? trailing,
  }) {
    final iconColor = context.tripClipColors.textSubtle;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          svgAsset,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        const SizedBox(width: 4),
        Expanded(child: Text(title, style: _sectionHeadingStyle(context))),
        ?trailing,
      ],
    );
  }

  Widget _optionGrid({
    required List<String> labels,
    required int cols,
    required int selectedIndex,
    required ValueChanged<int> onChanged,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = (constraints.maxWidth - (cols - 1) * _chipSpacing) / cols;
        return Wrap(
          spacing: _chipSpacing,
          runSpacing: _chipSpacing,
          children: List.generate(labels.length, (i) {
            return SizedBox(
              width: w,
              child: TripClipFormRadioButton(
                width: w,
                selected: selectedIndex == i,
                onPressed: () => onChanged(i),
                label: labels[i],
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              ),
            );
          }),
        );
      },
    );
  }

  Color get _cardBg => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF1F242B)
      : const Color(0xFFEFF2F5);

  Future<void> _defaultAddImage() async {
    if (!mounted) return;
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null || !mounted) return;
    final next = List<ImageProvider>.of(widget.controllers.images.value)
      ..add(FileImage(File(file.path)));
    widget.controllers.images.value = next;
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final helperStyle = t.bodySmall!.copyWith(
      color: context.tripClipColors.textSubtle,
    );
    final bodyStyle = t.bodyMedium!.copyWith(
      color: context.tripClipColors.textBase,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TripClipFormInput(
          label: 'Item Name',
          controller: widget.controllers.name,
          hintText: 'Eg. Christmas Presents',
        ),
        const SizedBox(height: 64),
        _iconSectionTitle(
          context,
          svgAsset: 'assets/icons/image.svg',
          title: 'Images',
          trailing: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('Photo Guide', style: _linkStyle(context)),
          ),
        ),
        const SizedBox(height: 16),
        Text('Add up to 8 images of your item.', style: bodyStyle),
        const SizedBox(height: 16),
        ValueListenableBuilder<List<ImageProvider>>(
          valueListenable: widget.controllers.images,
          builder: (context, images, _) {
            return _ImagesGrid(
              images: images,
              onAdd: widget.onAddImage ?? _defaultAddImage,
              onRemove: (i) async {
                if (widget.onRemoveImage != null) {
                  await widget.onRemoveImage!(i);
                }
                final next = List<ImageProvider>.of(images)..removeAt(i);
                widget.controllers.images.value = next;
              },
            );
          },
        ),
        const SizedBox(height: 64),
        _iconSectionTitle(
          context,
          svgAsset: 'assets/icons/list2.svg',
          title: 'Description',
          trailing: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('Description Guide', style: _linkStyle(context)),
          ),
        ),
        const SizedBox(height: 16),
        TripClipFormTextarea(
          controller: widget.controllers.description,
          hintText: 'Add a description of this item...',
          fieldHeight: 112,
          minLines: 1,
          maxLength: 600,
        ),
        const SizedBox(height: 4),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: widget.controllers.description,
          builder: (context, value, _) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text('${value.text.length}/600', style: helperStyle),
            );
          },
        ),
        const SizedBox(height: 64),
        _iconSectionTitle(
          context,
          svgAsset: 'assets/icons/package.svg',
          title: 'Type',
          trailing: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('Type Guide', style: _linkStyle(context)),
          ),
        ),
        const SizedBox(height: 16),
        _optionGrid(
          labels: _kTypeOptions,
          cols: 3,
          selectedIndex: _typeSelection,
          onChanged: (i) => setState(() => _typeSelection = i),
        ),
        const SizedBox(height: 64),
        _iconSectionTitle(
          context,
          svgAsset: 'assets/icons/package-dimensions.svg',
          title: 'Size',
          trailing: TextButton(
            onPressed: () {
              showTripClipParcelSizeGuideSheet(context);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('Size Guide', style: _linkStyle(context)),
          ),
        ),
        const SizedBox(height: 16),
        _optionGrid(
          labels: _kSizeOptions,
          cols: 5,
          selectedIndex: _sizeSelection,
          onChanged: (i) => setState(() => _sizeSelection = i),
        ),
        const SizedBox(height: 16),
        Text(
          'Exact Dimensions',
          style: t.bodySmall!.copyWith(
            fontWeight: FontWeight.w500,
            color: context.tripClipColors.textBase,
          ),
        ),
        const SizedBox(height: 8),
        TripClipFormInput(
          controller: _exactDimensions,
          hintText: 'Eg. 10cm W x 25cm H x 5cm D',
        ),
        const SizedBox(height: 64),
        _iconSectionTitle(
          context,
          svgAsset: 'assets/icons/weight.svg',
          title: 'Weight',
          trailing: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('Weight Guide', style: _linkStyle(context)),
          ),
        ),
        const SizedBox(height: 16),
        _optionGrid(
          labels: _kWeightOptions,
          cols: 4,
          selectedIndex: _weightSelection,
          onChanged: (i) => setState(() => _weightSelection = i),
        ),
        const SizedBox(height: 16),
        Text(
          'Exact Weight',
          style: t.bodySmall!.copyWith(
            fontWeight: FontWeight.w500,
            color: context.tripClipColors.textBase,
          ),
        ),
        const SizedBox(height: 8),
        TripClipFormInput(
          controller: _exactWeight,
          hintText: 'Eg. 2.5kgs',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 64),
        _iconSectionTitle(
          context,
          svgAsset: 'assets/icons/secure-shield.svg',
          title: 'Insurance',
          trailing: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('Insurance Guide', style: _linkStyle(context)),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            for (var i = 0; i < _kInsuranceOptions.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: TripClipFormRadioButton(
                  width: double.infinity,
                  selected: _insuranceSelection == i,
                  onPressed: () => setState(() => _insuranceSelection = i),
                  label: _kInsuranceOptions[i],
                  radius: 4,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  textStyle: t.bodySmall,
                  contentAlignment: MainAxisAlignment.center,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Basic insurance covers up to AUD \$500 for lost or\ndamaged items.',
          style: bodyStyle,
        ),
        const SizedBox(height: 64),
        _SectionCard(
          background: _cardBg,
          isLight: !isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/document-validation.svg',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                      context.tripClipColors.textSubtle,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Declaration',
                      style: _sectionHeadingStyle(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('Prohibited Items', style: _linkStyle(context)),
                ],
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  style: bodyStyle,
                  children: const [
                    TextSpan(
                      text: 'By listing this item, you confirm that it ',
                    ),
                    TextSpan(
                      text: 'does not contain ',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: 'any dangerous'),
                    TextSpan(
                      text: ' prohibited or restricted goods, including:\n\n',
                    ),
                    TextSpan(
                      text: '• weapons, explosives or flammable items\n',
                    ),
                    TextSpan(
                      text:
                          '• batteries not installed in a device, aerosols or pressurised containers\n',
                    ),
                    TextSpan(text: '• liquids, chemicals or fuels\n'),
                    TextSpan(
                      text:
                          '• organic material such as fruit, plants, soil or seeds (restricted under biosecurity laws)\n\n',
                    ),
                    TextSpan(text: 'You acknowledge that '),
                    TextSpan(
                      text: 'you are legally responsible ',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text:
                          'for the contents of this item.\n\nTravellers may inspect the item at pickup\nand may refuse to carry it if the contents\ndiffer from this listing.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TripClipFormCheckbox(
                value: _confirmNoProhibited,
                onChanged: (v) => setState(() {
                  _confirmNoProhibited = v;
                  _recomputeStepValid();
                }),
                label:
                    'I confirm this item does not contain prohibited or restricted goods',
              ),
            ],
          ),
        ),
        const SizedBox(height: 64),
        _SectionCard(
          background: _cardBg,
          isLight: !isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/document-validation.svg',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                      context.tripClipColors.textSubtle,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Declaration',
                      style: _sectionHeadingStyle(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  style: bodyStyle,
                  children: [
                    const TextSpan(
                      text:
                          'To protect our community and comply with Australian Law, you must verify your parcel\'s contents. Incorrect declarations can lead to ',
                    ),
                    TextSpan(
                      text: '7 years imprisonment',
                      style: bodyStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: ' or fines exceeding '),
                    TextSpan(
                      text: '\$480,000.',
                      style: bodyStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TripClipFormCheckbox(
                value: _d1,
                onChanged: (v) => setState(() {
                  _d1 = v;
                  _recomputeStepValid();
                }),
                label:
                    'I confirm this parcel contains NO\ndangerous goods (e.g., aerosols,\nbatteries, bleaches, or camping fuel).',
              ),
              const SizedBox(height: 8),
              TripClipFormCheckbox(
                value: _d2,
                onChanged: (v) => setState(() {
                  _d2 = v;
                  _recomputeStepValid();
                }),
                label:
                    'I confirm this parcel contains NO\nweapons or prohibited aviation items.',
              ),
              const SizedBox(height: 8),
              TripClipFormCheckbox(
                value: _d3,
                onChanged: (v) => setState(() {
                  _d3 = v;
                  _recomputeStepValid();
                }),
                label:
                    'I confirm this parcel contains NO\nbiosecurity risks (e.g., fruit, plants,\nsoil, or seeds).',
              ),
              const SizedBox(height: 8),
              TripClipFormCheckbox(
                value: _d4,
                onChanged: (v) => setState(() {
                  _d4 = v;
                  _recomputeStepValid();
                }),
                label:
                    'I acknowledge that ',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.background,
    required this.isLight,
    required this.child,
  });

  final Color background;
  final bool isLight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: TripClipCardShadows.whenLight(isLight),
      ),
      child: child,
    );
  }
}

class _ImagesGrid extends StatelessWidget {
  const _ImagesGrid({
    required this.images,
    required this.onAdd,
    required this.onRemove,
  });

  final List<ImageProvider> images;
  final Future<void> Function() onAdd;
  final Future<void> Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final addBg = isDark ? const Color(0xFF1F242B) : const Color(0xFFEFF2F5);
    final addBorder = isDark
        ? const Color(0xFF2E343D)
        : const Color(0xFFDCE1E6);
    final labelStyle = Theme.of(
      context,
    ).textTheme.bodyMedium!.copyWith(color: context.tripClipColors.textBase);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        const gap = 8.0;
        final tileW = (w - gap) / 2;
        final tileH = 132.0;
        const radius = 8.0;
        const padding = 8.0;

        Widget addTile = Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              await onAdd();
            },
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              width: tileW,
              height: tileH,
              decoration: BoxDecoration(
                color: addBg,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(color: addBorder, width: 1),
              ),
              padding: const EdgeInsets.all(padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/image.svg',
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                      context.tripClipColors.textSubtle,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Add Image', style: labelStyle),
                ],
              ),
            ),
          ),
        );

        final tiles = <Widget>[addTile];
        for (var i = 0; i < images.length; i++) {
          tiles.add(
            _ImageTile(
              width: tileW,
              height: tileH,
              radius: radius,
              image: images[i],
              onRemove: () => onRemove(i),
            ),
          );
        }

        return Wrap(spacing: gap, runSpacing: gap, children: tiles);
      },
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.width,
    required this.height,
    required this.radius,
    required this.image,
    required this.onRemove,
  });

  final double width;
  final double height;
  final double radius;
  final ImageProvider image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    const closeBg = Color(0xFF3F4B78);
    final closeFg = Colors.white;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Image(
              image: image,
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onRemove,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: closeBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(Icons.close, size: 16, color: closeFg),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
