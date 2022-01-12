import Foundation

extension UserDefaults {
    
    func data(forKey key: DefaultsKey) -> Data? {
        data(forKey: key.rawValue)
    }
    
    func array(forKey key: DefaultsKey) -> [Data]? {
        array(forKey: key.rawValue) as? [Data]
    }

    func set(_ data: Data?, forKey key: DefaultsKey) {
        set(data, forKey: key.rawValue)
    }
    
    func set(_ data: [Data]?, forKey key: DefaultsKey) {
        set(data as [NSData]?, forKey: key.rawValue)
    }
}
