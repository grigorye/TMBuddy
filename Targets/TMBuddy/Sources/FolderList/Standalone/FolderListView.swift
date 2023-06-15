import SwiftUI

@available(macOS 11.0, *)
struct FolderListView: View {
    
    init(urls: [URL], selection: Set<URL> = [], handleFileDrop: @escaping ([NSItemProvider]) -> Bool, removeURLs: @escaping ([URL]) -> Void) {
        self.urls = urls
        self.selection = selection
        self.handleFileDrop = handleFileDrop
        self.removeURLs = removeURLs
    }
    
    let urls: [URL]
    
    @SwiftUI.State var selection: Set<URL> = []
    @SwiftUI.State private var dragOver = false
    
    private let handleFileDrop: ([NSItemProvider]) -> Bool
    private let removeURLs: ([URL]) -> Void

    var body: some View {
        VStack() {
            List(urls, id: \.self, selection: $selection) { url in
                let v = try? url.resourceValues(forKeys: [.localizedNameKey, .effectiveIconKey])
                HStack {
                    if let icon = v?.effectiveIcon as? NSImage {
                        Image(nsImage: icon)
                    } else {
                        Image(nsImage: NSWorkspace().icon(for: .volume))
                    }
                    Text(v?.localizedName ?? url.lastPathComponent)
                        .id(url)
                }
            }
            .onDrop(of: [.fileURL], isTargeted: $dragOver) { providers -> Bool in
                self.handleFileDrop(providers)
            }
            .keyboardShortcut(.delete, modifiers: [])
            .onDeleteCommand(perform: {
                self.removeURLs(Array(selection))
            })
            .frame(minHeight: 200, maxHeight: .infinity)
            .border(dragOver ? Color.accentColor : Color.clear)
            .listStyle({ () -> InsetListStyle in
                if #available(macOS 12.0, *) {
                    return .inset(alternatesRowBackgrounds: true)
                } else {
                    return .inset
                }
            }())
        }
    }
}
