import FinderSync
import SwiftUI

struct FinderExtensionCheckpointView: View {
    
    @ObservedObject var extensionStatusProvider = FinderSyncExtensionStatusProvider()
    
    var body: some View {
        let isExtensionEnabled = extensionStatusProvider.isEnabled
        
        CheckpointView(
            title: "Finder extension",
            subtitle: nil,
            value: isExtensionEnabled ? "enabled": "disabled",
            completed: isExtensionEnabled
        ) {
            VStack(alignment: .leading) {
                Button("Extensions Settings") {
                    FIFinderSyncController.showExtensionManagementInterface()
                }
            }
        }
    }
}
