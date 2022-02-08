import Foundation
import os.log

private enum Imp {}

extension Imp {
    
    @discardableResult
    static func dump<T>(_ value: T, name: String?, file: StaticString, function: String, line: Int, callStack: CallStack, indent: Int, maxDepth: Int, maxItems: Int) -> T {
        LoggingImp.log(value, name: name, file: file, function: function, line: line, callStack: callStack, indent: indent, maxDepth: maxDepth, maxItems: maxItems)
        return value
    }
}

@discardableResult
func dump<T>(_ value: T, name: String, file: StaticString = #file, function: String = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
    Imp.dump(value, name: name, file: file, function: function, line: line, callStack: callStack, indent: 0, maxDepth: .max, maxItems: .max)
}

@discardableResult
func dump<T>(_ value: T, name: String, file: StaticString = #file, maxDepth: Int, function: String = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
    Imp.dump(value, name: name, file: file, function: function, line: line, callStack: callStack, indent: 0, maxDepth: maxDepth, maxItems: .max)
}

@discardableResult
func dump<T>(_ value: T, name: String, file: StaticString = #file, maxDepth: Int, maxItems: Int, function: String = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
    Imp.dump(value, name: name, file: file, function: function, line: line, callStack: callStack, indent: 0, maxDepth: maxDepth, maxItems: maxItems)
}

protocol Traceable {}

extension Traceable {

    @discardableResult
    func dump<T>(_ value: T, name: String, file: StaticString = #file, function: String = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
        Imp.dump(value, name: name, file: file, function: "\(type(of: self)).\(function)", line: line, callStack: callStack, indent: 0, maxDepth: .max, maxItems: .max)
    }

    @discardableResult
    func dump<T>(_ value: T, name: String, file: StaticString = #file, maxDepth: Int, function: String = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
        Imp.dump(value, name: name, file: file, function: "\(type(of: self)).\(function)", line: line, callStack: callStack, indent: 0, maxDepth: maxDepth, maxItems: .max)
    }
    
    @discardableResult
    func dump<T>(_ value: T, name: String, file: StaticString = #file, maxDepth: Int, maxItems: Int, function: String = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
        Imp.dump(value, name: name, file: file, function: "\(type(of: self)).\(function)", line: line, callStack: callStack, indent: 0, maxDepth: maxDepth, maxItems: maxItems)
    }

    @discardableResult
    public func dump<T>(_ value: T, name: String? = nil, file: StaticString = #file, function: String = #function, line: Int = #line, callStack: CallStack = .init(), indent: Int = 0, maxDepth: Int = .max, maxItems: Int = .max) -> T {
        Imp.dump(value, name: name, file: file, function: "\(type(of: self)).\(function)", line: line, callStack: callStack, indent: indent, maxDepth: maxDepth, maxItems: maxItems)
    }
    
    @discardableResult
    public static func dump<T>(_ value: T, name: String? = nil, file: StaticString = #file, function: String = #function, line: Int = #line, callStack: CallStack = .init(), indent: Int = 0, maxDepth: Int = .max, maxItems: Int = .max) -> T {
        Imp.dump(value, name: name, file: file, function: "\(Self.self).\(function)", line: line, callStack: callStack, indent: indent, maxDepth: maxDepth, maxItems: maxItems)
    }
}

extension NSObject: Traceable {}
