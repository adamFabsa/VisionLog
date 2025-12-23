import Foundation
import Combine

struct AppNotification: Identifiable {
    let id = UUID()
    let message: String
    let timestamp: Date
    var isRead: Bool = false
}

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published var notifications: [AppNotification] = []

    var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }

    func add(_ message: String) {
        let newNotification = AppNotification(message: message, timestamp: Date())
        DispatchQueue.main.async {
            self.notifications.insert(newNotification, at: 0)
        }
    }

    func markAllAsRead() {
        DispatchQueue.main.async {
            self.notifications = self.notifications.map {
                var updated = $0
                updated.isRead = true
                return updated
            }
        }
    }
}
