import Foundation

extension UserDefaults {
        
    static private let key = DefaultsKey.finderSyncInfoRequestPayload
    static private let encodingKey = DefaultsKey.finderSyncInfoRequestPayloadEncoding

    private var expectedEncoding: String {
        "plist"
    }
    
    private var encoding: String? {
        get {
            string(forKey: Self.encodingKey)
        }
        set {
            set(newValue, forKey: Self.encodingKey)
        }
    }
    
    var finderSyncInfoRequestPayload: Any? {
        get {
            assert(Self.key.rawValue == #function)
            if encoding != expectedEncoding {
                dump((encoding: encoding, expectedEncoding: expectedEncoding), name: "erasingDueToEncodingMismatch")
                encoding = expectedEncoding
                removeObject(forKey: Self.key)
            }
            return object(forKey: Self.key)
        }
        set {
            set(newValue, forKey: Self.key)
        }
    }
}
