@preconcurrency import XCTest
import Carbon

extension XCTestCase {
    
    @MainActor
    func assertMenuSnapshot(
        menu: NSMenu,
        named name: String? = nil,
        preselectedTitle: String? = nil,
        record recording: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let window = NSWindow() ≈ {
            $0.center()
            $0.isReleasedWhenClosed = false
        }
        window.makeKeyAndOrderFront(nil)
        defer {
            window.close()
        }
        
        var scheduledAfterSnapshot: [() -> Void] = []
        var scheduledBeforeSnapshot: [() -> Void] = []
        
        let menuDelegate = MenuDelegate { menu in
            let windowNumbers = NSWindow.windowNumbers()!.map { $0.intValue }
            guard let windowNumber = windowNumbers.first(where: { NSApplication.shared.window(withWindowNumber: $0)?.level == .popUpMenu }) else {
                XCTFail()
                return
            }
            let menuWindow = NSApplication.shared.window(withWindowNumber: windowNumber)!
            
            scheduledBeforeSnapshot.forEach { $0() }
            scheduledBeforeSnapshot = []
            
            self.snapshotFlakyBorderWindow(
                windowNumber: menuWindow.windowNumber,
                listOptions: [.optionIncludingWindow, .optionOnScreenAboveWindow],
                named: name,
                record: recording,
                file: file,
                testName: testName,
                line: line
            )
            
            scheduledAfterSnapshot.forEach { $0() }
            scheduledAfterSnapshot = []
        }
        
        let menu = menu.copy() as! NSMenu ≈ {
            $0.delegate = menuDelegate
            $0.autoenablesItems = false
        }
        for item in menu.items {
            item.isEnabled = true
        }
        scheduledAfterSnapshot.append {
            menu.cancelTrackingWithoutAnimation()
        }
        let item: NSMenuItem?
        if let preselectedTitle = preselectedTitle {
            let i = menu.indexOfItem(withTitle: preselectedTitle)
            item = menu.item(at: i)
            scheduledBeforeSnapshot.append {
                postKeyWithModifiers(key: CGKeyCode(kVK_RightArrow), modifiers: [])
            }
        } else {
            item = nil
        }
        menu.popUp(positioning: item, at: .zero, in: window.contentView)
    }
}

private class MenuDelegate: NSObject, NSMenuDelegate {
    
    init(menuDidOpen: @MainActor @Sendable @escaping (NSMenu) -> Void) {
        self.menuDidOpen = menuDidOpen
    }
    
    let menuDidOpen: @MainActor @Sendable (NSMenu) -> Void
    
    func menuWillOpen(_ menu: NSMenu) {
        let timer = Timer(timeInterval: 0, repeats: false) { [menuDidOpen] timer in
            Task { @MainActor in
                menuDidOpen(menu)
            }
        }
        RunLoop.current.add(timer, forMode: .eventTracking)
    }
}
