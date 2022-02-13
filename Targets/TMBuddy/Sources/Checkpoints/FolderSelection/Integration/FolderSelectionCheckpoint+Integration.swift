import SwiftUI

extension FolderSelectionCheckpointView {
    
    static func new() -> some View {
        ObservableWrapperView(BookmarkCountProvider()) { bookmarks in
            Self(state: .init(bookmarkCount: bookmarks.bookmarkCount)) ≈ {
                $0.actions = FolderSelectionCheckpointActionsActionHandler()
            }
        }
    }
}
