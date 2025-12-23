import Foundation
import FirebaseFirestore

class DetectionDataManager: ObservableObject {
    @Published var allObjects: [DetectedObject] = []

    private let db = Firestore.firestore()

    func fetchDetectedObjects(filterName: String = "", filterDate: Date? = nil) {
        let query = db.collection("detections").order(by: "timestamp", descending: true)

        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("❌ Error fetching: \(error?.localizedDescription ?? "")")
                return
            }

            let calendar = Calendar.current

            let results = documents.compactMap { doc -> DetectedObject? in
                let data = doc.data()
                guard
                    let name = data["object"] as? String,
                    let timestamp = data["timestamp"] as? Double
                else { return nil }

                let date = Date(timeIntervalSince1970: timestamp)

                if !filterName.isEmpty && !name.lowercased().hasPrefix(filterName.lowercased()) {
                    return nil
                }

                if let filterDate = filterDate,
                   !calendar.isDate(date, inSameDayAs: filterDate) {
                    return nil
                }

                let base64 = data["imageBase64"] as? String

                return DetectedObject(id: doc.documentID, name: name, timestamp: date, imageBase64: base64)
            }

            DispatchQueue.main.async {
                self.allObjects = results
            }
        }
    }
}
