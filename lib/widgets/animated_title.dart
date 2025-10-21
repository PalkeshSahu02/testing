import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AnimatedTitle extends StatelessWidget {
  const AnimatedTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: const Color(0xFF6C63FF),
      period: const Duration(seconds: 3),
      child: const Text(
        'Face Recognition',
        style: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
