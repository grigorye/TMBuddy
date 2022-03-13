enum SMJobBlessCheckpointState {
    case none
    case blessed
    case alien(String)
    case missingBless
}

protocol SMJobBlessCheckpointActions: ViewActions {
    func reinstallHelper()
    func installHelper()
    func updateHandler()
}
