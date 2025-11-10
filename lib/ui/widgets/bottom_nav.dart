// lib/ui/widgets/bottom_nav.dart

import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
final int currentIndex;
final Function(int) onTap;

const BottomNav({
super.key,
required this.currentIndex,
required this.onTap,
});

@override
Widget build(BuildContext context) {
return BottomNavigationBar(
currentIndex: currentIndex,
onTap: onTap,
type: BottomNavigationBarType.fixed, // 3개 이상일 때 아이콘이 고정되도록 설정
selectedItemColor: Colors.orange,   // 선택된 아이템 색상
unselectedItemColor: Colors.grey,   // 선택되지 않은 아이템 색상
showUnselectedLabels: true,         // 선택되지 않은 아이템의 라벨도 표시
items: const [
BottomNavigationBarItem(
icon: Icon(Icons.home),
label: '홈',
),
BottomNavigationBarItem(
icon: Icon(Icons.map_outlined),
label: '지도',
),
BottomNavigationBarItem(
icon: Icon(Icons.person_outline),
label: '마이페이지',
),
],
);
}
}