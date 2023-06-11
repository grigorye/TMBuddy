import SwiftUI

@available(macOS 11.0, *)
struct FolderListView: View {
    
    init(urls: Binding<[URL]>, selection: Set<URL> = [], urlFromItemProvider: @escaping (NSItemProvider) async throws -> URL) {
        self.selection = selection
        self.urlFromItemProvider = urlFromItemProvider
        self._urls = urls
    }
    
    @Binding var urls: [URL]
    
    @SwiftUI.State var selection: Set<URL> = []
    @SwiftUI.State private var dragOver = false
    
    private let urlFromItemProvider: (NSItemProvider) async throws -> URL
    
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
                for provider in providers {
                    Task {
                        let url = try await urlFromItemProvider(provider)
                        Task { @MainActor in
                            urls += [url]
                        }
                    }
                }
                return true
            }
            .keyboardShortcut(.delete, modifiers: [])
            .onDeleteCommand(perform: {
                self.urls = urls.filter { !selection.contains($0) }
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
