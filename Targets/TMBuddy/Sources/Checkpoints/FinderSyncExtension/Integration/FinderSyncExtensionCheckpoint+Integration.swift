import SwiftUI

extension FinderSyncExtensionCheckpointView {
    
    static func new() -> some View {
        ObservableWrapperView(FinderSyncExtensionCheckpointProvider()) { finderSync in
            Self(state: finderSync.state) ≈ {
                $0.actions = FinderSyncExtensionCheckpointActionsHandler()
            }
        }
    }
}
