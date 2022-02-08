import Foundation

class CommonHelperXPCImp: NSObject, CommonHelperXPC {
    
    func postInstallNeededAsync(sourceBundlePath: String, reply: @escaping (Error?, Bool) -> Void) {
        let result = Result {
            try PostInstallController(sourceBundlePath: sourceBundlePath)
                .postInstallNeeded()
        }
        dump(result, name: "result")
        result.send(to: reply)
    }
    
    func postInstallAsync(sourceBundlePath: String, reply: @escaping (Swift.Error?) -> Void) {
        let result = Result {
            let postInstallController = PostInstallController(sourceBundlePath: sourceBundlePath)
            try postInstallController.postInstall()
        }
        dump(result, name: "result")
        result.send(to: reply)
    }
    
    func crashAsync(_ reply: @escaping (Bool) -> Void) {
        Task { reply(try await crash()) }
    }
    
    func pingAsync(_ reply: @escaping (Bool) -> Void) {
        Task { reply(await ping()) }
    }
    
    func versionAsync(_ reply: @escaping (String) -> Void) {
        reply(version())
    }
    
    func checkSanityAsync(writablePath: String, readOnlyPath: String, reply: @escaping (Error?) -> Void) {
        let result = Result {
            try checkSandboxSanity(writablePath: writablePath, readOnlyPath: readOnlyPath)
        }
        dump(result, name: "result")
        result.send(to: reply)
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
