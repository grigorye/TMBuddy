protocol ViewActions {
    func track(visible: Bool)
}

extension Traceable {
    
    func track(visible: Bool) {
        dump(visible, name: "visible")
    }
}
