import Foundation

extension UserDefaults {
    
    static private let payloadKey = DefaultsKey.finderSyncInfoResponsePayload
    
    private var responseHeader: FinderSyncInfoResponseHeader? {
        guard let payload = self.finderSyncInfoResponsePayload else {
            return nil
        }
        do {
            let responseHeader = try JSONDecoder().decode(FinderSyncInfoResponseHeader.self, from: payload)
            return responseHeader
        } catch {
            dump((error: error, payload: payload), name: "payloadDecodingFailure")
            return nil
        }
    }
    
    var finderSyncInfoResponseIndex: Int {
        get {
            guard let responseHeader = self.responseHeader else {
                return 0
            }
            return responseHeader.index
        }
    }
}
