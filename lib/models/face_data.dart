import 'package:flutter/material.dart';

class FaceData {
  final Rect boundingBox;
  final double? smileProbability;
  final double? leftEyeOpenProbability;
  final double? rightEyeOpenProbability;
  final double? headEulerAngleY;
  final double? headEulerAngleZ;

  FaceData({
    required this.boundingBox,
    this.smileProbability,
    this.leftEyeOpenProbability,
    this.rightEyeOpenProbability,
    this.headEulerAngleY,
    this.headEulerAngleZ,
  });

  bool get isSmiling => (smileProbability ?? 0) > 0.5;
  bool get leftEyeOpen => (leftEyeOpenProbability ?? 0) > 0.5;
  bool get rightEyeOpen => (rightEyeOpenProbability ?? 0) > 0.5;

  String get emotion {
    if (isSmiling) return 'Happy';
    if (!leftEyeOpen && !rightEyeOpen) return 'Sleepy';
    return 'Neutral';
  }

  Color get emotionColor {
    switch (emotion) {
      case 'Happy':
        return Colors.green;
      case 'Sleepy':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
