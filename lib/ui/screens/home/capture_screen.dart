// lib/ui/screens/home/capture_screen.dart
// 카메라를 실행하거나 갤러리에서 이미지를 선택하여 서버로 분석을 요청

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'result_screen.dart'; // 분석 결과 화면
import '../../../core/services/analysis_service.dart'; // 분석 서비스
import '../../../models/analysis_result.dart'; // 분석 결과 모델

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final ImagePicker _picker = ImagePicker();
  final AnalysisService _analysisService = AnalysisService();
  bool _isProcessing = false;
  File? _imageFile;

  // 이미지 선택 (카메라 또는 갤러리)
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85, // 이미지 품질 압축
      );

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
        // 이미지 선택 후 바로 분석 시작
        _processImage();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지를 가져오는 데 실패했습니다: $e')),
        );
      }
    }
  }

  // 이미지 분석 처리
  Future<void> _processImage() async {
    if (_imageFile == null) return;

    setState(() => _isProcessing = true);

    try {
      // TODO: 실제 로그인된 사용자 ID로 변경해야 함
      const int tempUserId = 1;
      final AnalysisResult result = await _analysisService.analyzeImage(
        imageFile: _imageFile!,
        userId: tempUserId,
      );

      if (mounted) {
        // 분석 성공 시, 현재 화면을 결과 화면으로 교체 (뒤로가기 시 홈으로 감)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              result: result,
              imagePath: _imageFile!.path,
            ),
          ),
        );
      }
    } on AnalysisException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('음식 사진 촬영')),
      body: Center(
        child: _isProcessing
            ? const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('음식을 분석하고 있습니다...'),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('분석할 음식 사진을 선택해주세요', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('카메라로 촬영하기'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('갤러리에서 선택'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}