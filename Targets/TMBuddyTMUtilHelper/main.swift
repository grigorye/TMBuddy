import Foundation
import SharedKit
import os.log

final class TMUtilHelperXPCImp: NSObject, ServiceInterface, TMUtilHelperXPC {
    
    static let interface: Protocol = TMUtilHelperXPC.self
    
    func ping() {
        dump((), name: "ping")
    }
    
    func setExcludedByPath(_ value: Bool, paths: [String]) {
        dump(paths, name: "paths")
        let urls = paths.map { URL.init(fileURLWithPath: $0) }
        Task {
            try await TMUtilLauncher().setExcludedByPath(value, urls: urls)
        }
    }
}

private let log: OSLog = .default

os_log(.info, log: log, "launched")

let delegate = ServiceDelegate(serviceInterfaceType: TMUtilHelperXPCImp.self)
let listener = NSXPCListener(machServiceName: "com.grigorye.TMBuddy.TMUtilHelper")
listener.delegate = delegate
listener.resume()

os_log(.info, log: log, "listenerFinished")

RunLoop.current.run()

_ = delegate

os_log(.info, log: log, "runLoopEnded")
