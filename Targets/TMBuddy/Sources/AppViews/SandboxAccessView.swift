import SwiftUI
import FinderSync

struct SandboxAccessView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                FinderExtensionCheckpointView()
                FullDiskAccessCheckpointView()
                FoldersSelectionCheckpointView()
            }
            .padding([.vertical], 4)
        }
    }
}

struct SandboxAccessView_Previews : PreviewProvider {
    static var previews: some View {
        SandboxAccessView()
            .padding()
    }
}
