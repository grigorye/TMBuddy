import SwiftUI

struct SandboxAccessView: View {
    
    struct State {
        var showPostInstall: Bool
        var showDebug: Bool
    }
    
    let state: State
    var actions: ()?

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                FolderSelectionCheckpointView.new()

                Divider()
                
                SMJobBlessCheckpointView.new()
                if state.showPostInstall {
                    PostInstallHelperCheckpointView.new()
                } else {
                    EmptyView()
                }
                FinderSyncExtensionCheckpointView.new()
                PlugInFullDiskAccessCheckpointView.new()
                
                if state.showDebug {
                    DebugCheckpointView.new()
                }
            }
            .padding([.vertical], 4)
        }
    }
}

struct SandboxAccessView_Previews : PreviewProvider {
    static var previews: some View {
        SandboxAccessView(state: .init(showPostInstall: true, showDebug: true))
            .padding()
    }
}

private let defaults = UserDefaults.standard
