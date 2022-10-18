import FinderSync

extension FinderSyncExtensionCheckpointProvider: @unchecked Sendable {}

class FinderSyncExtensionCheckpointProvider: ObservableObject {
    
    @Published var state: FinderSyncExtensionCheckpointState = .none
    
    private var oneTickAlienInfo: AlienInfo?
    private var timer: Timer?
    
    private func currentState() -> FinderSyncExtensionCheckpointState {
        .init(
            enabled: FIFinderSyncController.isExtensionEnabled,
            alienInfo: oneTickAlienInfo
        )
    }

    private func updateState() {
        let state = currentState()
        debug { dump(state, name: "state") }
        self.state = state
        self.oneTickAlienInfo = nil
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            self?.updateState()
        }
    }
    
    init() {
        //
        // In any case, try to establish connection with plugin.
        // If connection to plugin is established, reflect the status of plugin in the status.
        // If connection to plugin times out, reflect it as the extension status.
        //
        updateState()
        _ = self.plugInConnectionController
    }
    
    func handleResponse(_ response: FinderSyncInfoResponse?) {
        debug { dump(response == nil, name: "emptyResponse") }
        guard let response = response else {
            dump((), name: "noResponse")
            return
        }
        debug { dump(response, name: "response") }
        if response.requestHeader.version != plugInHostConnectionVersion {
            dump(response, name: "responseToAlienRequest")
            return
        }        
        let alienInfo: AlienInfo?
        switch response.result {
        case .failure(.alienRequest):
            alienInfo = .alien(path: response.info.plugInPath)
        case .failure:
            alienInfo = .failing
        case .success:
            alienInfo = .same
        }
        
        self.oneTickAlienInfo = alienInfo
    }
    
    private lazy var plugInConnectionController = PlugInConnectionController() { [weak self] (response) in
        self?.handleResponse(response)
    }
}

extension FinderSyncExtensionCheckpointProvider: Traceable {}
