import SwiftUI

@available(macOS 11.0, *)
extension FolderListView: View {
    
    @MainActor
    static func new() -> some View {
        IntegratedFolderListView()
    }
}

@available(macOS 11.0, *)
struct IntegratedFolderListView: View {
    @StateObject var urlProvider = BookmarkedURLProvider()

    var body: some View {
        FolderListView(urls: urlProvider.urls, urlFromItemProvider: urlFromItemProvider, updateURLs: processURLs)
    }
}

@available(macOS 11.0, *)
@MainActor
func urlFromItemProvider(_ provider: NSItemProvider) async throws -> URL {
    let data = try await provider.loadData(for: .fileURL)
    guard let path = String(data: data, encoding: .utf8) else {
        enum Error: Swift.Error {
            case dataNotConvertible(Data)
        }
        throw Error.dataNotConvertible(data)
    }
    guard let url = URL(string: path) else {
        enum Error: Swift.Error {
            case pathNotConvertible(String)
        }
        throw Error.pathNotConvertible(path)
    }
    return url
}
