import XCTest
import SnapshotTesting

@MainActor
class MenuSnapshots: XCTestCase {
    
    private let record: Bool = false
    
    func testVolumeExclusion() {
        for excluded in [true, false] {
            let name = excluded ? "removal" : "adding"
            assertMenuSnapshot(named: name) { menu in
                MenuGenerator().addVolumeExclusionsMenuItems(menu: menu, excluded: [excluded])
            }
        }
    }
    
    func testPathExclusion() {
        for excluded in [true, false] {
            let name = excluded ? "removal" : "adding"
            assertMenuSnapshot(named: name) { menu in
                MenuGenerator().addPathExclusionMenuItems(menu: menu, excluded: [excluded])
                MenuGenerator().addMetadataExclusionsMenuItems(menu: menu, excluded: [excluded])
            }
        }
    }
    
    @MainActor
    func testRevealParentExclusion() {
        assertMenuSnapshot(
            preselectedTitle: MenuGenerator.parentExclusionsMenuItemTitle,
            record: record
        ) { menu in
            func item(displayName: String, status: TMStatus) -> NSMenuItem {
                NSMenuItem() ≈ {
                    $0.title = displayName
                    $0.image = imageForStatus(status)! ≈ {
                        $0.size = .init(width: 20, height: 20)
                    }
                }
            }
            let menuItems = [
                item(displayName: "Archive", status: .stickyExcluded),
                item(displayName: "Downloads", status: .pathExcluded)
            ]
            let pathSubmenuItem = NSMenuItem() ≈ {
                $0.title = MenuGenerator.parentExclusionsMenuItemTitle
                $0.submenu = NSMenu() ≈ {
                    $0.items = menuItems
                    $0.autoenablesItems = false
                }
            }
            MenuGenerator().addPathExclusionMenuItems(menu: menu, excluded: [false])
            MenuGenerator().addMetadataExclusionsMenuItems(menu: menu, excluded: [false])
            menu.addItem(pathSubmenuItem)
        }
    }
    
    @MainActor
    func assertMenuSnapshot(
        named name: String? = nil,
        preselectedTitle: String? = nil,
        record recording: Bool = false,
        menuGen: (NSMenu) -> Void,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let menu = fakeFinderMenu(inject: menuGen)
        assertMenuSnapshot(
            menu: menu,
            named: name,
            preselectedTitle: preselectedTitle,
            record: recording,
            file: file,
            testName: testName,
            line: line
        )
    }
}

func fakeFinderMenu(inject: (NSMenu) -> Void) -> NSMenu {
    NSMenu() ≈ {
        $0.addFakeItem("...")
        $0.addItem(.separator())
        $0.addFakeSubmenu("Quick Actions")
        inject($0)
        $0.addItem(.separator())
        $0.addFakeSubmenu("Services")
    }
}

extension NSMenu {
    
    func addFakeItem(_ title: String) {
        addItem(withTitle: title, action: nil, keyEquivalent: "")
    }
    
    func addFakeSubmenu(_ title: String) {
        _ = addItem(withTitle: title, action: nil, keyEquivalent: "") ≈ {
            $0.submenu = NSMenu()
        }
    }
}
