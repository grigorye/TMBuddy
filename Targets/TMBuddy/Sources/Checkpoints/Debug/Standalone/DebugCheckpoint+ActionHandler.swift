class DebugCheckpointActionsHandler: DebugCheckpointActions {
    
    func crash() {
        _ = [0][1]
    }
}
