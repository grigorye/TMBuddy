import SwiftUI

struct DebugCheckpointView: View {

    struct State {}
    
    let state: State
    var actions: DebugCheckpointActions!
    
    var body: some View {
        CheckpointView(title: "Debug", subtitle: nil, value: "enabled", readiness: .ready) {
            Button("Crash") {
                actions.crash()
            }
        }
    }
}
