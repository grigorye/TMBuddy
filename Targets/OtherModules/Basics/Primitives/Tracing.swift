import Foundation
import os.log

private enum Imp {}

extension Imp {
    
    @discardableResult
    static func dump<T>(_ value: T, name: String?, sourceInfo: SourceInfo, indent: Int, maxDepth: Int, maxItems: Int) -> T {
        LoggingImp.log(value, name: name, sourceInfo: sourceInfo, indent: indent, maxDepth: maxDepth, maxItems: maxItems)
        return value
    }
}

@discardableResult
func dump<T>(_ value: T, name: String, file: StaticString = #file, function: StaticString = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
    let sourceInfo = SourceInfo(file: file, function: function, line: line, callStack: callStack)
    return Imp.dump(value, name: name, sourceInfo: sourceInfo, indent: 0, maxDepth: .max, maxItems: .max)
}

@discardableResult
func dump<T>(_ value: T, name: String, file: StaticString = #file, maxDepth: Int, function: StaticString = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
    let sourceInfo = SourceInfo(file: file, function: function, line: line, callStack: callStack)
    return Imp.dump(value, name: name, sourceInfo: sourceInfo, indent: 0, maxDepth: maxDepth, maxItems: .max)
}

@discardableResult
func dump<T>(_ value: T, name: String, file: StaticString = #file, maxDepth: Int, maxItems: Int, function: StaticString = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
    let sourceInfo = SourceInfo(file: file, function: function, line: line, callStack: callStack)
    return Imp.dump(value, name: name, sourceInfo: sourceInfo, indent: 0, maxDepth: maxDepth, maxItems: maxItems)
}

protocol Traceable {}

extension Traceable {

    @discardableResult
    func dump<T>(_ value: T, name: String, file: StaticString = #file, function: StaticString = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
        let sourceInfo = SourceInfo(file: file, function: "\(type(of: self)).\(function)", originalFunction: function, line: line, callStack: callStack)
        return Imp.dump(value, name: name, sourceInfo: sourceInfo, indent: 0, maxDepth: .max, maxItems: .max)
    }

    @discardableResult
    func dump<T>(_ value: T, name: String, file: StaticString = #file, maxDepth: Int, function: StaticString = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
        let sourceInfo = SourceInfo(file: file, function: "\(type(of: self)).\(function)", originalFunction: function, line: line, callStack: callStack)
        return Imp.dump(value, name: name, sourceInfo: sourceInfo, indent: 0, maxDepth: maxDepth, maxItems: .max)
    }
    
    @discardableResult
    func dump<T>(_ value: T, name: String, file: StaticString = #file, maxDepth: Int, maxItems: Int, function: StaticString = #function, line: Int = #line, callStack: CallStack = .init()) -> T {
        let sourceInfo = SourceInfo(file: file, function: "\(type(of: self)).\(function)", originalFunction: function, line: line, callStack: callStack)
        return Imp.dump(value, name: name, sourceInfo: sourceInfo, indent: 0, maxDepth: maxDepth, maxItems: maxItems)
    }

    @discardableResult
    public func dump<T>(_ value: T, name: String? = nil, file: StaticString = #file, function: StaticString = #function, line: Int = #line, callStack: CallStack = .init(), indent: Int = 0, maxDepth: Int = .max, maxItems: Int = .max) -> T {
        let sourceInfo = SourceInfo(file: file, function: "\(type(of: self)).\(function)", originalFunction: function, line: line, callStack: callStack)
        return Imp.dump(value, name: name, sourceInfo: sourceInfo, indent: indent, maxDepth: maxDepth, maxItems: maxItems)
    }
    
    @discardableResult
    public static func dump<T>(_ value: T, name: String? = nil, file: StaticString = #file, function: StaticString = #function, line: Int = #line, callStack: CallStack = .init(), indent: Int = 0, maxDepth: Int = .max, maxItems: Int = .max) -> T {
        let sourceInfo = SourceInfo(file: file, function: "\(Self.self).\(function)", originalFunction: function, line: line, callStack: callStack)
        return Imp.dump(value, name: name, sourceInfo: sourceInfo, indent: indent, maxDepth: maxDepth, maxItems: maxItems)
    }
}

extension NSObject: Traceable {}
