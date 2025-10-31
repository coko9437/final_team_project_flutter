// ==================== lib/screens/home_page.dart ====================
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onCapture;

  const HomePage({super.key, required this.onCapture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 250,
                          height: 250,
                          child: CustomPaint(
                            painter: PenguinPainter(),
                          ),
                        ),
                        Positioned(
                          top: -10,
                          right: -10,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.orange[300],
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: const Center(
                              child: Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '소모됨: 0 KCAL',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              const TextSpan(
                                text: '0',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: ' / 1500',
                                style: TextStyle(color: Colors.grey[300]),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '섭취한 칼로리',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF9A56),
                            Color(0xFFFF6B9D),
                            Color(0xFFFE5E8E),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          '💬 더 많은 세부정보 보기',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🍎', style: TextStyle(fontSize: 24)),
                          SizedBox(width: 8),
                          Text(
                            '기록됨: 0',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: onCapture,
                backgroundColor: Colors.black,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PenguinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 3;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: 140,
        height: 160,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: 140,
        height: 160,
      ),
      strokePaint,
    );

    final eyePaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(centerX - 25, centerY - 20), 8, eyePaint);
    canvas.drawCircle(Offset(centerX + 25, centerY - 20), 8, eyePaint);

    final eyebrowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final leftEyebrow = Path()
      ..moveTo(centerX - 25, centerY - 35)
      ..quadraticBezierTo(
        centerX - 25,
        centerY - 45,
        centerX - 15,
        centerY - 45,
      );
    canvas.drawPath(leftEyebrow, eyebrowPaint);

    final rightEyebrow = Path()
      ..moveTo(centerX + 25, centerY - 35)
      ..quadraticBezierTo(
        centerX + 25,
        centerY - 45,
        centerX + 15,
        centerY - 45,
      );
    canvas.drawPath(rightEyebrow, eyebrowPaint);

    final beakPaint = Paint()..color = Colors.black;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY - 5),
        width: 30,
        height: 20,
      ),
      beakPaint,
    );

    final beakHighlight = Paint()..color = Colors.white;
    final beakPath = Path()
      ..moveTo(centerX - 15, centerY - 5)
      ..lineTo(centerX, centerY)
      ..lineTo(centerX + 15, centerY - 5);
    canvas.drawPath(beakPath, beakHighlight);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 50, centerY + 20),
        width: 30,
        height: 100,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 50, centerY + 20),
        width: 30,
        height: 100,
      ),
      strokePaint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 50, centerY + 20),
        width: 30,
        height: 100,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 50, centerY + 20),
        width: 30,
        height: 100,
      ),
      strokePaint,
    );

    final footPaint = Paint()..color = Colors.black;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 30, centerY + 60),
        width: 20,
        height: 30,
      ),
      footPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 30, centerY + 60),
        width: 20,
        height: 30,
      ),
      footPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}