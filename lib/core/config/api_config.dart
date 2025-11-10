// lib/core/config/api_config.dart
// 서버와의 통신, 데이터 처리, 외부 서비스 연동 등
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // ============================================
  // 🔧 NGROK 설정 (OAuth2 로그인용)
  // ============================================
  static const String _ngrokUrl = 'https://sterling-jay-well.ngrok-free.app';

  // ============================================
  // 🔧 로컬 개발 설정 (일반 API용)
  // ============================================
  // ⚠️ 실제 기기 테스트 시 여기를 본인의 PC IP 주소로 변경하세요!
  static const String _serverIp = '10.100.201.26';
  static const int _serverPort = 8080;

  static String _getLocalServerUrl() {
    if (kIsWeb) return 'http://localhost:$_serverPort';
    if (Platform.isAndroid) return 'http://10.0.2.2:$_serverPort';
    if (Platform.isIOS) return 'http://$_serverIp:$_serverPort';
    return 'http://localhost:$_serverPort';
  }

  /// 인증 API용 base URL (OAuth2 로그인용 - NGROK 우선)
  static String get authBaseUrl {
    if (_ngrokUrl.isNotEmpty) return _ngrokUrl;
    return _getLocalServerUrl();
  }

  /// 일반 API용 base URL (로컬 서버만 사용)
  static String get apiBaseUrl => _getLocalServerUrl();

  /// NGROK 사용 여부 확인
  static bool get isUsingNgrok => _ngrokUrl.isNotEmpty;

  /// NGROK 헤더 (무료 버전 경고 우회)
  static Map<String, String>? get ngrokHeaders {
    if (isUsingNgrok) return {'ngrok-skip-browser-warning': 'true'};
    return null;
  }

  /// 인증 API 엔드포인트 전체 URL 생성
  static String getAuthApiUrl(String endpoint) {
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return '$authBaseUrl$path';
  }

  /// 일반 API 엔드포인트 전체 URL 생성
  static String getApiUrl(String endpoint) {
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return '$apiBaseUrl$path';
  }
}

class LoginConfig {
  static const callbackScheme = 'myapp';
  static const callbackHost = 'oauth2';
  static const callbackPath = '/callback';
  static String get callbackUri => '$callbackScheme://$callbackHost$callbackPath';
}