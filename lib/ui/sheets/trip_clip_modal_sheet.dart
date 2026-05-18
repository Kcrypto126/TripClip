import 'package:flutter/material.dart';

abstract final class TripClipModalSheet {
  TripClipModalSheet._();

  static const double heightFraction = 0.92;

  static const Color barrierColor = Color(0x8A000000);

  static Future<T?> show<T>(
    BuildContext context, {
    double heightFraction = TripClipModalSheet.heightFraction,
    bool wrapToContent = false,
    bool useRootNavigator = true,
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      builder: (sheetContext) {
        final size = MediaQuery.sizeOf(sheetContext);
        final cap = size.height * heightFraction;
        if (wrapToContent) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: size.width,
                maxHeight: cap,
              ),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: size.width,
                  child: builder(sheetContext),
                ),
              ),
            ),
          );
        }
        return Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(height: cap, child: builder(sheetContext)),
        );
      },
    );
  }
}
