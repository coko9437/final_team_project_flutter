// lib/core/services/map_service.dart
// 위치 기반 서비스(주변 식당 검색)를 위한 API 통신을 담당
// Geolocator를 사용하여 현재 위치를 가져오고, 그 정보를 바탕으로 백엔드에 식당 목록을 요청
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../../models/restaurant.dart';

/// 위치 기반 서비스 (지도, 식당 검색)를 위한 서비스 클래스
class MapService {
  /// 주변 식당 검색
  Future<List<Restaurant>> findNearbyRestaurants({
    required String foodName,
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(ApiConfig.getApiUrl('/api/map/search')).replace(
      queryParameters: {
        'foodName': foodName,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      },
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData.map((item) => Restaurant.fromJson(item)).toList();
    } else {
      throw Exception("주변 식당을 검색하는 데 실패했습니다.");
    }
  }

  /// 사용자의 현재 위치를 가져옴
  Future<Position> getCurrentLocation() async {
    // 1. 위치 서비스 활성화 여부 확인
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('위치 서비스가 비활성화되어 있습니다.');
    }

    // 2. 위치 권한 확인 및 요청
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('위치 권한이 거부되었습니다.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('위치 권한이 영구적으로 거부되었습니다. 앱 설정에서 권한을 허용해주세요.');
    }

    // 3. 현재 위치 정보 반환
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
  }
}