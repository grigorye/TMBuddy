import SwiftUI

extension SMJobBlessCheckpointView {
    
    static func new() -> some View {
        ObservableWrapperView(SMJobBlessCheckpointProvider()) { bless in
            Self(state: bless.state) ≈ {
                $0.actions = SMJobBlessCheckpointActionHandler()
            }
        }
    }
}
