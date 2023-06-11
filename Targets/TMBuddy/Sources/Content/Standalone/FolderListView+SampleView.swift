import SwiftUI

@available(macOS 11.0, *)
extension FolderListView {
    static func new() -> some View {
        Self(
            urls: .constant([
                URL(fileURLWithPath: "/"),
                FileManager.default.homeDirectory(forUser: "admin") ?? URL(fileURLWithPath: "/tmp")
            ]),
            urlFromItemProvider: { _ in fatalError() }
        )
    }
}
