// lib/core/services/analysis_service.dart
// 분석 관련 API 통신을 전담
// 미지 분석, 분석 이력 조회, 유튜브 레시피 검색 등 AI 및 데이터 관련 API 호출을 담당하는 서비스

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';
import '../../models/analysis_result.dart';
import '../../models/history_item.dart';
import '../../models/youtube_recipe.dart';

/// 서버와 통신하여 이미지 분석 및 관련 데이터 조회를 처리하는 서비스
class AnalysisService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// JWT 토큰을 포함한 인증 헤더를 생성
  Future<Map<String, String>> _getAuthHeaders() async {
    final accessToken = await _storage.read(key: 'accessToken');
    final headers = {'Content-Type': 'application/json; charset=UTF--8'};
    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }

  /// 이미지 분석 요청
  Future<AnalysisResult> analyzeImage({
    required File imageFile,
    required int userId, // TODO: 추후 백엔드에서 JWT 토큰으로 사용자 식별 시 제거될 수 있음
    String? youtubeKeyword,
    String youtubeOrder = 'relevance',
  }) async {
    final url = ApiConfig.getApiUrl('/api/analysis');
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Multipart 요청에 파일과 필드 추가
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.fields['userId'] = userId.toString();
    if (youtubeKeyword != null && youtubeKeyword.trim().isNotEmpty) {
      request.fields['youtubeKeyword'] = youtubeKeyword;
      request.fields['youtubeOrder'] = youtubeOrder;
    }
    // 인증 헤더 추가
    final authHeaders = await _getAuthHeaders();
    request.headers.addAll(authHeaders);

    try {
      final streamedResponse = await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        return AnalysisResult.fromJson(json.decode(decodedBody));
      } else {
        final decodedBody = utf8.decode(response.bodyBytes);
        throw AnalysisException(
            json.decode(decodedBody)['message'] ?? '이미지 분석에 실패했습니다.',
            statusCode: response.statusCode);
      }
    } catch (e) {
      // 타임아웃 또는 네트워크 오류 처리
      throw AnalysisException('서버에 연결할 수 없습니다. 네트워크 상태를 확인해주세요.');
    }
  }

  /// 분석 이력 조회
  Future<List<HistoryItem>> getAnalysisHistory({int page = 0, int size = 10}) async {
    final uri = Uri.parse(ApiConfig.getApiUrl('/api/analysis/history')).replace(
      queryParameters: {'page': page.toString(), 'size': size.toString()},
    );

    final headers = await _getAuthHeaders();
    final response = await http.get(uri, headers: headers).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData.map((item) => HistoryItem.fromJson(item)).toList();
    } else {
      throw Exception('분석 이력을 불러오는 데 실패했습니다.');
    }
  }

  /// YouTube 레시피 검색
  Future<List<YoutubeRecipe>> searchYouTubeRecipes({
    required String foodName,
    String? keyword,
    String order = 'relevance',
  }) async {
    final uri = Uri.parse(ApiConfig.getApiUrl('/api/youtube/search')).replace(
      queryParameters: {
        'foodName': foodName,
        if (keyword != null && keyword.trim().isNotEmpty) 'keyword': keyword.trim(),
        'order': order,
      },
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData.map((item) => YoutubeRecipe.fromJson(item)).toList();
    } else {
      throw Exception('YouTube 레시피 검색에 실패했습니다.');
    }
  }

  /// 클릭된 YouTube 레시피를 서버에 저장 요청
  Future<void> saveClickedYouTubeRecipe({
    required String historyId,
    required String title,
    required String url,
  }) async {
    final uri = Uri.parse(ApiConfig.getApiUrl('/api/analysis/youtube-recipe/click')).replace(
      queryParameters: {
        'historyId': historyId,
        'title': title,
        'url': url,
      },
    );
    final headers = await _getAuthHeaders();
    await http.post(uri, headers: headers).timeout(const Duration(seconds: 10));
    // 성공/실패 여부를 세밀하게 처리하려면 응답 코드를 확인
  }

  /// 썸네일 이미지 URL 생성 (정적 메소드)
  static String getThumbnailUrl(String historyId) {
    return ApiConfig.getApiUrl('/api/analysis/thumbnail/$historyId');
  }
}

/// 분석 관련 API 통신 중 발생하는 예외
class AnalysisException implements Exception {
  final String message;
  final int? statusCode;

  AnalysisException(this.message, {this.statusCode});

  @override
  String toString() => message;
}