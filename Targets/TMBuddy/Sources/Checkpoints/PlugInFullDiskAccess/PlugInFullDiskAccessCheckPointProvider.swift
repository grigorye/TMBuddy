import Foundation

class PlugInFullDiskAccessCheckPointProvider: ObservableObject {
    
    @Published var accessGranted: Bool?
    
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
            accessGranted = nil
        }
    }
    
    func handleResponse(_ response: FinderSyncInfoResponse?) {
        debug { dump(response == nil, name: "emptyResponse") }
        guard let response = response else {
            accessGranted = false
            return
        }
        debug { dump(response, name: "response") }
        let newAccessGranted: Bool
        switch response.timeMachinePreferencesAccess {
        case let .denied(error):
            debug { dump(error, name: "receivedError") }
            newAccessGranted = false
        case .granted:
            newAccessGranted = true
        }
        debug { dump(newAccessGranted, name: "newAccessGranted") }
        self.accessGranted = newAccessGranted
    }
    
    private lazy var plugInConnectionController = PlugInConnectionController() { [weak self] (response) in
        self?.handleResponse(response)
    }
}

extension PlugInFullDiskAccessCheckPointProvider: Traceable {}