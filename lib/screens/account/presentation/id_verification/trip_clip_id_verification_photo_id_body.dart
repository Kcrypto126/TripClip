import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../app/theme/trip_clip_colors.dart';
import '../../../../ui/components/app_toast.dart';
import '../../../../ui/components/pages/trip_clip_stepped_page_scaffold.dart';

const Color _kMainCameraBorderLight = Color(0xFF8E97A3);
const Color _kMainCameraBorderDark = Color(0xFF5B636F);

enum TripClipIdVerificationPhotoSide { front, back }

class TripClipIdVerificationPhotoIdBody extends StatefulWidget {
  const TripClipIdVerificationPhotoIdBody({super.key, required this.side});

  final TripClipIdVerificationPhotoSide side;

  @override
  TripClipIdVerificationPhotoIdBodyState createState() =>
      TripClipIdVerificationPhotoIdBodyState();
}

class TripClipIdVerificationPhotoIdBodyState
    extends State<TripClipIdVerificationPhotoIdBody> {
  static const double _cameraHeight = 261;
  static const double _guideFrameHeight = 229;
  static const double _guideWidthScreenInset = 64;
  static const double _cameraRadius = 8;
  static const double _mainBorder = 2;

  static const Duration _initTimeout = Duration(seconds: 20);

  CameraController? _controller;
  bool _initializing = true;
  bool _denied = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _bootstrap();
    });
  }

  @override
  void didUpdateWidget(TripClipIdVerificationPhotoIdBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.side != widget.side) {
      _controller?.dispose();
      _controller = null;
      _initializing = true;
      _error = null;
      _denied = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _bootstrap();
      });
    }
  }

  Future<void> _bootstrap() async {
    if (kIsWeb) {
      if (mounted) {
        setState(() {
          _initializing = false;
          _error = 'Camera preview is not available in the web build.';
        });
      }
      return;
    }

    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        setState(() {
          _initializing = false;
          _denied = true;
        });
      }
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          setState(() {
            _initializing = false;
            _error = 'No camera found on this device.';
          });
        }
        return;
      }

      final ordered = <CameraDescription>[
        ...cameras.where((c) => c.lensDirection == CameraLensDirection.back),
        ...cameras.where((c) => c.lensDirection != CameraLensDirection.back),
      ];

      Object? lastError;
      for (final cam in ordered) {
        CameraController? trial;
        try {
          trial = CameraController(
            cam,
            ResolutionPreset.medium,
            enableAudio: false,
          );
          await trial.initialize().timeout(
            _initTimeout,
            onTimeout: () {
              throw TimeoutException('Camera.initialize() timed out.');
            },
          );
          if (!mounted) {
            await trial.dispose();
            return;
          }
          setState(() {
            _controller = trial;
            _initializing = false;
            _error = null;
          });
          return;
        } catch (e, st) {
          lastError = e;
          assert(() {
            debugPrint('Camera trial failed (${cam.name}): $e\n$st');
            return true;
          }());
          await trial?.dispose();
        }
      }

      if (!mounted) return;
      setState(() {
        _initializing = false;
        _error =
            'Could not start the camera. '
            'On an emulator, enable a virtual webcam or test on a real device. '
            '${lastError != null ? "($lastError)" : ""}';
      });
    } catch (e, st) {
      assert(() {
        debugPrint('Camera init failed: $e\n$st');
        return true;
      }());
      if (mounted) {
        setState(() {
          _initializing = false;
          _error = 'Could not start the camera.';
        });
      }
    }
  }

  Future<String?> capturePhoto() async {
    final c = _controller;
    if (c == null || !c.value.isInitialized) {
      if (mounted) {
        AppToast.show(
          context,
          message: 'Camera is not ready yet.',
          kind: AppToastKind.warning,
        );
      }
      return null;
    }

    try {
      final file = await c.takePicture();
      final bytes = await file.readAsBytes();
      if (!mounted) return null;
      AppToast.show(
        context,
        message:
            'Photo captured (${(bytes.length / 1024).toStringAsFixed(0)} KB). '
            'Upload will be added when the API is ready.',
        kind: AppToastKind.success,
      );
      return file.path;
    } catch (e, st) {
      assert(() {
        debugPrint('takePicture failed: $e\n$st');
        return true;
      }());
      if (mounted) {
        AppToast.show(
          context,
          message: 'Could not take a photo. Please try again.',
          kind: AppToastKind.error,
        );
      }
      return null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  TextStyle _bodyStyle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(color: context.tripClipColors.textBase);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mainCameraBorder = isDark
        ? _kMainCameraBorderDark
        : _kMainCameraBorderLight;
    final mainCameraBg = isDark
        ? const Color(0xFF1F242B)
        : const Color(0xFFEFF2F5);
    final tipsBg = mainCameraBg;
    final body = _bodyStyle(context);

    Widget cameraSlot;
    if (_denied) {
      cameraSlot = Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Camera access is required to photograph your ID. '
            'Please allow camera permission in Settings.',
            textAlign: TextAlign.center,
            style: body,
          ),
        ),
      );
    } else if (_error != null) {
      cameraSlot = Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(_error!, textAlign: TextAlign.center, style: body),
        ),
      );
    } else if (_initializing ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      cameraSlot = const Center(
        child: SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      );
    } else {
      final c = _controller!;
      final previewSize = c.value.previewSize;
      if (previewSize != null) {
        cameraSlot = FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: previewSize.height,
            height: previewSize.width,
            child: CameraPreview(c),
          ),
        );
      } else {
        cameraSlot = CameraPreview(c);
      }
    }

    final showIdGuideOverlay =
        !_denied &&
        _error == null &&
        _controller != null &&
        _controller!.value.isInitialized;

    final screenW = MediaQuery.sizeOf(context).width;
    final guideFrameWidth = (screenW - _guideWidthScreenInset).clamp(
      0.0,
      screenW,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Position your ID within the frame. Make sure all text is clearly visible.',
          style: body,
        ),
        const SizedBox(height: 24),
        ClipRRect(
          borderRadius: BorderRadius.circular(_cameraRadius),
          child: SizedBox(
            height: _cameraHeight,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned.fill(
                  child: ColoredBox(
                    color: isDark
                        ? const Color(0xFF12161C)
                        : const Color(0xFFDCE1E6),
                    child: cameraSlot,
                  ),
                ),
                if (showIdGuideOverlay)
                  IgnorePointer(
                    child: _IdDocumentGuideOverlay(
                      width: guideFrameWidth,
                      height: _guideFrameHeight,
                      borderColor: mainCameraBorder,
                      borderWidth: _mainBorder,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        TripClipSteppedCardSection(
          backgroundColor: tipsBg,
          title: 'Tips for best results:',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TripClipSteppedBulletLine(text: 'Ensure good lighting'),
              const TripClipSteppedBulletLine(
                text: 'Avoid glare or reflections',
              ),
              const TripClipSteppedBulletLine(text: 'Keep the image in focus'),
            ],
          ),
        ),
      ],
    );
  }
}

class _IdDocumentGuideOverlay extends StatelessWidget {
  const _IdDocumentGuideOverlay({
    required this.width,
    required this.height,
    required this.borderColor,
    required this.borderWidth,
  });

  final double width;
  final double height;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: width,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}
