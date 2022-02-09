import Foundation

extension UserDefaults {
    
    func removeObject<DefaultsKey>(forKey key: DefaultsKey)
    where DefaultsKey: RawRepresentable, DefaultsKey.RawValue == String
    {
        removeObject(forKey: key.rawValue)
    }
    
    func object<DefaultsKey>(forKey key: DefaultsKey) -> Any?
    where DefaultsKey: RawRepresentable, DefaultsKey.RawValue == String
    {
        object(forKey: key.rawValue)
    }
    
    func integer<DefaultsKey>(forKey key: DefaultsKey) -> Int
    where DefaultsKey: RawRepresentable, DefaultsKey.RawValue == String
    {
        integer(forKey: key.rawValue)
    }
    
    func string<DefaultsKey>(forKey key: DefaultsKey) -> String?
    where DefaultsKey: RawRepresentable, DefaultsKey.RawValue == String
    {
        string(forKey: key.rawValue)
    }

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

    func set<DefaultsKey>(_ object: Any?, forKey key: DefaultsKey)
    where DefaultsKey: RawRepresentable, DefaultsKey.RawValue == String
    {
        set(object, forKey: key.rawValue)
    }
    
    func set<DefaultsKey>(_ data: [Data]?, forKey key: DefaultsKey)
    where DefaultsKey: RawRepresentable, DefaultsKey.RawValue == String
    {
        set(data as [NSData]?, forKey: key.rawValue)
    }
}
