import Foundation

class SMJobBlessCheckpointProvider: StateHolder<SMJobBlessCheckpointState>, Traceable {
    
    private var timer: Timer?
    
    override init() {
        super.init()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.invalidateInfoTick()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func invalidateInfoTick() {
        
        let task = Task {
            try await helperVersion()
        }
        Task {
            let result = await task.result
            if defaults.bool(forKey: DefaultsKey.debugAlienPrivilegedHelper) {
                dump(result, name: "helperVersionResult")
            }
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .failure:
                    self?.state = .missingBless
                case let .success(version):
                    self?.state = {
                        switch version {
                        case plugInHostConnectionVersion:
                            return .blessed
                        case let otherVersion:
                            return .alien(otherVersion)
                        }
                    }()
                }
            }
        }
    }
    
    private let defaults = sharedDefaults
}

private func helperVersion() async throws -> String {
    try await performCommonHelperXPC { (proxy: CommonHelperXPC, continuation) in
        proxy.versionAsync { version in
            continuation.resume(returning: version)
        }
    }
}
