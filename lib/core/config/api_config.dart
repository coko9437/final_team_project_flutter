/// 🔹 API 요청의 base URL 설정
/// 
/// ⚠️ 중요: 
/// - 인증 API (로그인, 회원가입, OAuth2): NGROK 사용 (외부 접근 필요)
/// - 일반 API (지도, 분석 등): 로컬 서버 사용
/// - NGROK이 없어도 로컬 서버로 폴백하여 작동
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // ============================================
  // 🔧 NGROK 설정 (인증 API용만)
  // ============================================
  // OAuth2 로그인만 NGROK 사용 (소셜 로그인 리다이렉트 필요)
  // 일반 API는 에뮬레이터 로컬 서버 사용
  static const String _ngrokUrl = 'https://sterling-jay-well.ngrok-free.app';
  
  // ============================================
  // 🔧 로컬 개발 설정 (일반 API용)
  // ============================================
  // 안드로이드 에뮬레이터: 10.0.2.2는 localhost를 가리킴
  static const int _serverPort = 8080;
  
  /// 플랫폼별 로컬 서버 URL 반환 (일반 API용)
  static String _getLocalServerUrl() {
    // 웹 환경
    if (kIsWeb) {
      return 'http://localhost:$_serverPort';
    }
    // Android 에뮬레이터
    else if (Platform.isAndroid) {
      return 'http://10.0.2.2:$_serverPort'; // Android 에뮬레이터는 10.0.2.2가 localhost
    }
    // iOS 시뮬레이터 또는 실제 기기
    else if (Platform.isIOS) {
      // iOS 시뮬레이터는 localhost 사용 가능
      return 'http://localhost:$_serverPort';
    }
    // 기본값
    else {
      return 'http://localhost:$_serverPort';
    }
  }
  
  /// 인증 API용 base URL (NGROK 사용)
  /// 로그인, 회원가입, OAuth2 소셜 로그인에 사용
  static String get authBaseUrl {
    return _ngrokUrl;
  }
  
  /// 일반 API용 base URL (로컬 서버 사용 - 에뮬레이터)
  /// 지도, 분석, 마이페이지 등 일반 기능에 사용
  static String get apiBaseUrl {
    return _getLocalServerUrl();
  }
  
  /// 하위 호환성을 위한 baseUrl (일반 API용으로 사용)
  /// @deprecated: apiBaseUrl 사용 권장
  static String get baseUrl => apiBaseUrl;
  
  /// NGROK 사용 여부 확인
  static bool get isUsingNgrok => _ngrokUrl.isNotEmpty;
  
  /// NGROK 헤더 (무료 버전 브라우저 경고 페이지 우회)
  static Map<String, String>? get ngrokHeaders {
    if (isUsingNgrok) {
      return {'ngrok-skip-browser-warning': 'true'};
    }
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
  
  /// 디버그용: 현재 사용 중인 URL 출력
  static void printCurrentUrl() {
    print('🔐 인증 API URL (authBaseUrl): $authBaseUrl');
    print('🌐 일반 API URL (apiBaseUrl): $apiBaseUrl');
    print('📱 Platform: ${kIsWeb ? 'Web' : Platform.isIOS ? 'iOS' : Platform.isAndroid ? 'Android' : 'Other'}');
    print('🔗 NGROK 사용: ${isUsingNgrok ? "예" : "아니오 (로컬 서버 사용)"}');
  }
}
