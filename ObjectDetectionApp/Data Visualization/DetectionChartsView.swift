import SwiftUI
import Charts

struct DetectionChartsView: View {
    @StateObject private var stats = DetectionStatsManager()

    var body: some View {
        VStack {
            TabView {
                VStack(alignment: .leading) {
                    Text("📦 Detected Object Frequency")
                        .font(.headline)
                        .padding(.top)

                    Chart(stats.frequencies) { item in
                        BarMark(
                            x: .value("Object", item.object),
                            y: .value("Count", item.count)
                        )
                    }
                }
                .padding()
                .tabItem { Label("By Object", systemImage: "chart.bar") }

                VStack(alignment: .leading) {
                    Text("📅 Daily Detections")
                        .font(.headline)
                        .padding(.top)

                    Chart(stats.dailyCounts) { item in
                        LineMark(
                            x: .value("Date", item.date),
                            y: .value("Count", item.count)
                        )
                    }
                }
                .padding()
                .tabItem { Label("By Date", systemImage: "calendar") }
            }
        }
        .onAppear {
            stats.fetchStatistics()
        }
    }
}
