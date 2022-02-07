import Foundation

class CommonHelperXPCImp: NSObject, CommonHelperXPC {
    
    func crashAsync(_ reply: @escaping (Bool) -> Void) {
        Task { reply(try await crash()) }
    }
    
    func pingAsync(_ reply: @escaping (Bool) -> Void) {
        Task { reply(await ping()) }
    }
    
    func versionAsync(_ reply: @escaping (String) -> Void) {
        reply(version())
    }

    // MARK: -
    
    func crash() async throws -> Bool {
        enum Error: Swift.Error {
            case fatalFailure
        }
        try! {
            throw Error.fatalFailure
        }()
        
        return true
    }
    
    func ping() async -> Bool {
        dump((), name: "ping")
        sleep(1)
        return true
    }

    func version() -> String {
        return plugInHostConnectionVersion
    }
}
