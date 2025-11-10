// lib/ui/screens/splash_screen.dart
// 앱이 시작될 때 로그인 상태를 확인하는 동안 잠시 보여줄 로딩 화면

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 여기에 앱 로고나 Lottie 애니메이션 등을 추가할 수 있습니다.
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              '잠시만 기다려주세요...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}