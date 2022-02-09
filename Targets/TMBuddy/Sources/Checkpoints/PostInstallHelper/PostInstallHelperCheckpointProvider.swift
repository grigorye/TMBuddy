import Foundation

class PostInstallHelperCheckpointProvider: ObservableObject, Traceable {
    
    enum State {
        case none
        case completed
        case pending
        case failing(Error)
    }
    
    @Published var state: State = .none
    
    private var timer: Timer?
    
    init() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.invalidateInfoTick()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func invalidateInfoTick() {
        
        let task = Task {
            try await postInstallNeeded()
        }
        Task {
            let result = await task.result
            dump(result, name: "postInstallNeededResult")
            DispatchQueue.main.async { [weak self] in
                self?.handlePostInstallNeededResult(result)
            }
        }
    }
    
    private func handlePostInstallNeededResult(_ result: Result<Bool, Error>) {
        switch result {
        case let .success(postInstallNeeded):
            state = postInstallNeeded ? .pending : .completed
        case let .failure(error):
            state = .failing(error)
        }
    }
    
    private let defaults = sharedDefaults
}

private func postInstallNeeded() async throws -> Bool {
    try await performCommonHelperXPC { (proxy: CommonHelperXPC, continuation) in
        proxy.postInstallNeededAsync(sourceBundlePath: Bundle.main.bundlePath) { (error, postInstallNeeded) in
            continuation.resume(with: Result(error: error, value: postInstallNeeded))
        }
    }
}
