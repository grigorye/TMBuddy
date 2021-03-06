enum PostInstallHelperCheckpointState {
    case none
    case skipped
    case completed
    case pending
    case failing(Error)
}

protocol PostInstallHelperCheckpointActions: ViewActions {
    func installMacOSSupport()
}
