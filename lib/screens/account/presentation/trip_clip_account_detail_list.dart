import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../ui/components/buttons/trip_clip_button.dart';
import '../../../ui/components/buttons/trip_clip_button_models.dart';
import '../../../ui/components/forms/trip_clip_form_input.dart';

class TripClipAccountDetailItem extends StatelessWidget {
  const TripClipAccountDetailItem({
    super.key,
    required this.label,
    required this.value,
    required this.showVerifiedBadge,
    required this.rowBorder,
    required this.labelStyle,
    required this.contentStyle,
    required this.pencilFilter,
    required this.formBg,
    required this.onEdit,
    required this.editForm,
  });

  final String label;
  final String value;
  final bool showVerifiedBadge;
  final Color rowBorder;
  final TextStyle labelStyle;
  final TextStyle contentStyle;
  final ColorFilter pencilFilter;
  final Color formBg;
  final VoidCallback onEdit;
  final Widget? editForm;

  @override
  Widget build(BuildContext context) {
    final hasForm = editForm != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, hasForm ? 0 : 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: labelStyle),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (showVerifiedBadge) ...[
                          SvgPicture.asset(
                            'assets/icons/check-circle.svg',
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(child: Text(value, style: contentStyle)),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onEdit,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                icon: SvgPicture.asset(
                  'assets/icons/pencil-edit.svg',
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  colorFilter: pencilFilter,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          clipBehavior: Clip.hardEdge,
          child: hasForm
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: formBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: editForm!,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        Divider(height: 1, thickness: 1, color: rowBorder),
      ],
    );
  }
}

class TripClipAccountLegalNameEditForm extends StatelessWidget {
  const TripClipAccountLegalNameEditForm({
    super.key,
    required this.first,
    required this.middle,
    required this.last,
    required this.onCancel,
    required this.onSave,
  });

  final TextEditingController first;
  final TextEditingController middle;
  final TextEditingController last;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TripClipFormInput(
          label: 'First Name',
          controller: first,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 24),
        TripClipFormInput(
          label: 'Middle Name (optional)',
          controller: middle,
          hintText: 'Middle Names',
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 24),
        TripClipFormInput(
          label: 'Last Name',
          controller: last,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TripClipButton(
              variant: TripClipButtonVariant.tertiary,
              label: 'Cancel',
              onPressed: onCancel,
            ),
            TripClipButton(
              variant: TripClipButtonVariant.primary,
              label: 'Save',
              onPressed: onSave,
            ),
          ],
        ),
      ],
    );
  }
}

class TripClipAccountSingleFieldEditForm extends StatelessWidget {
  const TripClipAccountSingleFieldEditForm({
    super.key,
    required this.controller,
    required this.fieldLabel,
    required this.onCancel,
    required this.onSave,
    this.hintText,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String fieldLabel;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final String? hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TripClipFormInput(
          label: fieldLabel,
          controller: controller,
          hintText: hintText,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TripClipButton(
              variant: TripClipButtonVariant.tertiary,
              label: 'Cancel',
              onPressed: onCancel,
            ),
            TripClipButton(
              variant: TripClipButtonVariant.primary,
              label: 'Save',
              onPressed: onSave,
            ),
          ],
        ),
      ],
    );
  }
}
