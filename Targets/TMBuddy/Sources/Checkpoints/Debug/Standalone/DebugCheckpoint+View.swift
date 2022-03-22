import SwiftUI

struct DebugCheckpointView: View {

    struct State {}
    
    let state: State
    let actions: DebugCheckpointActions?
    
    var body: some View {
        CheckpointView(title: "Debug", subtitle: nil, value: "enabled", readiness: .ready) {
            Button("Crash") {
                actions?.crash()
            }
        }
        .onVisibilityChange(perform: actions?.track(visible:))
    }
}
