import SwiftUI

struct SettingsTabView: View {
    @ObservedObject private var settings = AppSettings.shared

    var body: some View {
        Form {
            Section(header: Text("Cloud & Notifications")) {
                Toggle("Enable Cloud Uploads", isOn: $settings.uploadEnabled)
                Toggle("Enable Notifications", isOn: $settings.notificationsEnabled)
            }

            Section {
                Text("Changes are saved automatically.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: 500)
        .navigationTitle("Settings")
    }
}
