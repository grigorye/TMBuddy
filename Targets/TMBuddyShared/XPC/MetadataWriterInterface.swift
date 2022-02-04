import Foundation

/// XPC interface for returning folder contents.
@objc protocol MetadataWriterInterface {
    func ping()
    func setExcluded(_ value: Bool, paths: [String])
}
