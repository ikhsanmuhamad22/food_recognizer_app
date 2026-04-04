import 'dart:convert';

import 'package:food_recognition_app/data/model/food_model.dart';
import 'package:food_recognition_app/env/env.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel model;

  GeminiService() {
    final apiKey = Env.geminiApiKey;
    model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0,
        responseMimeType: 'application/json',
        responseSchema: Schema(
          SchemaType.object,
          requiredProperties: ["nutrition"],
          properties: {
            "nutrition": Schema(
              SchemaType.object,
              requiredProperties: [
                "calories",
                "carbs",
                "fats",
                "fiber",
                "protein",
              ],
              properties: {
                "calories": Schema(SchemaType.number),
                "carbs": Schema(SchemaType.number),
                "fats": Schema(SchemaType.number),
                "fiber": Schema(SchemaType.number),
                "protein": Schema(SchemaType.number),
              },
            ),
          },
        ),
      ),
    );
  }

  Future<Nutrition> generateCommands(String foodName) async {
    var content = Content.multi([
      TextPart(
        """Saya adalah suatu mesin yang mampu mengidentifikasi nutrisi atau kandungan gizi pada makanan layaknya uji laboratorium makanan. Hal yang bisa diidentifikasi adalah kalori, karbohidrat, lemak, serat, dan protein pada makanan. Satuan dari indikator tersebut berupa gram. Nama makanannya adalah $foodName.""",
      ),
    ]);
    final response = await model.generateContent([content]);

    final responseText = response.text!;
    final Map<String, dynamic> json = jsonDecode(responseText);
    return Nutrition.fromJson(json['nutrition']);
  }
}
