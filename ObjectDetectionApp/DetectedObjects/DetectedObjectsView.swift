import SwiftUI

struct DetectedObjectsView: View {
    @StateObject private var manager = DetectionDataManager()
    @State private var filterName = ""
    @State private var filterDate: Date? = nil

    var body: some View {
        VStack {
            HStack {
                TextField("Search object", text: $filterName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 200)

                DatePicker("Date", selection: Binding(
                    get: { filterDate ?? Date() },
                    set: { newDate in filterDate = newDate }
                ), displayedComponents: .date)
                .labelsHidden()

                Button("Clear") {
                    filterName = ""
                    filterDate = nil
                    manager.fetchDetectedObjects()
                }

                Button("Refresh") {
                    manager.fetchDetectedObjects(filterName: filterName, filterDate: filterDate)
                }
            }
            .padding()
            .onChange(of: filterName) {
                manager.fetchDetectedObjects(filterName: filterName, filterDate: filterDate)
            }
            .onChange(of: filterDate) {
                manager.fetchDetectedObjects(filterName: filterName, filterDate: filterDate)
            }

            List(manager.allObjects) { obj in
                HStack(alignment: .top) {
                    if let base64 = obj.imageBase64,
                       let imageData = Data(base64Encoded: base64),
                       let nsImage = NSImage(data: imageData) {
                        Image(nsImage: nsImage)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .cornerRadius(5)
                    }

                    VStack(alignment: .leading) {
                        Text(obj.name)
                            .font(.headline)
                        Text(obj.timestamp.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .onAppear {
            manager.fetchDetectedObjects()
        }
    }
}
