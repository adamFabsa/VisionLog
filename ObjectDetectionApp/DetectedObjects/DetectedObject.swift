import Foundation

struct DetectedObject: Identifiable {
    let id: String
    let name: String
    let timestamp: Date
    let imageBase64: String?
}
