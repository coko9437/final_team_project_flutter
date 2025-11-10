// lib/models/analysis_result.dart

import 'nutrition_data.dart';
import 'youtube_recipe.dart';

/// 이미지 분석 최종 결과 DTO
class AnalysisResult {
  final String? foodName;
  final double? accuracy;
  final NutritionData? nutritionData;
  final List<YoutubeRecipe> youtubeRecipes;
  final String? message;
  final List<dynamic>? top3; // 상위 3개 예측 결과
  final String? historyId; // 분석 이력 ID

  AnalysisResult({
    this.foodName,
    this.accuracy,
    this.nutritionData,
    required this.youtubeRecipes,
    this.message,
    this.top3,
    this.historyId,
  });

  /// JSON 데이터를 AnalysisResult 객체로 변환하는 factory 생성자
  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      foodName: json['foodName'] as String?,
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      nutritionData: json['nutritionData'] != null
          ? NutritionData.fromJson(json['nutritionData'] as Map<String, dynamic>)
          : null,
      youtubeRecipes: (json['youtubeRecipes'] as List<dynamic>? ?? [])
          .map((item) => YoutubeRecipe.fromJson(item as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      top3: json['top3'] as List<dynamic>?,
      historyId: json['historyId'] as String?,
    );
  }

  /// ResultPage에서 사용할 Map 형태로 변환 (UI 데이터 바인딩용)
  Map<String, dynamic> toMapForUi() {
    return {
      'name': foodName ?? '알 수 없음',
      'accuracy': accuracy,
      'nutrition': nutritionData?.toMap(),
      'youtubeRecipes': youtubeRecipes.map((r) => r.toMap()).toList(),
      'top3': top3,
      'historyId': historyId,
      // ResultPage에서 사용하던 'calories' 필드를 nutritionData에서 가져오도록 통일
      'calories': nutritionData?.calories?.toInt() ?? 0,
    };
  }
}