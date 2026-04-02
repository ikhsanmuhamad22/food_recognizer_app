import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  final Function(CameraImage cameraImage)? onImage;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final Function(Future<XFile?> Function())? onTakePicture;

  const CameraView({
    super.key,
    this.onImage,
    this.onCameraLensDirectionChanged,
    this.onTakePicture,
  });

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  bool _isCameraInitialized = false;

  List<CameraDescription> _cameras = [];

  CameraController? controller;

  bool _isProcessing = false;

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    final cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup:
          Platform.isAndroid
              ? ImageFormatGroup.yuv420
              : ImageFormatGroup.bgra8888,
    );
    await previousCameraController?.dispose();

    cameraController
        .initialize()
        .then((value) {
          if (mounted) {
            setState(() {
              controller = cameraController;
              if (widget.onImage != null) {
                controller!.startImageStream(_processCameraImage);
              }
              if (widget.onCameraLensDirectionChanged != null) {
                widget.onCameraLensDirectionChanged!(
                  cameraDescription.lensDirection,
                );
              }
              _isCameraInitialized = controller!.value.isInitialized;
            });
          }
        })
        .catchError((e) {
          print('Error initializing camera: $e');
        });
  }

  void initCamera() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    await onNewCameraSelected(_cameras.first);
  }

  void _processCameraImage(CameraImage image) async {
    if (_isProcessing) {
      return;
    }

    _isProcessing = true;
    if (widget.onImage != null) {
      await widget.onImage!(image);
    }
    _isProcessing = false;
  }

  Future<XFile?> takePicture() async {
    if (controller != null && controller!.value.isInitialized) {
      try {
        final XFile file = await controller!.takePicture();
        return file;
      } catch (e) {
        print('Error taking picture: $e');
        return null;
      }
    }
    return null;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    initCamera();

    // Notify parent about takePicture function
    if (widget.onTakePicture != null) {
      widget.onTakePicture!(takePicture);
    }

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    controller!
      ..stopImageStream()
      ..dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController != null || !cameraController!.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.inactive:
        cameraController.dispose();
        break;
      case AppLifecycleState.resumed:
        onNewCameraSelected(cameraController.description);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isCameraInitialized
        ? CameraPreview(controller!)
        : const Center(child: CircularProgressIndicator());
  }
}
