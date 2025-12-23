import SwiftUI

struct RootView: View {
    @ObservedObject private var appState = AppState.shared

    var body: some View {
        Group {
            if appState.hasStarted {
                ContentView()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                StartMenuView()
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState.hasStarted)
    }
}
