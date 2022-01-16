import Foundation

class PlugInConnectionController {
    
    private let defaults = sharedDefaults
    private var userDefaultsObserver: UserDefaultsObserver?
    private let pluginInfoDidChange: (FinderSyncInfoResponse?) -> Void
    
    init(pluginInfoDidChange: @escaping (FinderSyncInfoResponse?) -> Void) {
        self.pluginInfoDidChange = pluginInfoDidChange
        self.userDefaultsObserver = .init(
            defaults: defaults,
            key: DefaultsKey.finderSyncInfoResponseIndex.rawValue,
            options: [.initial, .new]
        ) { [weak self] change in
            self?.observeFinderSyncInfoResponseIndex(change)
        }
    }
    
    func observeFinderSyncInfoResponseIndex(_ change: [NSKeyValueChangeKey : Any]?) {
        let requestIndex = defaults.finderSyncInfoRequestIndex
        let responseIndex = defaults.finderSyncInfoResponseIndex
        debug { dump((requestIndex: requestIndex, responseIndex: responseIndex), name: "requestResponse") }
        
        guard responseIndex == requestIndex else {
            assert(responseIndex < requestIndex)
            debug { dump((responseIndex: responseIndex, requestIndex: requestIndex), name: "requestIsInProgress") }
            return
        }
        
        let response: FinderSyncInfoResponse?
        if let payload = defaults.finderSyncInfoResponsePayload {
            do {
                let untrustedResponse = try JSONDecoder().decode(FinderSyncInfoResponse.self, from: payload)
                let untrustedResponseVersion = untrustedResponse.version
                if untrustedResponseVersion != plugInHostConnectionVersion {
                    dump((responseVersion: untrustedResponseVersion, hostVersion: plugInHostConnectionVersion), name: "otherPartyIsAlien")
                }
                response = untrustedResponse
            } catch {
                dump((error, payload: payload), name: "responseDecodingFailed")
                response = nil
            }
        } else {
            response = nil
        }
        pluginInfoDidChange(response)
    }
    
    func invalidatePluginInfo() -> Bool {
        let requestIndex = defaults.finderSyncInfoRequestIndex
        let responseIndex = defaults.finderSyncInfoResponseIndex
        debug { dump((requestIndex: requestIndex, responseIndex: responseIndex), name: "requestResponse") }

        guard responseIndex == requestIndex else {
            assert(responseIndex < requestIndex)
            debug { dump("requestIsAlreadyInProgress") }
            return false
        }
        
        defaults.finderSyncInfoRequestIndex += 1
        return true
    }
}

extension PlugInConnectionController: Traceable {}
