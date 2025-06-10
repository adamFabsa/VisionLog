import CoreML
import Vision
import CoreImage

class YoloV3Model {
    static let shared = YoloV3Model()

    private var model: VNCoreMLModel?

    private init() {
        loadModel()
    }

    private func loadModel() {
        do {
            let yoloModel = try YOLOv3(configuration: MLModelConfiguration()) // Load YOLOv3 model
            model = try VNCoreMLModel(for: yoloModel.model)
            print("✅ YOLOv3 Model Loaded Successfully!")
        } catch {
            print("❌ ERROR: Failed to load YOLOv3 Model - \(error)")
        }
    }

    func detectObjects(in image: CVPixelBuffer, completion: @escaping ([VNRecognizedObjectObservation]) -> Void) {
        guard let model = model else {
            print("❌ YOLOv3 model not loaded!")
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation], !results.isEmpty else {
                print("❌ No objects detected!")
                return
            }

            for observation in results {
                let label = observation.labels.first?.identifier ?? "Unknown"
                let confidence = observation.labels.first?.confidence ?? 0.0
                print("🟢 YOLOv3 Detected: \(label) - \(confidence * 100)% confidence")
            }

            completion(results)
        }

        request.imageCropAndScaleOption = .scaleFill

        let handler = VNImageRequestHandler(cvPixelBuffer: image, options: [:])

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("❌ Error performing YOLO request: \(error)")
            }
        }
    }
}
