import Foundation

class HostAppConnectionController {
    
    private let defaults = sharedDefaults
    private var userDefaultsObserver: UserDefaultsObserver?
    
    init() {
        userDefaultsObserver = .init(
            defaults: defaults,
            key: DefaultsKey.finderSyncInfoRequestPayload.rawValue,
            options: [.initial, .new]
        ) { [weak self] change in
            self?.observeFinderSyncInfoPayload(change)
        }
    }
    
    func observeFinderSyncInfoPayload(_ change: [NSKeyValueChangeKey : Any]?) {
        let requestIndex = defaults.finderSyncInfoRequestIndex
        let responseIndex = defaults.finderSyncInfoResponseIndex
        
        debug { dump((requestIndex: requestIndex, responseIndex: responseIndex), name: "requestResponse") }
        
        guard responseIndex < requestIndex else {
            debug { dump((responseIndex: responseIndex, requestIndex: requestIndex), name: "responseIsAlreadyThere") }
            return
        }
        
        guard let payload = defaults.finderSyncInfoRequestPayload else {
            dump(requestIndex, name: "requestMissingPayload")
            return
        }
        
        let request: FinderSyncInfoRequest?
        do {
            let untrustedRequest = try JSONDecoder().decode(FinderSyncInfoRequest.self, from: payload)
            let untrustedRequestVersion = untrustedRequest.version
            if untrustedRequestVersion != plugInHostConnectionVersion {
                dump((requestVersion: untrustedRequestVersion, hostVersion: plugInHostConnectionVersion), name: "otherPartyIsAlien")
            }
            request = untrustedRequest
        } catch {
            dump((error, payload: payload), name: "requestDecodingFailed")
            request = nil
        }
        guard let request = request else {
            return
        }

        guard case .checkStatus = request.command else {
            dump((command: request.command, request: request), name: "unknownCommandInRequest")
            return
        }
        
        let timeMachinePreferencesAccess: TimeMachinePreferencesAccess = {
            if let error = timeMachinePreferencesAccessError() {
                return .denied(error.localizedDescription)
            } else {
                return .granted
            }
        }()
        
        let response = FinderSyncInfoResponse(
            index: requestIndex,
            version: plugInHostConnectionVersion,
            info: .checkStatus(
                .timeMachinePreferencesAccess(timeMachinePreferencesAccess)
            )
        )
        defaults.finderSyncInfoResponsePayload = try! plistFromData(PropertyListEncoder().encode(response))
    }
}

extension HostAppConnectionController: Traceable {}
