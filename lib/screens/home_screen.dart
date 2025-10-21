import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/face_recognition_provider.dart';
import '../widgets/gradient_background.dart';
import '../widgets/animated_title.dart';
import '../widgets/feature_card.dart';
import 'camera_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const AnimatedTitle(),
                    const SizedBox(height: 16),
                    Text(
                      'Advanced AI-Powered Face Recognition',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 60),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            FeatureCard(
                              icon: Icons.face,
                              title: 'Face Detection',
                              description: 'Detect and analyze facial features in real-time',
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
                              ),
                              delay: 0,
                            ),
                            const SizedBox(height: 20),
                            FeatureCard(
                              icon: Icons.sentiment_satisfied_alt,
                              title: 'Emotion Recognition',
                              description: 'Identify emotions and facial expressions',
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6B9D), Color(0xFFC44569)],
                              ),
                              delay: 200,
                            ),
                            const SizedBox(height: 20),
                            FeatureCard(
                              icon: Icons.remove_red_eye,
                              title: 'Eye Tracking',
                              description: 'Track eye movements and blink detection',
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                              ),
                              delay: 400,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildStartButton(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CameraScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(30),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Text(
                  'Start Recognition',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
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
