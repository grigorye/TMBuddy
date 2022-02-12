import SwiftUI

extension DebugCheckpointView {
    
    static func new() -> some View {
        ObservableWrapperView {
            Self(state: .init()) ≈ {
                $0.actions = DebugCheckpointActionsHandler()
            }
        }
    }
}
