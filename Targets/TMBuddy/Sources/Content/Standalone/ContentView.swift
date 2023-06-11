import SwiftUI
import Foundation

struct ContentView: View {
    
    enum Tab: String {
        case setup
        case folders
        case legend
    }
    
    @SwiftUI.State var selection: Tab = .setup
    
    var body: some View {
        if #available(macOS 11.0, *) {
            TabView(selection: $selection) {
                SandboxAccessView.new()
                    .tabItem {
                        Text("Setup")
                    }
                    .padding()
                    .tag(Tab.setup)
                
                FoldersTab.new()
                    .tabItem {
                        Text("Folders")
                    }
                    .padding()
                    .tag(Tab.folders)

                LegendView.new()
                    .frame(minHeight: 240)
                    .tabItem {
                        Text("Legend")
                    }
                    .tag(Tab.legend)
            }
            .padding()
            .frame(width: 640)
        } else {
            VStack(alignment: .leading) {
                VStack {
                    GroupBox {
                        SandboxAccessView.new()
                            .padding()
                    }
                }.frame(maxWidth: 640)
                
                VStack(alignment: .leading) {
                    Text("Legend")
                    GroupBox() {
                        LegendView.new()
                            .padding()
                    }
                }
            }
            .padding()
        }
    }
}

struct FoldersTab: View {
    
    static func new() -> some View {
        self.init()
    }

    var body: some View {
        VStack(alignment: .leading) {
            FolderSelectionCheckpointView.new()
            if #available(macOS 11.0, *) {
                Spacer().padding(.bottom)
                FolderListView.new()
            }
        }
    }
}

extension ContentView.Tab: CaseIterable {}
