import Foundation

extension PlugInFullDiskAccessCheckpointProvider: @unchecked Sendable {}

class PlugInFullDiskAccessCheckpointProvider: ObservableObject {
    
    typealias State = PlugInFullDiskAccessCheckpointState
    
    @Published var state: State = .none
    
    private var timer: Timer?
    
    init() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.invalidatePlugInInfoTick()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func invalidatePlugInInfoTick() {
        if plugInConnectionController.invalidatePluginInfo() == false {
            state = .unresponsive
        }
    }
    
    func handleResponse(_ response: FinderSyncInfoResponse?) {
        debug { dump(response == nil, name: "emptyResponse") }
        guard let response = response else {
            state = .none
            return
        }
        debug { dump(response, name: "response") }
        let newState: State
        guard case let .success(successResult) = response.result else {
            debug {
                dump((result: response.result, response: response), name: "failureInResponse")
            }
            return
        }
        guard case let .checkStatus(.timeMachinePreferencesAccess(timeMachinePreferencesAccess)) = successResult else {
            dump((info: response.info, response: response), name: "unknownResponseInfo")
            return
        }
        switch timeMachinePreferencesAccess {
        case let .denied(error):
            debug { dump(error, name: "receivedError") }
            newState = .denied
        case .granted:
            newState = .granted
        }
        debug { dump(newState, name: "newState") }
        self.state = newState
    }
    
    private lazy var plugInConnectionController = PlugInConnectionController() { [weak self] (response) in
        self?.handleResponse(response)
    }
}

extension PlugInFullDiskAccessCheckpointProvider: Traceable {}
