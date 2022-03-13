class DebugCheckpointActionsHandler: Traceable, DebugCheckpointActions {
    
    func crash() {
        dump((), name: "")
        
        _ = [0][1]
    }
}
