import Foundation

private enum Error: Swift.Error {
    case invalidBundle(path: String)
    case noFrameworksInBundle(path: String)
}

class CommonHelperXPCImp: NSObject, CommonHelperXPC {
    
    func postInstall(sourceBundlePath bundlePath: String, _ reply: @escaping (Swift.Error?) -> Void) {
        let fixedRootURL = URL(fileURLWithPath: "/usr/local/lib/TMBuddy")
        let fileManager = FileManager.default
        do {
            try fileManager.createDirectory(
                at: fixedRootURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
            let bundleURL = URL(fileURLWithPath: bundlePath)
            guard let bundle = Bundle(url: bundleURL) else {
                throw Error.invalidBundle(path: bundlePath)
            }
            
            guard let frameworksURL = bundle.privateFrameworksURL else {
                throw Error.noFrameworksInBundle(path: bundlePath)
            }
            assert(frameworksURL.lastPathComponent == "Frameworks")
            try fileManager.copyItem(at: frameworksURL, to: fixedRootURL.appendingPathComponent("Frameworks"))
            
            dump(frameworksURL.path, name: "frameworksInstallSucceeded")
            reply(nil)
        } catch {
            dump(error, name: "frameworksInstallationFailed")
            reply(error)
        }
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
