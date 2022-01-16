import Foundation

extension UserDefaults {
    
    func data<DefaultsKey>(forKey key: DefaultsKey) -> Data?
    where DefaultsKey: RawRepresentable, DefaultsKey.RawValue == String
    {
        data(forKey: key.rawValue)
    }
    
    func bool<DefaultsKey>(forKey key: DefaultsKey) -> Bool
    where DefaultsKey: RawRepresentable, DefaultsKey.RawValue == String
    {
        bool(forKey: key.rawValue)
    }

    func array<DefaultsKey>(forKey key: DefaultsKey) -> [Data]?
    where DefaultsKey: RawRepresentable, DefaultsKey.RawValue == String
    {
        array(forKey: key.rawValue) as? [Data]
    }

    func set<DefaultsKey>(_ data: Data?, forKey key: DefaultsKey)
    where DefaultsKey: RawRepresentable, DefaultsKey.RawValue == String
    {
        set(data, forKey: key.rawValue)
    }
    
    func set<DefaultsKey>(_ data: [Data]?, forKey key: DefaultsKey)
    where DefaultsKey: RawRepresentable, DefaultsKey.RawValue == String
    {
        set(data as [NSData]?, forKey: key.rawValue)
    }
}
