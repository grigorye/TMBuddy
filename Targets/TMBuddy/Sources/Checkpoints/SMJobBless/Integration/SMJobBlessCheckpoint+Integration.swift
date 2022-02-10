import SwiftUI

extension SMJobBlessCheckpointView {
    
    init() {
        self.init(
            checkpointProvider: SMJobBlessCheckpointProvider(),
            actions: SMJobBlessCheckpointActionHandler()
        )
    }
}
