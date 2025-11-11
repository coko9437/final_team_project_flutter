// lib/ui/screens/main_screen.dart
// 로그인 후 진입하는 메인 프레임

import 'package:flutter/material.dart';
import '../map/simple_map_screen.dart';
import '../profile/profile_screen.dart';
import '../widgets/bottom_nav.dart';
import 'home/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // 각 탭에 해당하는 화면 위젯 리스트
  final List<Widget> _screens = [
    const HomeScreen(),
    const SimpleMapScreen(),
    const ProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack은 탭 전환 시 화면 상태를 유지해줍니다.
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}