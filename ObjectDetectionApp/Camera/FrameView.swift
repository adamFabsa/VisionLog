import SwiftUI
#if os(macOS)
import AppKit
#endif

struct FrameView: View {
    var image: CGImage?

    var body: some View {
        if let cgImage = image {
            #if os(macOS)
            let nsImage = NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
            Image(nsImage: nsImage)
                .resizable()
                .scaledToFit()
            #else
            Image(decorative: cgImage, scale: 1.0, orientation: .up)
                .resizable()
                .scaledToFit()
            #endif
        } else {
            Color.black
        }
    }
}

#Preview {
    FrameView(image: nil)
}
