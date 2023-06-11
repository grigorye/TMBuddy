import SwiftUI

@available(macOS 11.0, *)
struct FolderListView: View {
    
    init(urls: [URL], selection: Set<URL> = [], urlFromItemProvider: @escaping (NSItemProvider) async throws -> URL?, updateURLs: @escaping ([URL]) -> Void) {
        self.urls = urls
        self.selection = selection
        self.urlFromItemProvider = urlFromItemProvider
        self.updateURLs = updateURLs
    }
    
    let urls: [URL]
    
    @SwiftUI.State var selection: Set<URL> = []
    @SwiftUI.State private var dragOver = false
    
    private let urlFromItemProvider: (NSItemProvider) async throws -> URL?
    private let updateURLs: ([URL]) async throws -> Void

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
                        guard let url = try await urlFromItemProvider(provider) else {
                            dump((provider), name: "rejectedItemProvider")
                            return
                        }
                        Task { @MainActor in
                            try await self.updateURLs(urls + [url])
                        }
                    }
                }
                return true
            }
            .keyboardShortcut(.delete, modifiers: [])
            .onDeleteCommand(perform: {
                Task {
                    try await updateURLs(urls.filter { !selection.contains($0) })
                }
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
