// lib/ui/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import '../../../core/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authController = AuthController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authController.startLinkListener(onLoginResult: (success) {
      if (success) _onLoginSuccess();
    });
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    _authController.dispose();
    super.dispose();
  }

  void _onLoginSuccess() {
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await _authController.loginWithPassword(
        userId: _userIdController.text,
        password: _passwordController.text,
        onSuccess: _onLoginSuccess,
        onError: _showError,
      );
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                const Text(
                  '로그인',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _userIdController,
                  decoration: const InputDecoration(labelText: '아이디'),
                  validator: (v) => v!.trim().isEmpty ? '아이디를 입력하세요' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: '비밀번호'),
                  obscureText: true,
                  validator: (v) => v!.isEmpty ? '비밀번호를 입력하세요' : null,
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('로그인'),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () => _authController.loginWithSocial(
                    provider: 'google',
                    onError: _showError,
                  ),
                  child: const Text('Google 계정으로 로그인'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => _authController.loginWithSocial(
                    provider: 'naver',
                    onError: _showError,
                  ),
                  child: const Text('네이버 계정으로 로그인'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/signup'),
                  child: const Text('아직 회원이 아니신가요? 회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}