// lib/core/services/auth_service.dart
// Dio 라이브러리를 사용하여 실제 서버와 통신하고, 인증(로그인/회원가입/로그아웃) 관련 데이터를 주고받는 역할

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import '../config/api_config.dart';

/// 서버와 직접 통신하여 인증 관련 작업을 처리하는 서비스 클래스
class AuthService {
  // Dio 인스턴스 초기화 (인증 API용 URL 사용)
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.authBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    validateStatus: (_) => true, // 4xx, 5xx 에러 발생 시에도 응답 본문을 받기 위함
    headers: ApiConfig.ngrokHeaders, // Ngrok 사용 시 필요한 헤더 추가
  ));

  // 토큰을 안전하게 저장하기 위한 Secure Storage 인스턴스
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// ID/PW를 이용한 자체 로그인
  Future<void> loginWithPassword({required String userId, required String password}) async {
    final response = await _dio.post('/api/users/login', data: {
      'userId': userId.trim(),
      'password': password,
    });

    if (response.statusCode == 200 && response.data != null) {
      // 성공 시 토큰 저장
      await _saveTokens(response.data);
    } else {
      // 실패 시 에러 메시지 throw
      throw _extractError(response);
    }
  }

  /// 회원가입
  Future<void> signup({
    required String userId,
    required String email,
    required String password,
    required String passwordConfirm,
    XFile? profileImage,
  }) async {
    // 백엔드로 보낼 JSON 데이터 생성
    final signupData = jsonEncode({
      'userId': userId.trim(),
      'email': email.trim(),
      'password': password,
      'passwordConfirm': passwordConfirm,
    });

    // Multipart/form-data 형식으로 데이터 구성
    final formData = FormData.fromMap({
      'signupData': signupData,
      if (profileImage != null)
        'profileImage': await MultipartFile.fromFile(
          profileImage.path,
          filename: p.basename(profileImage.path),
        ),
    });

    final response = await _dio.post('/api/users/signup', data: formData);

    // 회원가입 성공은 보통 200 OK 또는 201 Created
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw _extractError(response);
    }
  }

  /// 소셜 로그인 (provider: 'google' 또는 'naver')
  Future<void> loginWithSocial({required String provider}) async {
    final url = Uri.parse('${ApiConfig.authBaseUrl}/oauth2/authorization/$provider');
    // 외부 브라우저를 통해 소셜 로그인 페이지를 엽니다.
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw '소셜 로그인 페이지를 열 수 없습니다.';
    }
  }

  /// 앱으로 돌아오는 OAuth2 리다이렉트 URI 처리
  Future<bool> handleOAuthRedirect(Uri uri) async {
    final accessToken = uri.queryParameters['access'];
    final refreshToken = uri.queryParameters['refresh'];

    if (accessToken != null && accessToken.isNotEmpty) {
      await _storage.write(key: 'accessToken', value: accessToken);
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _storage.write(key: 'refreshToken', value: refreshToken);
      }
      return true; // 성공
    }
    return false; // 실패
  }

  /// 로그아웃 (저장된 모든 인증 정보 삭제)
  Future<void> logout() async {
    await _storage.deleteAll();
  }

  // --- 내부 헬퍼 메소드 ---

  /// 응답 데이터에서 토큰을 추출하여 저장
  Future<void> _saveTokens(dynamic data) async {
    final accessToken = data['accessToken'];
    final refreshToken = data['refreshToken'];
    if (accessToken != null) await _storage.write(key: 'accessToken', value: accessToken);
    if (refreshToken != null) await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  /// Dio 응답에서 에러 메시지 추출
  String _extractError(Response response) {
    try {
      // 백엔드에서 {"message": "에러 내용"} 형식으로 응답하는 경우
      if (response.data is Map && response.data['message'] != null) {
        return response.data['message'];
      }
      // 백엔드에서 에러 메시지를 일반 텍스트로 응답하는 경우
      if (response.data is String && response.data.isNotEmpty) {
        return response.data;
      }
      // 그 외의 경우, 상태 코드를 포함한 일반 메시지 반환
      return '서버 오류가 발생했습니다. (Code: ${response.statusCode})';
    } catch (_) {
      return '알 수 없는 오류가 발생했습니다.';
    }
  }
}