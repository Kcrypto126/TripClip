import 'package:flutter/material.dart';

import '../../../app/theme/trip_clip_colors.dart';
import '../../../app/theme/trip_clip_palette.dart';
import '../../../ui/components/pages/trip_clip_content_page_scaffold.dart';
import 'trip_clip_account_detail_list.dart';

enum _PersonalDetailField {
  legalName,
  displayName,
  dateOfBirth,
  mobileNumber,
  email,
}

class TripClipPersonalDetailsPage extends StatefulWidget {
  const TripClipPersonalDetailsPage({super.key});

  @override
  State<TripClipPersonalDetailsPage> createState() =>
      _TripClipPersonalDetailsPageState();
}

class _TripClipPersonalDetailsPageState
    extends State<TripClipPersonalDetailsPage> {
  _PersonalDetailField? _expanded;

  String _legalName = 'John Smith';
  String _displayName = 'John';
  String _dateOfBirth = '08/08/1988';
  String _mobileNumber = '0401 271 882';
  String _email = 'john.smith@something.com.au';

  late final TextEditingController _legalFirst;
  late final TextEditingController _legalMiddle;
  late final TextEditingController _legalLast;
  late final TextEditingController _displayNameCtrl;
  late final TextEditingController _dobCtrl;
  late final TextEditingController _mobileCtrl;
  late final TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _legalFirst = TextEditingController();
    _legalMiddle = TextEditingController();
    _legalLast = TextEditingController();
    _displayNameCtrl = TextEditingController(text: _displayName);
    _dobCtrl = TextEditingController(text: _dateOfBirth);
    _mobileCtrl = TextEditingController(text: _mobileNumber);
    _emailCtrl = TextEditingController(text: _email);
  }

  @override
  void dispose() {
    _legalFirst.dispose();
    _legalMiddle.dispose();
    _legalLast.dispose();
    _displayNameCtrl.dispose();
    _dobCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _syncLegalControllersFromDisplay() {
    final parts = _legalName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) {
      _legalFirst.clear();
      _legalMiddle.clear();
      _legalLast.clear();
      return;
    }
    if (parts.length == 1) {
      _legalFirst.text = parts[0];
      _legalMiddle.clear();
      _legalLast.clear();
      return;
    }
    _legalFirst.text = parts.first;
    _legalLast.text = parts.last;
    _legalMiddle.text = parts.length > 2
        ? parts.sublist(1, parts.length - 1).join(' ')
        : '';
  }

  void _openEdit(_PersonalDetailField field) {
    setState(() {
      _expanded = field;
      switch (field) {
        case _PersonalDetailField.legalName:
          _syncLegalControllersFromDisplay();
        case _PersonalDetailField.displayName:
          _displayNameCtrl.text = _displayName;
        case _PersonalDetailField.dateOfBirth:
          _dobCtrl.text = _dateOfBirth;
        case _PersonalDetailField.mobileNumber:
          _mobileCtrl.text = _mobileNumber;
        case _PersonalDetailField.email:
          _emailCtrl.text = _email;
      }
    });
  }

  void _cancelEdit() {
    setState(() => _expanded = null);
  }

  void _saveEdit(_PersonalDetailField field) {
    setState(() {
      switch (field) {
        case _PersonalDetailField.legalName:
          final first = _legalFirst.text.trim();
          final mid = _legalMiddle.text.trim();
          final last = _legalLast.text.trim();
          final buf = StringBuffer(first);
          if (mid.isNotEmpty) {
            buf.write(' ');
            buf.write(mid);
          }
          if (last.isNotEmpty) {
            buf.write(' ');
            buf.write(last);
          }
          final merged = buf.toString().trim();
          if (merged.isNotEmpty) _legalName = merged;
        case _PersonalDetailField.displayName:
          _displayName = _displayNameCtrl.text.trim();
        case _PersonalDetailField.dateOfBirth:
          _dateOfBirth = _dobCtrl.text.trim();
        case _PersonalDetailField.mobileNumber:
          _mobileNumber = _mobileCtrl.text.trim();
        case _PersonalDetailField.email:
          _email = _emailCtrl.text.trim();
      }
      _expanded = null;
    });
  }

  void _onEditPressed(_PersonalDetailField field) {
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
      appBarTitle: 'Personal Details',
      heading: 'Personal Details',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Only your Display name will be visible to others.',
            style: introStyle,
          ),
          const SizedBox(height: 40),
          TripClipAccountDetailItem(
            label: 'Legal Name',
            value: _legalName,
            showVerifiedBadge: false,
            rowBorder: rowBorder,
            labelStyle: labelStyle,
            contentStyle: contentStyle,
            pencilFilter: pencilFilter,
            formBg: formBg,
            onEdit: () => _onEditPressed(_PersonalDetailField.legalName),
            editForm: _expanded == _PersonalDetailField.legalName
                ? TripClipAccountLegalNameEditForm(
                    first: _legalFirst,
                    middle: _legalMiddle,
                    last: _legalLast,
                    onCancel: _cancelEdit,
                    onSave: () => _saveEdit(_PersonalDetailField.legalName),
                  )
                : null,
          ),
          TripClipAccountDetailItem(
            label: 'Display Name',
            value: _displayName,
            showVerifiedBadge: false,
            rowBorder: rowBorder,
            labelStyle: labelStyle,
            contentStyle: contentStyle,
            pencilFilter: pencilFilter,
            formBg: formBg,
            onEdit: () => _onEditPressed(_PersonalDetailField.displayName),
            editForm: _expanded == _PersonalDetailField.displayName
                ? TripClipAccountSingleFieldEditForm(
                    controller: _displayNameCtrl,
                    fieldLabel: 'Display Name',
                    onCancel: _cancelEdit,
                    onSave: () => _saveEdit(_PersonalDetailField.displayName),
                  )
                : null,
          ),
          TripClipAccountDetailItem(
            label: 'Date of Birth',
            value: _dateOfBirth,
            showVerifiedBadge: true,
            rowBorder: rowBorder,
            labelStyle: labelStyle,
            contentStyle: contentStyle,
            pencilFilter: pencilFilter,
            formBg: formBg,
            onEdit: () => _onEditPressed(_PersonalDetailField.dateOfBirth),
            editForm: _expanded == _PersonalDetailField.dateOfBirth
                ? TripClipAccountSingleFieldEditForm(
                    controller: _dobCtrl,
                    fieldLabel: 'Date of Birth',
                    hintText: 'DD/MM/YYYY',
                    onCancel: _cancelEdit,
                    onSave: () => _saveEdit(_PersonalDetailField.dateOfBirth),
                  )
                : null,
          ),
          TripClipAccountDetailItem(
            label: 'Mobile Number',
            value: _mobileNumber,
            showVerifiedBadge: true,
            rowBorder: rowBorder,
            labelStyle: labelStyle,
            contentStyle: contentStyle,
            pencilFilter: pencilFilter,
            formBg: formBg,
            onEdit: () => _onEditPressed(_PersonalDetailField.mobileNumber),
            editForm: _expanded == _PersonalDetailField.mobileNumber
                ? TripClipAccountSingleFieldEditForm(
                    controller: _mobileCtrl,
                    fieldLabel: 'Mobile Number',
                    keyboardType: TextInputType.phone,
                    onCancel: _cancelEdit,
                    onSave: () => _saveEdit(_PersonalDetailField.mobileNumber),
                  )
                : null,
          ),
          TripClipAccountDetailItem(
            label: 'Email',
            value: _email,
            showVerifiedBadge: true,
            rowBorder: rowBorder,
            labelStyle: labelStyle,
            contentStyle: contentStyle,
            pencilFilter: pencilFilter,
            formBg: formBg,
            onEdit: () => _onEditPressed(_PersonalDetailField.email),
            editForm: _expanded == _PersonalDetailField.email
                ? TripClipAccountSingleFieldEditForm(
                    controller: _emailCtrl,
                    fieldLabel: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    onCancel: _cancelEdit,
                    onSave: () => _saveEdit(_PersonalDetailField.email),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
