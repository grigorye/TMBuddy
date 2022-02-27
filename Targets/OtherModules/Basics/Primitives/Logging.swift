import Foundation
import os.log

enum LoggingImp {
    
    static func log<T>(_ value: T, name: String?, file: StaticString, function: String, line: Int, callStack: CallStack, indent: Int, maxDepth: Int, maxItems: Int) {
        if dumpIsEnabled {
            let suffix = name.flatMap { ", " + $0 } ?? ""
            Swift.dump(value, name: function + suffix, indent: indent, maxDepth: maxDepth, maxItems: maxItems)
        }
        if nsLogIsEnabled {
            let prefix = name.flatMap { $0 + ": " } ?? ""
            let valueRep: String = {
                guard dumpInLogIsEnabled else {
                    return "\(value)"
                }
                return "" ≈ {
                    Swift.dump(value, to: &$0, indent: indent, maxDepth: maxDepth, maxItems: maxItems)
                }
            }()
            
            let subsystem = URL(fileURLWithPath: "\(file)").deletingPathExtension().lastPathComponent
            let category = function
            let log = OSLog(subsystem: subsystem, category: category)
            let logType: OSLogType = logType(name: name, file: file, function: function, line: line, callStack: callStack)
            os_log(logType, log: log, "%{public}s%{public}s", prefix, valueRep)
        }
        postDump(value, name: name, file: file, function: function, line: line, callStack: callStack)
    }
}

private let defaults = UserDefaults.standard

private let nsLogIsEnabled = defaults.bool(forKey: "suppressNSLog") == false
private let dumpIsEnabled = defaults.bool(forKey: "enableDump")
private let dumpInLogIsEnabled = defaults.bool(forKey: "enableDumpInLog")
