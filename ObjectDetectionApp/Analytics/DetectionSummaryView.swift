import SwiftUI
import FirebaseFirestore

struct DetectionSummaryView: View {
    @State private var total = 0
    @State private var topObject = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("📊 Detection Summary")
                .font(.largeTitle)
                .bold()

            Text("Total Detections: \(total)")
                .font(.title2)

            Text("Most Frequent Object: \(topObject)")
                .font(.title3)

            Button("Refresh") {
                fetchSummary()
            }
            .padding(.top)
        }
        .padding()
        .onAppear {
            fetchSummary()
        }
    }

    private func fetchSummary() {
        let db = Firestore.firestore()
        db.collection("detections").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }

            var freq: [String: Int] = [:]
            for doc in documents {
                let data = doc.data()
                if let obj = data["object"] as? String {
                    freq[obj, default: 0] += 1
                }
            }

            let sorted = freq.sorted { $0.value > $1.value }
            DispatchQueue.main.async {
                self.total = documents.count
                self.topObject = sorted.first?.key ?? "None"
            }
        }
    }
}
