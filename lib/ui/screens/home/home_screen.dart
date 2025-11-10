// lib/ui/screens/home/home_screen.dart
// 로그인 후 보게 될 첫 화면
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'capture_screen.dart'; // 사진 촬영 화면

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 사진 촬영 화면으로 이동하는 함수
  void _navigateToCapture(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CaptureScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 식단'),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lottie 애니메이션
                  Lottie.asset(
                    'assets/images/3D Chef Dancing.json',
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 30),
                  // 칼로리 정보 (현재는 UI만 구성)
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      children: [
                        const TextSpan(text: '0'),
                        TextSpan(
                          text: ' / 2000',
                          style: TextStyle(color: Colors.grey[300]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '섭취한 칼로리 (kcal)',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.bar_chart),
                      label: const Text('자세한 영양 정보 보기')),
                ],
              ),
            ),
          ),
          // 사진 촬영 버튼 (Floating Action Button)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => _navigateToCapture(context),
              backgroundColor: Colors.orange,
              child: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
