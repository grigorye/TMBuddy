import SwiftUI

struct FolderSelectionCheckpointView: View {
    
    struct State {
        let bookmarkCount: Int
    }
    
    let state: State
    let actions: FolderSelectionCheckpointActions?
    
    var body: some View {
        let bookmarkCount = state.bookmarkCount
        
        CheckpointView(
            title: "Folders selected",
            subtitle: "\(appName) is enabled only in the selected folders (and any folders inside).",
            value: bookmarkCount > 0 ? "\(bookmarkCount)" : "none",
            readiness: (bookmarkCount > 0) ? .ready : .blocked
        ) {
            VStack(alignment: .leading) {
                HStack {
                    Button(bookmarkCount > 0 ? "Add More Folders" : "Select Folders") {
                        actions?.selectFolders()
                    }
                    if bookmarkCount > 0 {
                        Button("Clear Selection") {
                            actions?.revokeAccess()
                        }
                    }
                }
            }
        }
        .onVisibilityChange(perform: actions?.trackVisibility)
    }
}
