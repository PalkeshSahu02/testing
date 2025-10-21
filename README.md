# Face Recognition App

A beautiful Flutter application for real-time face recognition with advanced AI-powered features.

## Features

- **Real-time Face Detection**: Detect faces in real-time using your device camera
- **Emotion Recognition**: Identify emotions and facial expressions (happy, neutral, sleepy)
- **Eye Tracking**: Track eye movements and detect blinks
- **Beautiful UI**: Modern, gradient-based UI with smooth animations
- **Face Landmarks**: Visualize facial landmarks including eyes, nose, and mouth
- **Live Statistics**: Real-time face analysis with visual feedback

## Technologies Used

- **Flutter**: Cross-platform mobile development framework
- **Google ML Kit**: Face detection and recognition
- **Camera Plugin**: Real-time camera access
- **Provider**: State management
- **Google Fonts**: Beautiful typography
- **Shimmer & Animations**: Smooth UI effects

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Android Studio / Xcode
- A physical device with a camera (recommended for best performance)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd face_recognition_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Permissions

This app requires the following permissions:

- **Camera**: To capture live video for face detection
- **Storage** (Android): To save and load images

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   └── face_data.dart                # Face data model
├── providers/
│   └── face_recognition_provider.dart # State management
├── screens/
│   ├── home_screen.dart              # Home screen with features
│   └── camera_screen.dart            # Camera screen with face detection
├── services/
│   └── face_detector_service.dart    # Face detection service
└── widgets/
    ├── animated_title.dart           # Animated title widget
    ├── face_detector_painter.dart    # Custom painter for face overlay
    ├── feature_card.dart             # Feature card widget
    └── gradient_background.dart      # Gradient background widget
```

## Features in Detail

### Home Screen
- Beautiful gradient background
- Animated title with shimmer effect
- Feature cards showcasing app capabilities
- Smooth page transitions

### Camera Screen
- Real-time face detection
- Face bounding boxes with corner accents
- Facial landmark visualization
- Emotion indicators
- Live statistics display

## Screenshots

The app features:
- Dark theme with gradient backgrounds
- Purple accent colors (#6C63FF)
- Smooth animations and transitions
- Modern, clean UI design

## License

This project is created for demonstration purposes.

## Acknowledgments

- Google ML Kit for face detection
- Flutter team for the amazing framework
- All open-source contributors
