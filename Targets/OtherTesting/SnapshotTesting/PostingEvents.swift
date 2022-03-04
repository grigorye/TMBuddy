import AppKit
import CoreGraphics
import Carbon

func postKeyWithModifiers(key: CGKeyCode, modifiers: CGEventFlags) {
    let source = CGEventSource(stateID: .combinedSessionState)
    
    let keyDown = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: true)! ≈ {
        $0.flags = modifiers
    }
    let keyUp = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: false)!
    
    sendEventToCarbonEventDispatcherTarget(keyDown)
    sendEventToCarbonEventDispatcherTarget(keyUp)
}

func sendEventToCarbonEventDispatcherTarget(_ cgEvent: CGEvent) {
    SendEventToEventTarget(OpaquePointer(NSEvent(cgEvent: cgEvent)!.eventRef!), GetEventDispatcherTarget())
}
