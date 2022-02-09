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
            
            if #available(macOSApplicationExtension 11.0, macOS 11.0, *) {
                let subsystem = URL(fileURLWithPath: "\(file)").deletingPathExtension().lastPathComponent
                let category = function
                Logger(subsystem: subsystem, category: category)
                    .log("\(prefix, privacy: .public)\(valueRep, privacy: .public)")
            } else {
                let message = "\(function): \(prefix)\(valueRep)"
                NSLog(message)
            }
        }
        postDump(value, name: name, file: file, function: function, line: line, callStack: callStack)
    }
}

private let defaults = UserDefaults.standard

private let nsLogIsEnabled = defaults.bool(forKey: "suppressNSLog") == false
private let dumpIsEnabled = defaults.bool(forKey: "enableDump")
private let dumpInLogIsEnabled = defaults.bool(forKey: "enableDumpInLog")
