# VisionLog


<img width="1563" height="1030" alt="visionlog" src="https://github.com/user-attachments/assets/cb598c1c-c9bf-4d58-8f70-f90fa2fcdd45" />



VisionLog is a macOS app for real-time object recognition using the Mac’s camera, powered by CoreML and YOLOv3. It stores detection data in Firebase, visualizes trends, and alerts users when specific objects are detected.

---

## Demo

-  Demo Link:
-  https://drive.google.com/file/d/17Znwkgum5uUoUCftYOmWodKoqgcnzmzE/preview

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
