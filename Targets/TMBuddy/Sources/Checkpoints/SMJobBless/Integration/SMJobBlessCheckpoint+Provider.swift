import Foundation

extension SMJobBlessCheckpointProvider: @unchecked Sendable {}

class SMJobBlessCheckpointProvider: ObservableObject, Traceable {
    
    @Published var state: SMJobBlessCheckpointState = .none
    
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
            try await helperVersion()
        }
        Task { @MainActor in
            let result = await task.result
            if debugAlienPrivilegedHelper {
                dump(result, name: "helperVersionResult")
            }
            processResultForHelperVersion(result)
        }
    }
    
    @MainActor
    private func processResultForHelperVersion(_ result: Result<String, Error>) {
        switch result {
        case .failure:
            state = .missingBless
        case let .success(version):
            state = {
                switch version {
                case plugInHostConnectionVersion:
                    return .blessed
                case let otherVersion:
                    guard let otherVersionNumber = Int(otherVersion) else {
                        return .alien(otherVersion)
                    }
                    guard otherVersionNumber >= minimumCompatibleHelperVersionNumber else {
                        return .alien(otherVersion)
                    }
                    return .blessed
                }
            }()
        }
    }
}

private func helperVersion() async throws -> String {
    try await performCommonHelperXPC { (proxy: CommonHelperXPC, continuation) in
        proxy.versionAsync { version in
            continuation.resume(returning: version)
        }
    }
}

let minimumCompatibleHelperVersionNumber = 535

var debugAlienPrivilegedHelper: Bool {
    sharedDefaults.bool(forKey: DefaultsKey.debugAlienPrivilegedHelper)
}
