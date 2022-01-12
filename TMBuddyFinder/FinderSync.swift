import Cocoa
import FinderSync

let includedImage: NSImage? = nil // NSImage(named: NSImage.userName)
let excludedImage = NSImage(named: NSImage.cautionName)
let unknownImage = NSImage(named: NSImage.colorPanelName)

func imageForStatus(_ status: TMStatus) -> NSImage? {
    switch status {
    case .included:
        return includedImage
    case .excluded:
        return excludedImage
    case .unknown:
        return unknownImage
    }
}

func badgeIdentifierForStatus(_ status: TMStatus) -> String {
    status.rawValue
}

func labelForStatus(_ status: TMStatus) -> String {
    "\(status)"
}

let syncController = FIFinderSyncController.default()
let statusProvider = TMStatusProvider()

class FinderSync: FIFinderSync {

    let sandboxedBookmarksResolver = SandboxedBookmarksResolver { urls in
        dump(urls.map { $0.path }, name: "newSyncDirectories")
        syncController.directoryURLs = Set(urls)
    }
    
    override init() {
        super.init()
        
        dump(Bundle.main.bundlePath, name: "mainBundlePath")

        for status in TMStatus.allCases {
            if let image = imageForStatus(status) {
                syncController.setBadgeImage(image, label: labelForStatus(status), forBadgeIdentifier: badgeIdentifierForStatus(status))
            }
        }
    }
    
    // MARK: - Primary Finder Sync protocol methods
    
    override func beginObservingDirectory(at url: URL) {
        dump(url.path)
    }
    
    override func endObservingDirectory(at url: URL) {
        dump(url.path)
    }
    
    override func requestBadgeIdentifier(for url: URL) {
        dump(url.path)

        Task {
            let status = try! await statusProvider.statusForItem(url)
            dump((status, path: url.path), name: "status")
            let badgeIdentifier = badgeIdentifierForStatus(status)
            syncController.setBadgeIdentifier(badgeIdentifier, for: url)
        }
    }
    
    // MARK: - Menu and toolbar item support
    
    override var toolbarItemName: String {
        return "FinderSy"
    }
    
    override var toolbarItemToolTip: String {
        return "FinderSy: Click the toolbar item for a menu."
    }
    
    override var toolbarItemImage: NSImage {
        return NSImage(named: NSImage.cautionName)!
    }
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        let menu = NSMenu(title: "")
        menu.addItem(withTitle: "Exclude from Time Machine", action: #selector(excludeFromTimeMachine(_:)), keyEquivalent: "")
        return menu
    }
    
    @IBAction func excludeFromTimeMachine(_ sender: AnyObject?) {
        guard let itemURLs = syncController.selectedItemURLs() else {
            return
        }
        dump(itemURLs.map { $0.path }, name: "items")
        Task {
            try await TMUtilLauncher().removeExclusion(urls: itemURLs)
        }
    }
}
