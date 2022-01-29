import SwiftUI

struct DebugCheckpointView: View {
    
    var body: some View {
        CheckpointView(title: "Debug", subtitle: nil, value: "enabled", readiness: .ready) {
            Button("Crash") {
                let numbers = [0]
                let _ = numbers[1]
            }
        }
    }
}
