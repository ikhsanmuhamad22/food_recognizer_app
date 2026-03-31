import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:submission/service/food_classification_service.dart';

// todo-04-viewmodel-01: create a viewmodel notifier
class FoodClassificationProvider extends ChangeNotifier {
  // todo-04-viewmodel-02: create a constructor
  final FoodClassificationService _service;

  FoodClassificationProvider(this._service) {
    _service.initHelper();
  }

  // todo-04-viewmodel-03: create a state and getter to get a top three on classification item
  Map<String, num> _classifications = {};

  Map<String, num> get classifications => Map.fromEntries(
    (_classifications.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value)))
        .reversed
        .take(3),
  );

  // todo-04-viewmodel-04: run the inference process
  Future<void> runClassification(CameraImage camera) async {
    _classifications = await _service.inferenceCameraFrame(camera);
    notifyListeners();
  }

  // todo-04-viewmodel-05: close everything
  Future<void> close() async {
    await _service.close();
  }
}
