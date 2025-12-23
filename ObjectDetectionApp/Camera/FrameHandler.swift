import AVFoundation
import CoreImage
import Vision
import FirebaseFirestore
import SwiftUI
import UserNotifications
#if os(macOS)
import AppKit
#endif

class FrameHandler: NSObject, ObservableObject {
    @Published var frame: CGImage?
    @Published var detectedObjects: Set<String> = []
    @Published var isPaused: Bool = false

    private var permissionGranted = false
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()
    private var frameCount = 0
    private var detectionCount: [String: Int] = [:]

    override init() {
        super.init()
        checkPermission()
        requestNotificationPermission()
    }

    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
            startCamera()
        case .notDetermined:
            requestPermission()
        default:
            permissionGranted = false
        }
    }

    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.permissionGranted = granted
                if granted { self.startCamera() }
            }
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("❌ Notification permission error: \(error.localizedDescription)")
            } else {
                print("✅ Notification permission granted: \(granted)")
            }
        }
    }

    private func startCamera() {
        guard permissionGranted else { return }

        sessionQueue.async { [unowned self] in
            self.setupCaptureSession()
            DispatchQueue.main.async {
                self.captureSession.startRunning()
            }
        }
    }

    private func setupCaptureSession() {
        guard permissionGranted else { return }

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "samplebufferQueue"))

        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoDeviceInput),
              captureSession.canAddOutput(videoOutput) else { return }

        captureSession.addInput(videoDeviceInput)
        captureSession.addOutput(videoOutput)
    }

    func togglePause() {
        if isPaused {
            captureSession.startRunning()
        } else {
            captureSession.stopRunning()
        }
        isPaused.toggle()
    }
}

extension FrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        frameCount += 1
        if frameCount % 3 != 0 { return }

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("❌ Failed to extract image buffer from frame!")
            return
        }

        YoloV3Model.shared.detectObjects(in: pixelBuffer) { results in
            DispatchQueue.main.async {
                for observation in results {
                    let label = observation.labels.first?.identifier ?? "Unknown"
                    let confidence = observation.labels.first?.confidence ?? 0.0
                    let objectName = "\(label) - \(Int(confidence * 100))%"

                    self.detectionCount[label, default: 0] += 1
                    let count = self.detectionCount[label] ?? 0
                    if count == 3 {
                        self.sendNotification(for: label, count: count)
                    }

                    if !self.detectedObjects.contains(label) {
                        self.detectedObjects.insert(label)
                        print("✅ New detection: \(objectName)")

                        if let cgImage = self.imageFromSampleBuffer(sampleBuffer: sampleBuffer) {
                            self.uploadImageToFirestoreBase64(image: cgImage, objectName: label)
                        }
                    }
                }
            }
        }

        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
        DispatchQueue.main.async { self.frame = cgImage }
    }

    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        return context.createCGImage(ciImage, from: ciImage.extent)
    }

    private func sendNotification(for object: String, count: Int) {
        let message = "\(count) \(object)s detected!"
        let content = UNMutableNotificationContent()
        content.title = "🔥 Frequent Detection"
        content.body = message
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notification Error: \(error.localizedDescription)")
            } else {
                NotificationManager.shared.add(message)
                print("✅ Notification sent for \(object)")
            }
        }
    }


    private func uploadImageToFirestoreBase64(image: CGImage, objectName: String) {
        #if os(macOS)
        let bitmapRep = NSBitmapImageRep(cgImage: image)
        guard let imageData = bitmapRep.representation(using: .jpeg, properties: [.compressionFactor: 0.5]) else {
            print("❌ Failed to convert image to JPEG data on macOS")
            return
        }
        let base64String = imageData.base64EncodedString()

        let db = Firestore.firestore()
        let timestamp = Date().timeIntervalSince1970
        let documentData: [String: Any] = [
            "object": objectName,
            "timestamp": timestamp,
            "imageBase64": base64String
        ]

        db.collection("detections").addDocument(data: documentData) { error in
            if let error = error {
                print("❌ Firestore Upload Error: \(error.localizedDescription)")
            } else {
                print("✅ Firestore Upload Saved")
            }
        }
        #endif
    }
}
