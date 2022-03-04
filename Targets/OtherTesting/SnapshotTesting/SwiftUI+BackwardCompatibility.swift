import SwiftUI

extension View {
    
    // Borrowed from https://www.swiftbysundell.com/articles/backgrounds-and-overlays-in-swiftui/
    @available(macOS, deprecated: 12.0, message: "Use the built-in API instead")
    func overlay<T: View>(
        @ViewBuilder content: () -> T
    ) -> some View {
        overlay(Group(content: content))
    }
}
