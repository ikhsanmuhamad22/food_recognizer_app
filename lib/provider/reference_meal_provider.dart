import 'package:flutter/material.dart';
import 'package:food_recognition_app/data/model/meals_response.dart';
import 'package:food_recognition_app/service/api_service.dart';

class ReferenceMealProvider extends ChangeNotifier {
  final ApiServices apiServices;

  ReferenceMealProvider({required this.apiServices});

  MealsResponse? _mealsResponse;
  MealsResponse? get mealsResponse => _mealsResponse;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMeals(String foodName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await apiServices.getMealsResponse(foodName);
      _mealsResponse = response;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
