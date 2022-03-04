import XCTest
import Carbon

extension XCTestCase {
    
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
            guard let windowNumber = windowNumbers.first(where: { $0 != window.windowNumber }) else {
                XCTFail()
                return
            }
            let menuWindow = NSApp.window(withWindowNumber: windowNumber)!
            
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
    
    init(menuDidOpen: @escaping (NSMenu) -> Void) {
        self.menuDidOpen = menuDidOpen
    }
    
    let menuDidOpen: (NSMenu) -> Void
    
    func menuWillOpen(_ menu: NSMenu) {
        let timer = Timer(timeInterval: 0, repeats: false) { [menuDidOpen] timer in
            menuDidOpen(menu)
        }
        RunLoop.current.add(timer, forMode: .eventTracking)
    }
}

