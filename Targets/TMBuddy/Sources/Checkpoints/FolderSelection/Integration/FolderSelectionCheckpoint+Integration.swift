import SwiftUI

extension FolderSelectionCheckpointView {
    
    static func new() -> some View {
        ObservableWrapperView(BookmarkCountProvider()) { bookmarks in
            Self(
                state: .init(bookmarkCount: bookmarks.bookmarkCount),
                actions: FolderSelectionCheckpointActionsActionHandler()
            )
        }
    }
}
