// lib/models/nutrition_data.dart

/// 영양 정보 DTO
class NutritionData {
  final double? calories;
  final double? protein;
  final double? fat;
  final double? carbohydrates;

  NutritionData({
    this.calories,
    this.protein,
    this.fat,
    this.carbohydrates,
  });

  factory NutritionData.fromJson(Map<String, dynamic> json) {
    return NutritionData(
      calories: (json['calories'] as num?)?.toDouble(),
      protein: (json['protein'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
      carbohydrates: (json['carbohydrates'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbohydrates': carbohydrates,
    };
  }
}