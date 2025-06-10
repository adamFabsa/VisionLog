import Foundation

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var hasStarted: Bool = false
}
