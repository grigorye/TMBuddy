enum PostInstallHelperCheckpointState {
    case none
    case completed
    case pending
    case failing(Error)
}

protocol PostInstallHelperCheckpointActions {
    func installMacOSSupport()
}
