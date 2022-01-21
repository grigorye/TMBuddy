import Foundation

class PlugInFullDiskAccessCheckPointProvider: ObservableObject {
    
    enum AccessState {
        case granted
        case denied
        case unresponsive
        case none
    }
    
    @Published var accessGranted: AccessState = .none
    
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
            accessGranted = .unresponsive
        }
    }
    
    func handleResponse(_ response: FinderSyncInfoResponse?) {
        debug { dump(response == nil, name: "emptyResponse") }
        guard let response = response else {
            accessGranted = .unresponsive
            return
        }
        debug { dump(response, name: "response") }
        let newAccessGranted: AccessState
        guard case let .checkStatus(.timeMachinePreferencesAccess(timeMachinePreferencesAccess)) = response.info else {
            dump((info: response.info, response: response), name: "unknownResponseInfo")
            return
        }
        switch timeMachinePreferencesAccess {
        case let .denied(error):
            debug { dump(error, name: "receivedError") }
            newAccessGranted = .denied
        case .granted:
            newAccessGranted = .granted
        }
        debug { dump(newAccessGranted, name: "newAccessGranted") }
        self.accessGranted = newAccessGranted
    }
    
    private lazy var plugInConnectionController = PlugInConnectionController() { [weak self] (response) in
        self?.handleResponse(response)
    }
}

extension PlugInFullDiskAccessCheckPointProvider: Traceable {}
