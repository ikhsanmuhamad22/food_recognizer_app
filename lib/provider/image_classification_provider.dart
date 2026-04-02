import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:submission/service/image_classification_service.dart';

// todo-04-viewmodel-01: create a viewmodel notifier
class ImageClassificationViewmodel extends ChangeNotifier {
  // todo-04-viewmodel-02: create a constructor
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

  // todo-04-viewmodel-04: run the inference process
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

  // todo-04-viewmodel-05: close everything
  Future<void> close() async {
    await _service.close();
  }
}
