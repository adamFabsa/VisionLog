import SwiftUI

struct NotificationTabView: View {
    @ObservedObject var manager = NotificationManager.shared

    var body: some View {
        VStack {
            HStack {
                Text("🔔 Notifications")
                    .font(.title2)
                Spacer()
                if manager.unreadCount > 0 {
                    Button("Mark All as Read") {
                        manager.markAllAsRead()
                    }
                }
            }
            .padding()

            if manager.notifications.isEmpty {
                Spacer()
                Text("No notifications yet.")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                List(manager.notifications) { notif in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(notif.message)
                            .fontWeight(notif.isRead ? .regular : .bold)
                        Text(notif.timestamp.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
    }
}
