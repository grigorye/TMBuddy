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

private let defaults = UserDefaults.standard
