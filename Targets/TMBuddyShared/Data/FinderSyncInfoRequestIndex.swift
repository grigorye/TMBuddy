import Foundation

extension UserDefaults {

    static private let payloadKey = DefaultsKey.finderSyncInfoRequestPayload

    private var requestHeader: FinderSyncInfoRequestHeader? {
        guard let payload = self.finderSyncInfoRequestPayload else {
            return nil
        }
        do {
            let requestHeader = try JSONDecoder().decode(FinderSyncInfoRequestHeader.self, from: payload)
            return requestHeader
        } catch {
            dump((error: error, payload: payload), name: "payloadDecodingFailure")
            return nil
        }
    }
    
    var finderSyncInfoRequestIndex: Int {
        get {
            guard let requestHeader = self.requestHeader else {
                return 0
            }
            return requestHeader.index
        }
    }
}
