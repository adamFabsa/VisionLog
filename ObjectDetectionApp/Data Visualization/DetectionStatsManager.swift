import Foundation
import FirebaseFirestore

struct ObjectFrequency: Identifiable {
    let id = UUID()
    let object: String
    let count: Int
}

struct DailyCount: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

class DetectionStatsManager: ObservableObject {
    @Published var frequencies: [ObjectFrequency] = []
    @Published var dailyCounts: [DailyCount] = []

    private let db = Firestore.firestore()

    func fetchStatistics() {
        db.collection("detections").getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }

            var objectMap: [String: Int] = [:]
            var dateMap: [Date: Int] = [:]
            let calendar = Calendar.current

            for doc in docs {
                let data = doc.data()
                guard
                    let object = data["object"] as? String,
                    let timestamp = data["timestamp"] as? Double
                else { continue }

                objectMap[object, default: 0] += 1

                let date = calendar.startOfDay(for: Date(timeIntervalSince1970: timestamp))
                dateMap[date, default: 0] += 1
            }

            DispatchQueue.main.async {
                self.frequencies = objectMap.map { ObjectFrequency(object: $0.key, count: $0.value) }
                    .sorted { $0.count > $1.count }

                self.dailyCounts = dateMap.map { DailyCount(date: $0.key, count: $0.value) }
                    .sorted { $0.date < $1.date }
            }
        }
    }
}
