// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import './home_page.dart';
import './capture_page.dart';
import 'simple_map_screen.dart';
import '../widgets/bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _navigateToCapture() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CapturePage(
          onFoodDetected: (food) {
            print('✅ MainScreen: 분석 완료 (네비게이션은 CapturePage에서 수행)');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomePage(onCapture: _navigateToCapture),      // index 0: 홈
          const Center(child: Text('단식', style: TextStyle(fontSize: 24))),  // index 1: 단식
          const SimpleMapScreen(),                       // index 2: maps (여기로 이동)
          const Center(child: Text('이력', style: TextStyle(fontSize: 24))),  // index 3: 이력
          const Center(child: Text('mypage', style: TextStyle(fontSize: 24))), // index 4: 내정보
        ],
      ),

      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}