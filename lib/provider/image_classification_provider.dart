import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:food_recognition_app/service/image_classification_service.dart';

class ImageClassificationViewmodel extends ChangeNotifier {
  final ImageClassificationService _service;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  ImageClassificationViewmodel(this._service) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _service.initHelper();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _isInitialized = false;
      notifyListeners();
      rethrow;
    }
  }

  Map<String, num> _classifications = {};

  Map<String, num> get classifications => Map.fromEntries(
    (_classifications.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value)))
        .reversed
        .take(3),
  );

  Future<void> runClassification(CameraImage camera) async {
    print('Running classification on camera image...');
    _classifications = await _service.inferenceCameraFrame(camera);
    print('Classification result: $_classifications');
    notifyListeners();
  }

  Future<void> runClassificationFromPath(String imagePath) async {
    if (!_isInitialized) {
      await _initialize();
    }
    _classifications = await _service.inferenceImageFile(File(imagePath));
    notifyListeners();
  }

  Future<void> close() async {
    await _service.close();
  }
}
