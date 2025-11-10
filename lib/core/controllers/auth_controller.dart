// lib/core/controllers/auth_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';

/// UI(View)와 Service(Business Logic)를 연결하는 컨트롤러
class AuthController {
  final AuthService _authService = AuthService();
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSub;

  /// 소셜 로그인 후 앱으로 돌아오는 링크(URI)를 감지하는 리스너 시작
  void startLinkListener({required Function(bool isSuccess) onLoginResult}) {
    // 이전에 구독한 리스너가 있다면 취소
    _linkSub?.cancel();

    // 앱이 종료된 상태에서 링크로 실행된 경우 초기 링크를 가져옴
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        _handleOAuthRedirect(uri, onLoginResult);
      }
    });

    // 앱이 실행 중일 때 들어오는 링크를 스트림으로 감지
    _linkSub = _appLinks.uriLinkStream.listen((uri) {
      _handleOAuthRedirect(uri, onLoginResult);
    }, onError: (err) {
      debugPrint('Auth Controller: Deep Link Error: $err');
      onLoginResult(false);
    });
  }

  /// 수신된 OAuth2 리다이렉트 URI를 서비스에 전달하여 처리
  Future<void> _handleOAuthRedirect(Uri uri, Function(bool) onLoginResult) async {
    final success = await _authService.handleOAuthRedirect(uri);
    onLoginResult(success);
  }

  /// ID/PW 로그인 요청
  Future<void> loginWithPassword({
    required String userId,
    required String password,
    required VoidCallback onSuccess,
    required void Function(String message) onError,
  }) async {
    try {
      await _authService.loginWithPassword(userId: userId, password: password);
      onSuccess();
    } catch (e) {
      onError(e.toString());
    }
  }

  /// 회원가입 요청
  Future<void> signup({
    required String userId,
    required String email,
    required String password,
    required String passwordConfirm,
    XFile? profileImage,
    required VoidCallback onSuccess,
    required void Function(String message) onError,
  }) async {
    try {
      await _authService.signup(
        userId: userId,
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
        profileImage: profileImage,
      );
      onSuccess();
    } catch (e) {
      onError(e.toString());
    }
  }

  /// 소셜 로그인 요청
  Future<void> loginWithSocial({
    required String provider,
    required void Function(String message) onError,
  }) async {
    try {
      await _authService.loginWithSocial(provider: provider);
    } catch (e) {
      onError(e.toString());
    }
  }

  /// 로그아웃 요청
  Future<void> logout() async {
    await _authService.logout();
  }

  /// 컨트롤러가 더 이상 필요 없을 때 리소스 정리
  void dispose() {
    _linkSub?.cancel();
  }
}