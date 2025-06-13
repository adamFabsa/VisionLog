import SwiftUI

struct StartMenuView: View {
    @ObservedObject var appState = AppState.shared

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Text("VisionLog")
                .font(.largeTitle)
                .bold()

            Text("AI-powered object detection and cloud tracking")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: {
                withAnimation {
                    appState.hasStarted = true
                }
            }) {
                Text("Start")
                    .font(.title2)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle()) 

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.windowBackgroundColor))
    }
}
