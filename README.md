
![454501879-3cfb4331-0258-4fd5-b8cd-843cae10d583](https://github.com/user-attachments/assets/c5265cfd-45e0-442e-8d66-11ebe9c1d4ea)


VisionLog is a macOS app for real-time object recognition using the Mac’s camera, powered by CoreML and YOLOv3. It stores detection data in Firebase, visualizes trends, and alerts users when specific objects are detected.

---

## Features

-  Real-time object detection using YOLOv3
-  Firebase Firestore integration for storing detections
-  Swift Charts for visualization
-  Smart system notifications on object frequency
-  Custom settings tab (upload, notifications, theme)
-  Unit + UI tests

---

## Built With

- **SwiftUI**
- **CoreML + Vision**
- **Firebase Firestore**
- **AVFoundation** for live camera feed
- **Swift Charts** for visualization

---

## Testing

Press `Cmd + U` to run unit + UI tests:

- `ObjectDetectionAppTests.swift`
- `ObjectDetectionAppUITests.swift`

---

## Installation

1. Clone the repo:
   ```bash
   git clone https://github.com/yourname/VisionLog.git
   cd VisionLog

2. Open the Xcode project:
- `open VisionLog.xcodeproj`

4. Add your Firebase config file:
- `Download GoogleService-Info.plist from Firebase Console`
- `Drag it into your Xcode project`

6. Build and run the app:
- `Cmd + R`
