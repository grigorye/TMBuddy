import AppKit
import UniformTypeIdentifiers

extension NSItemProvider {
    
    // Workaround for https://forums.swift.org/t/loaditem-on-nsitemprovider-how-to-avoid-sendable-warnings/63206
    @available(macOS 11.0, *)
    func loadData(for type: UTType) async throws -> Data {
        guard let data = try await loadItem(forTypeIdentifier: type.identifier/*, options: nil*/) as? Data else {
            enum Error: Swift.Error {
                case dataIsNotExtractable(UTType)
            }
            throw Error.dataIsNotExtractable(type)
        }
        return data
    }
}
