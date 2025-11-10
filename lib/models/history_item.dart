// lib/models/history_item.dart
// 마이페이지의 분석 이력 목록에 표시될 각 항목의 데이터 모델
import 'youtube_recipe.dart';

/// 분석 이력 DTO
class HistoryItem {
  final String historyId;
  final String recognizedFoodName;
  final double accuracy;
  final DateTime analysisDate;
  final String thumbnailImageId;
  final List<YoutubeRecipe> youtubeRecipes;

  HistoryItem({
    required this.historyId,
    required this.recognizedFoodName,
    required this.accuracy,
    required this.analysisDate,
    required this.thumbnailImageId,
    required this.youtubeRecipes,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      historyId: json['historyId'] as String,
      recognizedFoodName: json['recognizedFoodName'] as String,
      accuracy: (json['accuracy'] as num).toDouble(),
      analysisDate: DateTime.parse(json['analysisDate'] as String),
      thumbnailImageId: json['thumbnailImageId'] as String,
      youtubeRecipes: (json['youtubeRecipes'] as List<dynamic>? ?? [])
          .map((item) => YoutubeRecipe.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}