import SwiftUI
import FinderSync

struct SandboxAccessView: View {
    
    @ObservedObject private var debugFlagProvider = DebugFlagProvider()

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                SMJobBlessCheckpointView()
                FinderExtensionCheckpointView()
                PlugInFullDiskAccessCheckPointView()
                FoldersSelectionCheckpointView()
                
                if debugFlagProvider.debugIsEnabled {
                    DebugCheckpointView()
                }
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
