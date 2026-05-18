import 'package:flutter/material.dart';

import '../../app/theme/trip_clip_colors.dart';
import '../components/trip_clip_title_bar.dart';

class TripClipTermsStyleSheet extends StatelessWidget {
  const TripClipTermsStyleSheet({
    super.key,
    required this.title,
    this.onBack,
    this.onClose,
    this.header,
    required this.body,
    this.expandBody = true,
  });

  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final Widget? header;
  final Widget body;

  final bool expandBody;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBg = context.tripClipColors.pageBackground;
    final border = context.tripClipColors.borderSubtle;
    final dragHandleColor = isDark ? Colors.white : const Color(0xFF1F242B);
    final closeIconColor = context.tripClipColors.textBase;

    void dismiss() => Navigator.of(context).maybePop();

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Material(
        color: pageBg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: expandBody ? MainAxisSize.max : MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: dragHandleColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TripClipTitleBar(
              includeStatusBarInset: false,
              title: title,
              onBack: onBack ?? dismiss,
              trailing: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    icon: Icon(Icons.close, color: closeIconColor, size: 24),
                    onPressed: onClose ?? dismiss,
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).closeButtonTooltip,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Divider(height: 1, thickness: 1, color: border),
            if (header != null) ...[header!],
            if (expandBody) Expanded(child: body) else body,
          ],
        ),
      ),
    );
  }
}
