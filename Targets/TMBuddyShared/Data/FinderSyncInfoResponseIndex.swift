import Foundation

extension UserDefaults {
    
    static private let payloadKey = DefaultsKey.finderSyncInfoResponsePayload
    
    private var responseHeader: FinderSyncInfoResponseHeader? {
        guard let payload = self.finderSyncInfoResponsePayload else {
            return nil
        }
        do {
            let responseHeader = try PropertyListDecoder().decode(FinderSyncInfoResponseHeader.self, from: dataFromPlist(payload))
            return responseHeader
        } catch {
            dump((error: error, payload: payload), name: "payloadDecodingFailed")
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
