enum SMJobBlessCheckpointState: Sendable {
    case none
    case blessed
    case alien(String)
    case missingBless
}

@MainActor protocol SMJobBlessCheckpointActions: ViewActions {
    func reinstallHelper()
    func installHelper()
    func updateHandler()
}
