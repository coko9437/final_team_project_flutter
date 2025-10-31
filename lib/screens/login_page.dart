// lib/screens/login_page.dart
import 'package:flutter/material.dart';
import 'signup_page.dart';   // 👈 회원가입 페이지 import
import 'main_screen.dart';  // 👈 메인 스크린 import

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                Icon(
                  Icons.pets,
                  color: Colors.pink[300],
                  size: 80,
                ),
                SizedBox(height: 16),
                Text(
                  '반가워요!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[400],
                  ),
                ),
                SizedBox(height: 48),

                // ... (이메일, 비밀번호 입력 필드) ...

                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: '이메일',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  obscureText: _isPasswordObscure,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    hintText: '비밀번호',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.pink[300],
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordObscure = !_isPasswordObscure;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // 1. [로그인 버튼] -> MainScreen으로 이동
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: 실제 로그인 로직 구현

                      // [핵심] 로그인 성공 시 MainScreen으로 이동
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    },
                    child: Text('로그인', style: TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(height: 16),

                // 2. [회원가입 버튼] -> SignupPage로 이동
                //
                //    👇👇👇 바로 여기에 있습니다! 👇👇👇
                //
                TextButton(
                  onPressed: () {
                    // [핵심] SignupPage로 이동합니다. (push)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: Text(
                    '아직 회원이 아니신가요? 회원가입',
                    style: TextStyle(color: Colors.pink[400]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}