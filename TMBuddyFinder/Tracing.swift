import Foundation

private enum Imp {}

extension Imp {
    
    @discardableResult
    static func dump<T>(_ value: T, name: String?, file: String, function: String) -> T {
        if dumpIsEnabled {
            let suffix = name.flatMap { ", " + $0 } ?? ""
            Swift.dump(value, name: function + suffix)
        }
        if nsLogIsEnabled {
            let prefix = name.flatMap { $0 + ": " } ?? ""
            NSLog("\(function): \(prefix)\(value)")
        }
        return value
    }
}

@discardableResult
func dump<T>(_ value: T, name: String? = nil, file: String = #fileID, function: String = #function) -> T {
    Imp.dump(value, name: name, file: file, function: function)
}

extension NSObject {

    @discardableResult
    public func dump<T>(_ value: T, name: String? = nil, file: String = #fileID, function: String = #function, indent: Int = 0, maxDepth: Int = .max, maxItems: Int = .max) -> T {
        Imp.dump(value, name: name, file: file, function: "\(type(of: self)).\(function)")
    }
    
    @discardableResult
    public class func dump<T>(_ value: T, name: String? = nil, file: String = #fileID, function: String = #function, indent: Int = 0, maxDepth: Int = .max, maxItems: Int = .max) -> T {
        Imp.dump(value, name: name, file: file, function: "\(Self.self).\(function)")
    }
}

private let defaults = UserDefaults.standard

private let nsLogIsEnabled = defaults.bool(forKey: "suppressNSLog") == false
private let dumpIsEnabled = defaults.bool(forKey: "enableDump")
