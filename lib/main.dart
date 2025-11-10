// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// UI 스크린 Import
import 'ui/screens/auth/login_screen.dart';
import 'ui/screens/auth/signup_screen.dart';
import 'ui/screens/main_screen.dart';
import 'ui/screens/splash_screen.dart'; // 로딩 상태를 표시할 스플래시 화면

void main() async {
  // Flutter 엔진과 위젯 바인딩을 초기화합니다.
  // main 함수에서 비동기 작업을 수행하기 위해 필수입니다.
  WidgetsFlutterBinding.ensureInitialized();

  // 앱을 세로 모드로 고정합니다.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '칼로리 트래커',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      // [핵심] FutureBuilder를 사용하여 로그인 상태 확인 후 화면 결정
      home: FutureBuilder<String?>(
        // Secure Storage에서 'accessToken'을 읽어옵니다.
        future: const FlutterSecureStorage().read(key: 'accessToken'),
        builder: (context, snapshot) {
          // 1. 로딩 중일 때 (토큰 확인 중)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen(); // 로딩 중에는 스플래시 화면을 보여줍니다.
          }

          // 2. 토큰이 있고, 비어있지 않을 때 (로그인 상태)
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return const MainScreen(); // 메인 화면으로 이동
          }

          // 3. 토큰이 없거나, 에러가 발생했을 때 (비로그인 상태)
          return const LoginScreen(); // 로그인 화면으로 이동
        },
      ),
      // 명명된 라우트(Named Route) 정의
      routes: {
        // '/login' 경로는 home에서 처리하므로 중복 정의하지 않습니다.
        '/signup': (context) => const SignupScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}