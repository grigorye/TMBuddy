struct FinderSyncExtensionCheckpointState {
    let enabled: Bool?
    let alienInfo: AlienInfo?
    
    static let none = Self(enabled: nil, alienInfo: nil)
}

enum AlienInfo {
    case alien(path: String)
    case same
    case failing
}

protocol FinderSyncExtensionCheckpointActions {
    func showExtensionsPreferences()
    func revealAlienInFinder(path: String)
}
