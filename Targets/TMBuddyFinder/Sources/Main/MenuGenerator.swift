import AppKit

@objc protocol MenuGeneratorActions {
    func removePrivilegedExclusionFromTimeMachine(_ sender: AnyObject?)
    func addPrivilegedExclusionInTimeMachine(_ sender: AnyObject?)
    func removeExclusionFromTimeMachine(_ sender: AnyObject?)
    func excludeFromTimeMachine(_ sender: AnyObject?)
}

class MenuGenerator {
    
    static let parentExclusionsMenuItemTitle = NSLocalizedString("Backup Exclusion Levels", comment: "")

    func addRevealParentExclusionsMenuItems(menu: NSMenu, menuItems: [NSMenuItem]) {
        let pathSubmenuItem = NSMenuItem() ≈ {
            $0.title = Self.parentExclusionsMenuItemTitle
            $0.submenu = NSMenu() ≈ {
                $0.items = menuItems
            }
        }
        menu.addItem(pathSubmenuItem)
    }
    
    func addPathExclusionMenuItems(menu: NSMenu, excluded: [Bool]) {
        if excluded.contains(true) {
            menu.addItem(.init() ≈ {
                $0.title = NSLocalizedString("Remove Path Exclusion from Time Machine", comment: "")
                $0.action = #selector(MenuGeneratorActions.removePrivilegedExclusionFromTimeMachine(_:))
            })
        }
        if excluded.contains(false) {
            menu.addItem(.init() ≈ {
                $0.title = NSLocalizedString("Exclude Path from Time Machine", comment: "")
                $0.action = #selector(MenuGeneratorActions.addPrivilegedExclusionInTimeMachine(_:))
            })
        }
    }
    
    func addMetadataExclusionsMenuItems(menu: NSMenu, excluded: [Bool]) {
        if excluded.contains(true) {
            menu.addItem(.init() ≈ {
                $0.title = NSLocalizedString("Remove Exclusion from Time Machine", comment: "")
                $0.action = #selector(MenuGeneratorActions.removeExclusionFromTimeMachine(_:))
            })
        }
        if excluded.contains(false) {
            menu.addItem(.init() ≈ {
                $0.title = NSLocalizedString("Exclude from Time Machine", comment: "")
                $0.action = #selector(MenuGeneratorActions.excludeFromTimeMachine(_:))
            })
        }
    }
    
    func addVolumeExclusionsMenuItems(menu: NSMenu, excluded: [Bool]) {
        if excluded.contains(true) {
            menu.addItem(.init() ≈ {
                $0.title = NSLocalizedString("Include Volume in Time Machine Backups", comment: "")
                $0.action = #selector(MenuGeneratorActions.removePrivilegedExclusionFromTimeMachine(_:))
            })
        }
        if excluded.contains(false) {
            menu.addItem(.init() ≈ {
                $0.title = NSLocalizedString("Exclude Volume from Time Machine Backups", comment: "")
                $0.action = #selector(MenuGeneratorActions.addPrivilegedExclusionInTimeMachine(_:))
            })
        }
    }
}
