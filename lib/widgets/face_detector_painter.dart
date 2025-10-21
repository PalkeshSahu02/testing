import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:ui' as ui;

class FaceDetectorPainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;

  FaceDetectorPainter({
    required this.faces,
    required this.imageSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = const Color(0xFF6C63FF);

    final Paint fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF6C63FF).withOpacity(0.1);

    for (final Face face in faces) {
      final rect = _scaleRect(
        rect: face.boundingBox,
        imageSize: imageSize,
        widgetSize: size,
      );

      // Draw filled rectangle
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(12)),
        fillPaint,
      );

      // Draw border
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(12)),
        paint,
      );

      // Draw corner accents
      _drawCornerAccents(canvas, rect);

      // Draw face landmarks if available
      _drawFaceLandmarks(canvas, face, size);

      // Draw emotion indicator
      _drawEmotionIndicator(canvas, face, rect);
    }
  }

  void _drawCornerAccents(Canvas canvas, Rect rect) {
    final Paint accentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = const Color(0xFF6C63FF)
      ..strokeCap = StrokeCap.round;

    final double cornerLength = 20;

    // Top-left corner
    canvas.drawLine(
      Offset(rect.left, rect.top),
      Offset(rect.left + cornerLength, rect.top),
      accentPaint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.top),
      Offset(rect.left, rect.top + cornerLength),
      accentPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(rect.right, rect.top),
      Offset(rect.right - cornerLength, rect.top),
      accentPaint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.top),
      Offset(rect.right, rect.top + cornerLength),
      accentPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(rect.left, rect.bottom),
      Offset(rect.left + cornerLength, rect.bottom),
      accentPaint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.bottom),
      Offset(rect.left, rect.bottom - cornerLength),
      accentPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(rect.right, rect.bottom),
      Offset(rect.right - cornerLength, rect.bottom),
      accentPaint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.bottom),
      Offset(rect.right, rect.bottom - cornerLength),
      accentPaint,
    );
  }

  void _drawFaceLandmarks(Canvas canvas, Face face, Size size) {
    final Paint landmarkPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.greenAccent;

    // Draw eye landmarks
    final leftEye = face.landmarks[FaceLandmarkType.leftEye];
    final rightEye = face.landmarks[FaceLandmarkType.rightEye];

    if (leftEye != null) {
      final point = _scalePoint(
        point: leftEye.position,
        imageSize: imageSize,
        widgetSize: size,
      );
      canvas.drawCircle(point, 4, landmarkPaint);
    }

    if (rightEye != null) {
      final point = _scalePoint(
        point: rightEye.position,
        imageSize: imageSize,
        widgetSize: size,
      );
      canvas.drawCircle(point, 4, landmarkPaint);
    }

    // Draw nose
    final noseBase = face.landmarks[FaceLandmarkType.noseBase];
    if (noseBase != null) {
      final point = _scalePoint(
        point: noseBase.position,
        imageSize: imageSize,
        widgetSize: size,
      );
      canvas.drawCircle(point, 4, landmarkPaint..color = Colors.blueAccent);
    }

    // Draw mouth
    final leftMouth = face.landmarks[FaceLandmarkType.leftMouth];
    final rightMouth = face.landmarks[FaceLandmarkType.rightMouth];
    final bottomMouth = face.landmarks[FaceLandmarkType.bottomMouth];

    if (leftMouth != null && rightMouth != null) {
      final leftPoint = _scalePoint(
        point: leftMouth.position,
        imageSize: imageSize,
        widgetSize: size,
      );
      final rightPoint = _scalePoint(
        point: rightMouth.position,
        imageSize: imageSize,
        widgetSize: size,
      );

      canvas.drawCircle(leftPoint, 3, landmarkPaint..color = Colors.pinkAccent);
      canvas.drawCircle(rightPoint, 3, landmarkPaint..color = Colors.pinkAccent);

      if (bottomMouth != null) {
        final bottomPoint = _scalePoint(
          point: bottomMouth.position,
          imageSize: imageSize,
          widgetSize: size,
        );
        canvas.drawCircle(bottomPoint, 3, landmarkPaint..color = Colors.pinkAccent);
      }
    }
  }

  void _drawEmotionIndicator(Canvas canvas, Face face, Rect rect) {
    final smileProbability = face.smilingProbability ?? 0;
    final isSmiling = smileProbability > 0.5;

    if (isSmiling) {
      final textPainter = TextPainter(
        text: const TextSpan(
          text: '😊',
          style: TextStyle(fontSize: 24),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(rect.right - 30, rect.top - 30),
      );
    }
  }

  Rect _scaleRect({
    required Rect rect,
    required Size imageSize,
    required Size widgetSize,
  }) {
    final scaleX = widgetSize.width / imageSize.height;
    final scaleY = widgetSize.height / imageSize.width;

    return Rect.fromLTRB(
      rect.top * scaleX,
      rect.left * scaleY,
      rect.bottom * scaleX,
      rect.right * scaleY,
    );
  }

  Offset _scalePoint({
    required Point<int> point,
    required Size imageSize,
    required Size widgetSize,
  }) {
    final scaleX = widgetSize.width / imageSize.height;
    final scaleY = widgetSize.height / imageSize.width;

    return Offset(
      point.y.toDouble() * scaleX,
      point.x.toDouble() * scaleY,
    );
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.faces != faces;
  }
}
