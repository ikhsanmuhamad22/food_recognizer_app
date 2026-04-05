import 'dart:convert';

import 'package:food_recognition_app/data/model/meals_response.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String baseUrl =
      'https://www.themealdb.com/api/json/v1/1/search.php?s=';

  Future<MealsResponse> getMealsResponse(String foodName) async {
    final response = await http.get(Uri.parse('$baseUrl$foodName'));
    if (response.statusCode == 200) {
      return MealsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load meals');
    }
  }
}
