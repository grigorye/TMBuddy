import Foundation

class PlugInConnectionController {
    
    private let defaults = sharedDefaults
    private var userDefaultsObserver: UserDefaultsObserver?
    private let pluginInfoDidChange: (FinderSyncInfoResponse?) -> Void
    
    init(pluginInfoDidChange: @escaping (FinderSyncInfoResponse?) -> Void) {
        self.pluginInfoDidChange = pluginInfoDidChange
        self.userDefaultsObserver = .init(
            defaults: defaults,
            key: DefaultsKey.finderSyncInfoResponsePayload.rawValue,
            options: [.initial, .new]
        ) { [weak self] change in
            self?.observeFinderSyncInfoResponsePayload(change)
        }
    }
    
    func observeFinderSyncInfoResponsePayload(_ change: [NSKeyValueChangeKey : Any]?) {
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
            // Get the header first, provided that it should not depend on version.
            let responseHeader: FinderSyncInfoResponseHeader
            do {
                responseHeader = try PropertyListDecoder().decode(FinderSyncInfoResponseHeader.self, from: PropertyListSerialization.data(fromPropertyList: payload, format: .binary, options: 0))
            } catch {
                dump((error, payload: payload), name: "responseHeaderDecodingFailed")
                return
            }
            // Do nothing if the request did not originate from us.
            guard responseHeader.requestHeader.version == plugInHostConnectionVersion else {
                dump(responseHeader, name: "responseToAlienRequest")
                return
            }
            // If the plugin is alien, neither we can trust the data it provides, nor the plugin should return anything but error.
            if responseHeader.version != plugInHostConnectionVersion {
                dump((responseHeader: responseHeader, hostVersion: plugInHostConnectionVersion), name: "otherPartyIsAlien")
                let responseHeaderWithFailure: FinderSyncInfoResponseHeaderWithFailure
                do {
                    responseHeaderWithFailure = try PropertyListDecoder().decode(FinderSyncInfoResponseHeaderWithFailure.self, from: dataFromPlist(payload))
                } catch {
                    assertionFailure()
                    dump((error, payload: payload), name: "responseHeaderWithFailureDecodingFailed")
                    return
                }
                guard case .failure(.alienRequest) = responseHeaderWithFailure.result else {
                    assertionFailure()
                    dump(responseHeaderWithFailure, name: "responseHeaderWithFailureThatIsNotAlienRequest")
                    return
                }
            }
            do {
                response = try PropertyListDecoder().decode(FinderSyncInfoResponse.self, from: dataFromPlist(payload))
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
            debug { dump((), name: "requestIsAlreadyInProgress") }
            return false
        }
        
        let request = FinderSyncInfoRequest(
            index: requestIndex + 1,
            version: plugInHostConnectionVersion,
            command: .checkStatus
        )
        defaults.finderSyncInfoRequestPayload = try! plistFromData(PropertyListEncoder().encode(request))

        return true
    }
}

extension PlugInConnectionController: Traceable {}
