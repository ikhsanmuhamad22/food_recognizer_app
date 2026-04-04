// import 'package:flutter/material.dart';
// import 'package:food_recognition_app/data/model/food_model.dart';
// import 'package:food_recognition_app/service/gemini_service.dart';

// class GeminiController extends ChangeNotifier {
//  final GeminiService service;
 
//  GeminiController(this.service);
 
//  Food? response;
 
//  Food? get food => response;
 
//  bool _isLoading = false;
 
//  bool get isLoading => _isLoading;
 
//  Future<void> generateTranscript() async {
//     _response = null;
//    _isLoading = true;
//    notifyListeners();
 
//    final file = await getFileFromAssets("softskill_podcast.mp3");
//    final response = await service.generateTranscript(file);
 
//    _transcript = Transcript.fromJson(response);
//    _isLoading = false;
//    notifyListeners();
//  }
// }