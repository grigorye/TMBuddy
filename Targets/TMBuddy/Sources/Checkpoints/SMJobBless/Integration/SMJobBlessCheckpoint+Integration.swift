import SwiftUI

extension SMJobBlessCheckpointView {
    
    @MainActor
    static func new() -> some View {
        ObservableWrapperView(SMJobBlessCheckpointProvider()) { bless in
            Self(
                state: bless.state,
                actions: SMJobBlessCheckpointActionHandler()
            )
        }
    }
}
