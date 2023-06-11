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
        FolderListView(urls: urlProvider.urls, handleFileDrop: handleFileDrop(providers:), removeURLs: removeURLs)
    }
}

@available(macOS 11.0, *)
@MainActor
func urlFromItemProvider(_ provider: NSItemProvider) async throws -> URL? {
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
    guard url.isDirectory() else {
        return nil
    }
    return url
}

extension URL {
    func isDirectory() -> Bool {
        do {
            return try resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true
        } catch {
            dump((error, path: self.path), name: "isDirectoryValueFailed")
            return false
        }
    }
}

@available(macOS 11.0, *)
@MainActor
func handleFileDrop(providers: [NSItemProvider]) -> Bool {
    for provider in providers {
        Task {
            guard let url = try await urlFromItemProvider(provider) else {
                dump((provider), name: "rejectedItemProvider")
                return
            }
            Task { @MainActor in
                addURLs([url])
            }
        }
    }
    return true
}
