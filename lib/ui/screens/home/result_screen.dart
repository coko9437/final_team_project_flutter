// lib/ui/screens/home/result_screen.dart
//이미지 분석 결과를 상세하게 보여주는 화면

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/analysis_result.dart';
import '../map/restaurant_map_screen.dart';

class ResultScreen extends StatelessWidget {
  final AnalysisResult result;
  final String imagePath;

  const ResultScreen({
    super.key,
    required this.result,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(result.foodName ?? '분석 결과'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          // 홈 화면으로 돌아가되, 이전 기록은 모두 지웁니다.
          onPressed: () => Navigator.of(context)
              .pushNamedAndRemoveUntil('/main', (route) => false),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 분석된 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(File(imagePath),
                  height: 250, fit: BoxFit.cover),
            ),
            const SizedBox(height: 24),

            // 음식 이름 및 정확도
            Text(
              result.foodName ?? '음식',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (result.accuracy != null)
              Text(
                '정확도: ${result.accuracy!.toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 24),

            // 주변 식당 찾기 버튼
            ElevatedButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('주변 식당 찾기'),
              onPressed: () {
                if (result.foodName != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantMapScreen(
                        foodName: result.foodName!,
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 24),

            // 영양 정보
            _buildSectionTitle('영양 정보'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: result.nutritionData != null
                    ? Column(
                  children: [
                    _buildNutritionRow('칼로리',
                        '${result.nutritionData!.calories?.toStringAsFixed(0) ?? '-'} kcal'),
                    _buildNutritionRow('탄수화물',
                        '${result.nutritionData!.carbohydrates?.toStringAsFixed(1) ?? '-'} g'),
                    _buildNutritionRow('단백질',
                        '${result.nutritionData!.protein?.toStringAsFixed(1) ?? '-'} g'),
                    _buildNutritionRow('지방',
                        '${result.nutritionData!.fat?.toStringAsFixed(1) ?? '-'} g'),
                  ],
                )
                    : const Text('영양 정보를 불러올 수 없습니다.'),
              ),
            ),
            const SizedBox(height: 24),

            // 추천 유튜브 레시피
            _buildSectionTitle('추천 레시피'),
            result.youtubeRecipes.isNotEmpty
                ? Column(
              children: result.youtubeRecipes
                  .map((recipe) => ListTile(
                leading: const Icon(Icons.play_circle_fill, color: Colors.red),
                title: Text(recipe.title, maxLines: 2),
                onTap: () async {
                  if (recipe.url != null) {
                    final uri = Uri.parse(recipe.url!);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  }
                },
              ))
                  .toList(),
            )
                : const Text('추천 레시피가 없습니다.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}