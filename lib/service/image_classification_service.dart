import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:submission/service/isolate_interface.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ImageClassificationService {
  // todo-02-service-02: setup the static variable
  final modelPath = 'assets/ml_model/aiy.tflite';
  final labelsPath = 'assets/ml_model/probability-labels-en.txt';

  // todo-02-service-03: setup the variable
  Interpreter? interpreter;
  List<String>? labels;
  Tensor? inputTensor;
  Tensor? outputTensor;
  IsolateInference? isolateInference;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // todo-02-service-04: load model
  Future<void> _loadModel() async {
    if (interpreter != null) return; // Already loaded
    final options =
        InterpreterOptions()
          ..useNnApiForAndroid = true
          ..useMetalDelegateForIOS = true;

    // Load model from assets
    interpreter = await Interpreter.fromAsset(modelPath, options: options);
    // Get tensor input shape [1, 224, 224, 3]
    inputTensor = interpreter!.getInputTensors().first;
    // Get tensor output shape [1, 1001]
    outputTensor = interpreter!.getOutputTensors().first;

    log('Interpreter loaded successfully');
  }

  // todo-02-service-05: load labels from assets
  Future<void> _loadLabels() async {
    if (labels != null) return; // Already loaded
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  // todo-02-service-06: run init function
  Future<void> initHelper() async {
    if (_isInitialized) return;
    try {
      await _loadLabels();
      await _loadModel();
      // todo-03-isolate-10: define a Isolate inference
      isolateInference = IsolateInference();
      await isolateInference!.start();
      _isInitialized = true;
      log('ImageClassificationService initialized successfully');
    } catch (e) {
      _isInitialized = false;
      log('Failed to initialize ImageClassificationService: $e');
      rethrow;
    }
  }

  // todo-03-isolate-11: inference camera frame
  Future<Map<String, double>> inferenceCameraFrame(
    CameraImage cameraImage,
  ) async {
    try {
      if (!_isInitialized) {
        throw Exception(
          'ImageClassificationService not initialized. Call initHelper() first.',
        );
      }
      assert(labels != null, 'Labels must be loaded');
      assert(interpreter != null, 'Interpreter must be loaded');
      assert(inputTensor != null, 'Input tensor must be loaded');
      assert(outputTensor != null, 'Output tensor must be loaded');
      assert(isolateInference != null, 'Isolate inference must be loaded');

      var isolateModel = InferenceModel(
        cameraImage,
        interpreter!.address,
        labels!,
        inputTensor!.shape,
        outputTensor!.shape,
      );

      ReceivePort responsePort = ReceivePort();
      isolateModel.responsePort = responsePort.sendPort;
      isolateInference!.sendPort.send(isolateModel);

      // get inference result.
      var results = await responsePort.first;
      return results as Map<String, double>;
    } catch (e) {
      log('Error in inferenceCameraFrame: $e');
      rethrow;
    }
  }

  Future<Map<String, double>> inferenceImageFile(File imageFile) async {
    try {
      if (!_isInitialized) {
        throw Exception(
          'ImageClassificationService not initialized. Call initHelper() first.',
        );
      }
      assert(labels != null, 'Labels must be loaded');
      assert(interpreter != null, 'Interpreter must be loaded');
      assert(inputTensor != null, 'Input tensor must be loaded');
      assert(outputTensor != null, 'Output tensor must be loaded');
      assert(isolateInference != null, 'Isolate inference must be loaded');
      final bytes = await imageFile.readAsBytes();

      var isolateModel = InferenceModel(
        null, // no cameraImage, just bytes
        interpreter!.address,
        labels!,
        inputTensor!.shape,
        outputTensor!.shape,
      );
      isolateModel.imageBytes = bytes;

      ReceivePort responsePort = ReceivePort();
      isolateModel.responsePort = responsePort.sendPort;
      isolateInference!.sendPort.send(isolateModel);

      var results = await responsePort.first;
      return results as Map<String, double>;
    } catch (e) {
      log('Error in inferenceImageFile: $e');
      rethrow;
    }
  }

  // todo-03-isolate-12: close the process from the service
  Future<void> close() async {
    if (isolateInference != null) {
      await isolateInference!.close();
    }
  }
}
