class Food {
  String foodName;
  Nutrition nutrition;

  Food({required this.foodName, required this.nutrition});

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    foodName: json["foodName"],
    nutrition: Nutrition.fromJson(json["nutrition"]),
  );

  Map<String, dynamic> toJson() => {
    "foodName": foodName,
    "nutrition": nutrition.toJson(),
  };
}

class Nutrition {
  int calories;
  int carbs;
  int protein;
  int fat;
  int fiber;

  Nutrition({
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.fiber,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) => Nutrition(
    calories: json["calories"],
    carbs: json["carbs"],
    protein: json["protein"],
    fat: json["fats"],
    fiber: json["fiber"],
  );

  Map<String, dynamic> toJson() => {
    "calories": calories,
    "carbs": carbs,
    "protein": protein,
    "fats": fat,
    "fiber": fiber,
  };
}
