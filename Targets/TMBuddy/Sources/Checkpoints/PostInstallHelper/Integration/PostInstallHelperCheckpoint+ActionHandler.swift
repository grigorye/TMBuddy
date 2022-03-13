import AppKit

struct PostInstallHelperCheckpointActionHandler: PostInstallHelperCheckpointActions, Traceable {
    
    func installMacOSSupport() {
        dump((), name: "")
        
        let task = Task {
            try await performCommonHelperXPC { (proxy: CommonHelperXPC, continuation) in
                proxy.postInstallAsync(sourceBundlePath: postInstallHelperSourceBundlePath) { error in
                    continuation.resume(with: Result(error: error))
                }
            }
        }
        Task {
            let result = await task.result
            dump(result, name: "postInstallResult")
        }
    }
}
