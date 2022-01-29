import Foundation

private enum Imp {}

extension Imp {
    
    @discardableResult
    static func dump<T>(_ value: T, name: String?, file: String, function: String, line: Int, callStack: CallStack, indent: Int, maxDepth: Int, maxItems: Int) -> T {
        if dumpIsEnabled {
            let suffix = name.flatMap { ", " + $0 } ?? ""
            Swift.dump(value, name: function + suffix, indent: indent, maxDepth: maxDepth, maxItems: maxItems)
        }
        if nsLogIsEnabled {
            let prefix = name.flatMap { $0 + ": " } ?? ""
            let message = "\(function): \(prefix)\(value)"
            NSLog(message)
        }
        postprocessDumpedValue(value, name: name, file: file, function: function, line: line, callStack: callStack)
        return value
    }
}

@discardableResult
func dump<T>(_ value: T, name: String, function: String = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
    Imp.dump(value, name: name, file: "file", function: function, line: line, callStack: callStack, indent: 0, maxDepth: .max, maxItems: .max)
}

@discardableResult
func dump<T>(_ value: T, name: String, maxDepth: Int, function: String = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
    Imp.dump(value, name: name, file: "file", function: function, line: line, callStack: callStack, indent: 0, maxDepth: maxDepth, maxItems: .max)
}

@discardableResult
func dump<T>(_ value: T, name: String, maxDepth: Int, maxItems: Int, function: String = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
    Imp.dump(value, name: name, file: "file", function: function, line: line, callStack: callStack, indent: 0, maxDepth: maxDepth, maxItems: maxItems)
}

protocol Traceable {}

extension Traceable {

    @discardableResult
    func dump<T>(_ value: T, name: String, function: String = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
        Imp.dump(value, name: name, file: "file", function: "\(type(of: self)).\(function)", line: line, callStack: callStack, indent: 0, maxDepth: .max, maxItems: .max)
    }

    @discardableResult
    func dump<T>(_ value: T, name: String, maxDepth: Int, function: String = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
        Imp.dump(value, name: name, file: "file", function: "\(type(of: self)).\(function)", line: line, callStack: callStack, indent: 0, maxDepth: maxDepth, maxItems: .max)
    }
    
    @discardableResult
    func dump<T>(_ value: T, name: String, maxDepth: Int, maxItems: Int, function: String = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
        Imp.dump(value, name: name, file: "file", function: "\(type(of: self)).\(function)", line: line, callStack: callStack, indent: 0, maxDepth: maxDepth, maxItems: maxItems)
    }

    @discardableResult
    public func dump<T>(_ value: T, name: String? = nil, function: String = #function, line: Int = #line, callStack: CallStack = .init(), indent: Int = 0, maxDepth: Int = .max, maxItems: Int = .max) -> T {
        Imp.dump(value, name: name, file: "file", function: "\(type(of: self)).\(function)", line: line, callStack: callStack, indent: indent, maxDepth: maxDepth, maxItems: maxItems)
    }
    
    @discardableResult
    public static func dump<T>(_ value: T, name: String? = nil, function: String = #function, line: Int = #line, callStack: CallStack = .init(), indent: Int = 0, maxDepth: Int = .max, maxItems: Int = .max) -> T {
        Imp.dump(value, name: name, file: "file", function: "\(Self.self).\(function)", line: line, callStack: callStack, indent: indent, maxDepth: maxDepth, maxItems: maxItems)
    }
}

extension NSObject: Traceable {}

private let defaults = UserDefaults.standard

private let nsLogIsEnabled = defaults.bool(forKey: "suppressNSLog") == false
private let dumpIsEnabled = defaults.bool(forKey: "enableDump")
