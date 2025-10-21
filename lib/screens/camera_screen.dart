import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import '../providers/face_recognition_provider.dart';
import '../services/face_detector_service.dart';
import '../widgets/face_detector_painter.dart';
import '../widgets/gradient_background.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  final FaceDetectorService _faceDetectorService = FaceDetectorService();
  bool _isDetecting = false;
  List<Face> _faces = [];
  Size? _imageSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final provider = Provider.of<FaceRecognitionProvider>(context, listen: false);
    await provider.initializeCamera();

    if (provider.isInitialized) {
      provider.cameraController!.startImageStream(_processCameraImage);
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;

    try {
      final faces = await _faceDetectorService.detectFaces(image);

      setState(() {
        _faces = faces;
        _imageSize = Size(
          image.width.toDouble(),
          image.height.toDouble(),
        );
      });

      final provider = Provider.of<FaceRecognitionProvider>(context, listen: false);
      if (faces.isEmpty) {
        provider.updateStatusMessage('No faces detected');
      } else {
        provider.updateStatusMessage('${faces.length} face${faces.length > 1 ? 's' : ''} detected');
      }
    } catch (e) {
      debugPrint('Error processing image: $e');
    }

    _isDetecting = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final provider = Provider.of<FaceRecognitionProvider>(context, listen: false);
    provider.cameraController?.stopImageStream();
    _faceDetectorService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FaceRecognitionProvider>(
        builder: (context, provider, child) {
          if (!provider.isInitialized || provider.cameraController == null) {
            return const GradientBackground(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Initializing camera...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }

          return Stack(
            children: [
              _buildCameraPreview(provider.cameraController!),
              _buildFaceOverlay(),
              _buildTopBar(context, provider),
              _buildBottomInfo(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCameraPreview(CameraController controller) {
    final size = MediaQuery.of(context).size;
    final scale = size.aspectRatio * controller.value.aspectRatio;

    return Transform.scale(
      scale: scale < 1 ? 1 / scale : scale,
      child: Center(
        child: CameraPreview(controller),
      ),
    );
  }

  Widget _buildFaceOverlay() {
    if (_faces.isEmpty || _imageSize == null) return const SizedBox();

    return CustomPaint(
      painter: FaceDetectorPainter(
        faces: _faces,
        imageSize: _imageSize!,
      ),
      child: Container(),
    );
  }

  Widget _buildTopBar(BuildContext context, FaceRecognitionProvider provider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomInfo(FaceRecognitionProvider provider) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.face, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      provider.statusMessage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (_faces.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildFaceStats(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaceStats() {
    if (_faces.isEmpty) return const SizedBox();

    final face = _faces.first;
    final smiling = (face.smilingProbability ?? 0) > 0.5;
    final leftEyeOpen = (face.leftEyeOpenProbability ?? 0) > 0.5;
    final rightEyeOpen = (face.rightEyeOpenProbability ?? 0) > 0.5;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: smiling ? Icons.sentiment_satisfied_alt : Icons.sentiment_neutral,
            label: smiling ? 'Smiling' : 'Neutral',
            color: smiling ? Colors.green : Colors.blue,
          ),
          _buildStatItem(
            icon: Icons.remove_red_eye,
            label: 'Eyes ${leftEyeOpen && rightEyeOpen ? 'Open' : 'Closed'}',
            color: leftEyeOpen && rightEyeOpen ? Colors.green : Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
