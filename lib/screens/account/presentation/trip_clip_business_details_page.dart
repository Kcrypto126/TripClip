import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../../ui/components/pages/trip_clip_content_page_scaffold.dart';
import 'trip_clip_account_detail_list.dart';

enum _BusinessDetailField { businessName, abn, acn }

class TripClipBusinessDetailsPage extends StatefulWidget {
  const TripClipBusinessDetailsPage({super.key});

  @override
  State<TripClipBusinessDetailsPage> createState() =>
      _TripClipBusinessDetailsPageState();
}

class _TripClipBusinessDetailsPageState
    extends State<TripClipBusinessDetailsPage> {
  _BusinessDetailField? _expanded;

  String _businessName = 'Something Pty Ltd';
  String _abn = '12 345 678 901';
  String _acn = '123 456 789';

  late final TextEditingController _businessNameCtrl;
  late final TextEditingController _abnCtrl;
  late final TextEditingController _acnCtrl;

  @override
  void initState() {
    super.initState();
    _businessNameCtrl = TextEditingController(text: _businessName);
    _abnCtrl = TextEditingController(text: _abn);
    _acnCtrl = TextEditingController(text: _acn);
  }

  @override
  void dispose() {
    _businessNameCtrl.dispose();
    _abnCtrl.dispose();
    _acnCtrl.dispose();
    super.dispose();
  }

  void _openEdit(_BusinessDetailField field) {
    setState(() {
      _expanded = field;
      switch (field) {
        case _BusinessDetailField.businessName:
          _businessNameCtrl.text = _businessName;
        case _BusinessDetailField.abn:
          _abnCtrl.text = _abn;
        case _BusinessDetailField.acn:
          _acnCtrl.text = _acn;
      }
    });
  }

  void _cancelEdit() {
    setState(() => _expanded = null);
  }

  void _saveEdit(_BusinessDetailField field) {
    setState(() {
      switch (field) {
        case _BusinessDetailField.businessName:
          _businessName = _businessNameCtrl.text.trim();
        case _BusinessDetailField.abn:
          _abn = _abnCtrl.text.trim();
        case _BusinessDetailField.acn:
          _acn = _acnCtrl.text.trim();
      }
      _expanded = null;
    });
  }

  void _onEditPressed(_BusinessDetailField field) {
    if (_expanded == field) {
      setState(() => _expanded = null);
    } else {
      _openEdit(field);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final t = Theme.of(context).textTheme;
    final introColor = context.tripClipColors.textBase;
    final introStyle = t.bodyMedium!.copyWith(color: introColor);

    final rowBorder = context.tripClipColors.borderSubtle;
    final labelColor = context.tripClipColors.textBase;
    final labelStyle = t.titleLarge!.copyWith(color: labelColor);
    final contentColor = context.tripClipColors.textBase;
    final contentStyle = t.bodyMedium!.copyWith(color: contentColor);

    final pencilColor = context.tripClipColors.textSubtle;
    final pencilFilter = ColorFilter.mode(pencilColor, BlendMode.srcIn);

    final formBg = isDark
        ? TripClipPalette.neutral900
        : TripClipPalette.neutral100;

    return TripClipContentPageScaffold(
      appBarTitle: 'Business Details',
      heading: 'Business Details',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Only your Display name will be visible to others.',
            style: introStyle,
          ),
          const SizedBox(height: 40),
          TripClipAccountDetailItem(
            label: 'Business Name',
            value: _businessName,
            showVerifiedBadge: false,
            rowBorder: rowBorder,
            labelStyle: labelStyle,
            contentStyle: contentStyle,
            pencilFilter: pencilFilter,
            formBg: formBg,
            onEdit: () => _onEditPressed(_BusinessDetailField.businessName),
            editForm: _expanded == _BusinessDetailField.businessName
                ? TripClipAccountSingleFieldEditForm(
                    controller: _businessNameCtrl,
                    fieldLabel: 'Business Name',
                    onCancel: _cancelEdit,
                    onSave: () => _saveEdit(_BusinessDetailField.businessName),
                  )
                : null,
          ),
          TripClipAccountDetailItem(
            label: 'ABN',
            value: _abn,
            showVerifiedBadge: false,
            rowBorder: rowBorder,
            labelStyle: labelStyle,
            contentStyle: contentStyle,
            pencilFilter: pencilFilter,
            formBg: formBg,
            onEdit: () => _onEditPressed(_BusinessDetailField.abn),
            editForm: _expanded == _BusinessDetailField.abn
                ? TripClipAccountSingleFieldEditForm(
                    controller: _abnCtrl,
                    fieldLabel: 'ABN',
                    keyboardType: TextInputType.text,
                    onCancel: _cancelEdit,
                    onSave: () => _saveEdit(_BusinessDetailField.abn),
                  )
                : null,
          ),
          TripClipAccountDetailItem(
            label: 'ACN',
            value: _acn,
            showVerifiedBadge: false,
            rowBorder: rowBorder,
            labelStyle: labelStyle,
            contentStyle: contentStyle,
            pencilFilter: pencilFilter,
            formBg: formBg,
            onEdit: () => _onEditPressed(_BusinessDetailField.acn),
            editForm: _expanded == _BusinessDetailField.acn
                ? TripClipAccountSingleFieldEditForm(
                    controller: _acnCtrl,
                    fieldLabel: 'ACN',
                    keyboardType: TextInputType.text,
                    onCancel: _cancelEdit,
                    onSave: () => _saveEdit(_BusinessDetailField.acn),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
