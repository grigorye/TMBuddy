import SwiftUI

extension PlugInFullDiskAccessCheckpointView {
    
    static func new() -> some View {
        ObservableWrapperView(
            PlugInFullDiskAccessCheckpointProvider(),
            FinderSyncExtensionCheckpointProvider()
        ) { fullDiskAccess, finderSync in
            Self(
                state: .init(
                    fullDiskAccess: fullDiskAccess.state,
                    finderSync: finderSync.state
                ),
                actions: PlugInFullDiskAccessCheckpointActionHandler()
            )
        }
    }
}
