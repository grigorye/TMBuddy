import SwiftUI

struct CheckpointView_Previews : PreviewProvider {
    
    static var previews: some View {
        CheckpointView(
            title: .verbatim("Title"),
            subtitle: .verbatim("Subtitle"),
            value: .verbatim("Value"),
            readiness: .ready
        ) {
            Text(.verbatim("Content"))
        }
        .frame(width: sampleCheckpointWidth, alignment: .leading)
    }
}
