// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import './home_page.dart'; // './'는 같은 screens 폴더라는 의미
import './capture_page.dart';
import './result_page.dart';
import '../widgets/bottom_nav.dart'; // '../'는 상위 폴더(lib)로 나간다는 의미

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Map<String, dynamic>? _detectedFood;

  void _navigateToCapture() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CapturePage(
          onFoodDetected: (food) {
            setState(() {
              _detectedFood = food;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResultPage(
                  food: food,
                  onBack: () {
                    Navigator.pop(context);
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                ),
              ),
            );
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
          HomePage(onCapture: _navigateToCapture),
          const Center(child: Text('단식', style: TextStyle(fontSize: 24))),
          const Center(child: Text('캘츠 코치', style: TextStyle(fontSize: 24))),
          const Center(child: Text('체중', style: TextStyle(fontSize: 24))),
          const Center(child: Text('웰니스', style: TextStyle(fontSize: 24))),
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