import Foundation
import Combine

class AppSettings: ObservableObject {
    static let shared = AppSettings()

    @Published var uploadEnabled: Bool {
        didSet { UserDefaults.standard.set(uploadEnabled, forKey: "uploadEnabled") }
    }

    @Published var notificationsEnabled: Bool {
        didSet { UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled") }
    }

    private init() {
        self.uploadEnabled = UserDefaults.standard.bool(forKey: "uploadEnabled")
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
    }
}
