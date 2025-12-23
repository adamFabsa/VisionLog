import XCTest
@testable import ObjectDetectionApp

final class ObjectDetectionAppTests: XCTestCase {

    func testPauseToggle() {
        let handler = FrameHandler()
        XCTAssertFalse(handler.isPaused)
        handler.togglePause()
        XCTAssertTrue(handler.isPaused)
        handler.togglePause()
        XCTAssertFalse(handler.isPaused)
    }

    func testNotificationManagerStoresMessages() {
        let manager = NotificationManager.shared
        manager.notifications.removeAll()
        manager.add("Test Alert")
        XCTAssertEqual(manager.notifications.first?.message, "Test Alert")
    }

    func testSettingsPersistence() {
        let settings = AppSettings.shared
        settings.uploadEnabled = false
        settings.notificationsEnabled = true

        XCTAssertEqual(AppSettings.shared.uploadEnabled, false)
        XCTAssertEqual(AppSettings.shared.notificationsEnabled, true)
    }
}
