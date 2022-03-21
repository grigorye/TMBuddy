import SwiftUI

struct SandboxAccessView: View {
    
    struct State {
        var showPostSMJobBless: Bool
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
                
                #if GE_BLESS
                if state.showPostSMJobBless {
                    SMJobBlessCheckpointView.new()
                    if state.showPostInstall {
                        PostInstallHelperCheckpointView.new()
                    }
                }
                #endif
                FinderSyncExtensionCheckpointView.new()
                PlugInFullDiskAccessCheckpointView.new()
                
                Divider()

                if state.showDebug {
                    DebugCheckpointView.new()
                }
                AnalyticsCheckpointView.new()
            }
            .padding([.vertical], 4)
        }
    }
}

struct SandboxAccessView_Previews : PreviewProvider {
    
    static var previews: some View {
        SandboxAccessView(
            state: .init(
                showPostSMJobBless: true,
                showPostInstall: true,
                showDebug: true
            )
        )
            .padding()
    }
}

private let defaults = UserDefaults.standard
