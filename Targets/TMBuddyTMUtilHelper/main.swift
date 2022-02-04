import Foundation
import SharedKit
import os.log

final class MetadataWritingService: NSObject, ServiceInterface, MetadataWriterInterface {
    
    /// XPC interface for collecting logs.
    static let interface: Protocol = MetadataWriterInterface.self
    
    func ping() {
        dump((), name: "ping")
    }
    
    func setExcluded(_ value: Bool, paths: [String]) {
        dump(paths, name: "paths")
        let urls = paths.map { URL.init(fileURLWithPath: $0) }
        Task {
            try await TMUtilLauncher().setExcludedByPath(value, urls: urls)
        }
    }
}

private let log: OSLog = .default

os_log(.info, log: log, "launched")

let delegate = ServiceDelegate(serviceInterfaceType: MetadataWritingService.self)
let listener = NSXPCListener(machServiceName: "com.grigorye.TMBuddy.TMUtilHelper")
listener.delegate = delegate
listener.resume()

os_log(.info, log: log, "listenerFinished")

RunLoop.current.run()

_ = delegate

os_log(.info, log: log, "runLoopEnded")
