enum SMJobBlessCheckpointState {
    case blessed
    case alien(String)
    case missingBless
}

protocol SMJobBlessCheckpointActions {
    func reinstallHelper()
    func installHelper()
    func updateHandler()
}
