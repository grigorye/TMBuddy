import os.log

struct OSLogErrorReporter: ErrorReporter {
    func reportError<T>(_ value: T, name: String, file: StaticString, function: String, line: Int, callStack: CallStack) {
        if #available(macOS 11.0, *) {
            Logger(log).error("\(name): \(String(describing: value))")
        } else {
            os_log(.error, log: log, "%{public}s: %{public}s", name, String(describing: value))
        }
    }
}

private let log: OSLog = .default
