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
        
        let requestHeader: FinderSyncInfoRequestHeader
        let otherPartyIsAlien: Bool
        do {
            requestHeader = try PropertyListDecoder().decode(FinderSyncInfoRequestHeader.self, from: dataFromPlist(payload))
            let untrustedRequestVersion = requestHeader.version
            otherPartyIsAlien = untrustedRequestVersion != plugInHostConnectionVersion
            if otherPartyIsAlien {
                if defaults.bool(forKey: DefaultsKey.debugAlien) {
                    dump((requestVersion: untrustedRequestVersion, hostVersion: plugInHostConnectionVersion), name: "otherPartyIsAlien")
                }
            }
        } catch {
            dump((error, payload: payload), name: "requestHeaderDecodingFailed")
            return
        }
        
        let result: FinderSyncInfoResponse.Result = {
            if otherPartyIsAlien {
                return .failure(.alienRequest)
            }
            else {
                let request: FinderSyncInfoRequest
                do {
                    request = try PropertyListDecoder().decode(FinderSyncInfoRequest.self, from: dataFromPlist(payload))
                } catch {
                    dump((error, payload: payload), name: "requestDecodingFailed")
                    return .failure(.requestDecodingFailed)
                }
                
                switch request.command {
                case .checkStatus:
                    let timeMachinePreferencesAccess: TimeMachinePreferencesAccess = {
                        if let error = timeMachinePreferencesAccessError() {
                            return .denied(error.localizedDescription)
                        } else {
                            return .granted
                        }
                    }()
                    
                    return .success(
                        .checkStatus(
                            .timeMachinePreferencesAccess(timeMachinePreferencesAccess)
                        )
                    )
                }
            }
        }()
        let response = FinderSyncInfoResponse(
            index: requestIndex,
            version: plugInHostConnectionVersion,
            requestHeader: requestHeader,
            info: .init(plugInPath: Bundle.main.bundlePath),
            result: result
        )
        debug { dump(response, name: "response") }
        defaults.finderSyncInfoResponsePayload = try! plistFromData(PropertyListEncoder().encode(response))
    }
}

extension HostAppConnectionController: Traceable {}
