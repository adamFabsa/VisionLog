import SwiftUI

struct ContentView: View {
    @StateObject private var model = FrameHandler()
    @ObservedObject private var notifications = NotificationManager.shared

    var body: some View {
        TabView {
            ZStack {
                FrameView(image: model.frame)
                    .ignoresSafeArea()

                if let detectedObject = model.detectedObjects.first {
                    let isRecognized = detectedObject.lowercased() != "unknown"
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isRecognized ? Color.green : Color.red, lineWidth: 5)
                        .frame(width: 300, height: 500)
                        .overlay(
                            Text(isRecognized ? detectedObject : "Unknown Object")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(10)
                        )
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            model.togglePause()
                        }) {
                            Image(systemName: model.isPaused ? "play.fill" : "pause.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                                .padding(20)
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .buttonStyle(PlainButtonStyle()) 
                        .shadow(radius: 4)
                        .padding()

                    }
                }
            }
            .tabItem {
                Label("Camera", systemImage: "camera")
            }

            DetectedObjectsView()
                .tabItem {
                    Label("History", systemImage: "list.bullet")
                }

            DetectionChartsView()
                .tabItem {
                    Label("Charts", systemImage: "chart.bar.xaxis")
                }

            DetectionSummaryView()
                .tabItem {
                    Label("Summary", systemImage: "info.circle")
                }
            SettingsTabView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }


            
            Group {
                if notifications.unreadCount > 0 {
                    NotificationTabView()
                        .tabItem {
                            Label("Notifications", systemImage: "bell")
                        }
                        .badge(notifications.unreadCount)
                } else {
                    NotificationTabView()
                        .tabItem {
                            Label("Notifications", systemImage: "bell")
                        }
                }
            }
        }
    }
}
