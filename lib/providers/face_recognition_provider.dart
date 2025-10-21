import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import '../models/face_data.dart';

class FaceRecognitionProvider extends ChangeNotifier {
  List<CameraDescription>? _cameras;
  CameraController? _cameraController;
  bool _isInitialized = false;
  bool _isDetecting = false;
  List<FaceData> _detectedFaces = [];
  String _statusMessage = 'Ready to detect faces';

  List<CameraDescription>? get cameras => _cameras;
  CameraController? get cameraController => _cameraController;
  bool get isInitialized => _isInitialized;
  bool get isDetecting => _isDetecting;
  List<FaceData> get detectedFaces => _detectedFaces;
  String get statusMessage => _statusMessage;

  Future<void> initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![1], // Front camera
          ResolutionPreset.high,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );

        await _cameraController!.initialize();
        _isInitialized = true;
        _statusMessage = 'Camera initialized successfully';
        notifyListeners();
      }
    } catch (e) {
      _statusMessage = 'Failed to initialize camera: $e';
      _isInitialized = false;
      notifyListeners();
    }
  }

  void startDetection() {
    _isDetecting = true;
    _statusMessage = 'Detecting faces...';
    notifyListeners();
  }

  void stopDetection() {
    _isDetecting = false;
    _statusMessage = 'Detection stopped';
    notifyListeners();
  }

  void updateDetectedFaces(List<FaceData> faces) {
    _detectedFaces = faces;
    if (faces.isEmpty) {
      _statusMessage = 'No faces detected';
    } else {
      _statusMessage = '${faces.length} face${faces.length > 1 ? 's' : ''} detected';
    }
    notifyListeners();
  }

  void updateStatusMessage(String message) {
    _statusMessage = message;
    notifyListeners();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
