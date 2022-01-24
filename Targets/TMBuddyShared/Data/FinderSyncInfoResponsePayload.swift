import Foundation

extension UserDefaults {
        
    static private let key = DefaultsKey.finderSyncInfoResponsePayload
    static private let encodingKey = DefaultsKey.finderSyncInfoResponsePayloadEncoding
    
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
    
    var finderSyncInfoResponsePayload: Any? {
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
