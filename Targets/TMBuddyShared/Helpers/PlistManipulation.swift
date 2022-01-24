import Foundation

func dataFromPlist(_ plist: Any) throws -> Data {
    try PropertyListSerialization.data(fromPropertyList: plist, format: .binary, options: 0)
}

func plistFromData(_ data: Data) throws -> Any {
    try PropertyListSerialization.propertyList(from: data, format: nil)
}
