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

let statusProvider: TMStatusProvider = {
    guard UserDefaults.standard.bool(forKey: "ForceTMUtilBasedStatusProvider") == false else {
        return TMUtilBasedStatusProvider()
    }
    return DirectLookupBasedStatusProvider()
}()

class FinderSync: FIFinderSync {

    let sandboxedBookmarksResolver = SandboxedBookmarksResolver { urls in
        dump(urls.map { $0.path }, name: "newSyncDirectories")
        try! saveScopedSandboxedBookmark(urls: urls, in: defaults)
        let scopedURLs = resolveBookmarks(defaults.scopedSandboxedBookmarks ?? [], options: [.withSecurityScope])
        
        for url in syncController.directoryURLs {
            url.stopAccessingSecurityScopedResource()
        }
        syncController.directoryURLs = Set(scopedURLs)
        for url in syncController.directoryURLs {
            let succeeded = url.startAccessingSecurityScopedResource()
            dump((path: url.path, succeeded: succeeded), name: "startAccessingScoped")
        }
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
        updateBadgeIdentifier(for: url)
    }
    
    func updateBadgeIdentifier(for url: URL) {
        Task {
            let status = try! await statusProvider.statusForItem(url)
            dump((status, path: url.path), name: "status")
            let badgeIdentifier = badgeIdentifierForStatus(status)
            syncController.setBadgeIdentifier(badgeIdentifier, for: url)
        }
    }
    
    func refreshItem(at url: URL) {
        dump(url)
        updateBadgeIdentifier(for: url)
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
        
        let itemURLs = syncController.selectedItemURLs() ?? []
        let exclusions = itemURLs.map { metadataReader.excludedBasedOnMetadata($0) }
        let mask = Set(exclusions)
        
        if mask.contains(true) {
            menu.addItem(
                withTitle: "Remove Exclusion from Time Machine",
                action: #selector(removeExclusionFromTimeMachine(_:)),
                keyEquivalent: ""
            )
        }
        if mask.contains(false) {
            menu.addItem(
                withTitle: "Exclude from Time Machine",
                action: #selector(excludeFromTimeMachine(_:)),
                keyEquivalent: ""
            )
        }
        return menu
    }
    
    @IBAction func removeExclusionFromTimeMachine(_ sender: AnyObject?) {
        dump(self)
        guard let itemURLs = syncController.selectedItemURLs() else {
            return
        }
        dump(itemURLs.map { $0.path }, name: "items")
        Task {
            defer {
                dump(itemURLs.map { $0.path }, name: "itemsToRefresh")
                for itemURL in itemURLs {
                    refreshItem(at: itemURL)
                }
            }
            
            try await metadataWriter.setExcluded(false, urls: itemURLs)
        }
    }
    
    @IBAction func excludeFromTimeMachine(_ sender: AnyObject?) {
        dump(self)
        guard let itemURLs = syncController.selectedItemURLs() else {
            return
        }
        dump(itemURLs.map { $0.path }, name: "items")
        Task {
            defer {
                dump(itemURLs.map { $0.path }, name: "itemsToRefresh")
                for itemURL in itemURLs {
                    refreshItem(at: itemURL)
                }
            }
            
            try await metadataWriter.setExcluded(true, urls: itemURLs)
        }
    }
}

private let defaults = UserDefaults.standard
