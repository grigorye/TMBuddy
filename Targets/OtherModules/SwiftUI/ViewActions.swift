protocol ViewActions {
    func trackVisibility(_ visible: Bool)
}

extension Traceable {
    
    func trackVisibility(_ visible: Bool) {
        dump(visible, name: "")
    }
}
