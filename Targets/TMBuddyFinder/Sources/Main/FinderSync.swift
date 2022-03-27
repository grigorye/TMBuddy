import Cocoa
import FinderSync
import os.signpost

func badgeIdentifierForStatus(_ status: TMStatus) -> String {
    status.rawValue
}

func labelForStatus(_ status: TMStatus) -> String {
    "\(status)"
}

let syncController = FIFinderSyncController.default()

class FinderSync: FIFinderSync, MenuGeneratorActions {

    let hostAppConnectionController = HostAppConnectionController()
    
    private var directoryURLs: [URL] = [] {
        willSet {
            syncController.directoryURLs = Set(newValue)
        }
    }
    
    private func setDirectoryURLs(accessedScoped: Bool) {
        for url in directoryURLs {
            if accessedScoped {
                let succeeded = url.startAccessingSecurityScopedResource()
                dump((url.path, succeeded: succeeded), name: "startAccessingScoped")
            } else {
                dump((url.path), name: "stopAccessingScoped")
                url.stopAccessingSecurityScopedResource()
            }
        }
    }
    
    private lazy var sandboxedBookmarksResolver = SandboxedBookmarksResolver { [weak self] urls in
        self?.updateForResolvedURLs(urls)
    }
    
    deinit {
        dump(self.directoryURLs.map { $0.path }, name: "directoryURLs")
        self.setDirectoryURLs(accessedScoped: false)
        
        dump(Bundle.main.bundlePath, name: "bundlePath")
    }
    
    override init() {
        super.init()
        
        dump(Bundle.main.bundlePath, name: "bundlePath")

        onLaunch()
        
        for status in TMStatus.allCases {
            if let image = imageForStatus(status) {
                syncController.setBadgeImage(image, label: labelForStatus(status), forBadgeIdentifier: badgeIdentifierForStatus(status))
            }
        }
        
        _ = sandboxedBookmarksResolver
    }
    
    // MARK: -
    
    func updateForResolvedURLs(_ urls: [URL]) {
        dump(urls.map { $0.path }, name: "newSyncDirectories")
        saveScopedSandboxedBookmark(urls: urls, in: defaults)
        let scopedURLs = resolveBookmarks(defaults.scopedSandboxedBookmarks ?? [], options: [.withSecurityScope])
        
        self.setDirectoryURLs(accessedScoped: false)
        self.directoryURLs = scopedURLs
        self.setDirectoryURLs(accessedScoped: true)
    }
    
    // MARK: - Primary Finder Sync protocol methods
    
    override func beginObservingDirectory(at url: URL) {
        dump(url.path, name: "path")
    }
    
    override func endObservingDirectory(at url: URL) {
        dump(url.path, name: "path")
    }
    
    override func requestBadgeIdentifier(for url: URL) {
        dump(url.path, name: "path")
        updateBadgeIdentifier(for: url)
    }
    
    // MARK: -
    
    var statusProvider: DirectLookupBasedStatusProvider { .init() }

    func updateBadgeIdentifier(for url: URL) {
        let activity = beginActivity(url.path, name: "updateBadgeIdentifier")
        Task {
            self.updateBadgeIdentifierSync(for: url)
            activity.end(url.path)
        }
    }
    
    func updateBadgeIdentifierSync(for url: URL) {
        let status = statusProvider.statusForItem(url)
        dump((status, path: url.path), name: "status")
        let badgeIdentifier = badgeIdentifierForStatus(status)
        syncController.setBadgeIdentifier(badgeIdentifier, for: url)
    }
    
    func refreshItem(at url: URL) {
        dump(url.path, name: "path")
        updateBadgeIdentifier(for: url)
    }

    // MARK: - Menu and toolbar item support
    
    override var toolbarItemName: String {
        if ({false}()) {
            guard let appBundle = Bundle.main.plugInRelativeAppBundle else {
                dump(Bundle.main.bundlePath, name: "plugInRelativeAppBundleFailed")
                return ""
            }
            return FileManager.default.displayName(atPath: appBundle.bundlePath)
        } else {
            return NSLocalizedString("Backup", comment: "")
        }
    }
    
    override var toolbarItemToolTip: String {
        NSLocalizedString("Exclude or include items into backup", comment: "")
    }
    
    override var toolbarItemImage: NSImage {
        NSWorkspace.shared.icon(forFile: Bundle.main.bundlePath)
    }
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        let menu = NSMenu(title: "")
        let itemURLs = syncController.selectedItemURLs() ?? []
        let itemsURLsByIsVolume = Dictionary(grouping: itemURLs) { $0.isVolume() }

        if itemsURLsByIsVolume.count == 2 {
            // Do nothing on mixed selection.
        } else {
            if let volumeURLs = itemsURLsByIsVolume[true] {
                addVolumeExclusionMenuItems(menu, itemURLs: volumeURLs)
            }
            if let nonVolumeURLs = itemsURLsByIsVolume[false] {
                addMetadataExclusionMenuItems(menu, itemURLs: nonVolumeURLs)
                addPathExclusionMenuItems(menu, itemURLs: nonVolumeURLs)
                addRevealParentExclusionsMenuItems(menu, url: nonVolumeURLs.first!)
            }
        }
        return menu
    }
    
    private func addRevealParentExclusionsMenuItems(_ menu: NSMenu, url: URL) {
        let menuItems = menuItemsForParentPaths(url: url)
        guard menuItems.isEmpty == false else {
            dump(url.path, name: "pathHasNoItemsToDisplayForParentExclusions")
            return
        }
        MenuGenerator().addRevealParentExclusionsMenuItems(menu: menu, menuItems: menuItems)
    }
    
    private func menuItemsForParentPaths(url: URL) -> [NSMenuItem] {
        guard statusProvider.statusForItem(url) != .included else {
            return []
        }
        let parentPaths = parentPaths(for: url).reversed().dropFirst()
        let parentURLs = parentPaths.map { URL(fileURLWithPath: $0, isDirectory: true) }
        return parentURLs.compactMap { parentURL in
            let status = statusProvider.statusForItem(parentURL)
            dump((status, path: parentURL.path), name: "status")
            if status == .parentExcluded || status == .included {
                return nil
            }
            let displayName = FileManager.default.displayName(atPath: parentURL.path)
            let badge = imageForStatus(status)!
            return NSMenuItem() ≈ {
                $0.title = displayName
                $0.action = #selector(revealParentFrom(menuItem:))
                $0.target = self
                $0.image = badge
                $0.tag = parentURLs.firstIndex(of: parentURL)!
            }
        }
    }
    
    @objc private func revealParentFrom(menuItem: NSMenuItem) {
        dump((), name: "")
        let selectedURL = syncController.selectedItemURLs()!.first!
        let parentPaths = Array(parentPaths(for: selectedURL).reversed().dropFirst())
        let url = URL(fileURLWithPath: parentPaths[menuItem.tag])
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }

    private func addMetadataExclusionMenuItems(_ menu: NSMenu, itemURLs: [URL]) {
        let exclusions = itemURLs.map { metadataReader.excludedBasedOnMetadata($0) }
        let excluded = Set(exclusions)
        MenuGenerator().addMetadataExclusionsMenuItems(menu: menu, excluded: excluded)
    }
    
    private func addPathExclusionMenuItems(_ menu: NSMenu, itemURLs: [URL]) {
        let exclusions = itemURLs.map { url -> Bool in
            statusProvider.isPathExcluded(url)
        }
        let excluded = Set(exclusions)
        MenuGenerator().addPathExclusionMenuItems(menu: menu, excluded: excluded)
    }
    
    private func addVolumeExclusionMenuItems(_ menu: NSMenu, itemURLs: [URL]) {
        let exclusions = itemURLs.map { url -> Bool in
            statusProvider.isVolumeExcluded(url)
        }
        let excluded = Set(exclusions)
        MenuGenerator().addVolumeExclusionsMenuItems(menu: menu, excluded: excluded)
    }
    
    @IBAction func removePrivilegedExclusionFromTimeMachine(_ sender: AnyObject?) {
        dump((), name: "")
        setSelectedItemsPrivilegeExcludedFromTimeMachine(false)
    }
    
    @IBAction func addPrivilegedExclusionInTimeMachine(_ sender: AnyObject?) {
        dump((), name: "")
        setSelectedItemsPrivilegeExcludedFromTimeMachine(true)
    }

    private func setSelectedItemsPrivilegeExcludedFromTimeMachine(_ exclude: Bool) {
        guard let itemURLs = syncController.selectedItemURLs() else {
            dump(0, name: "itemCount")
            return
        }
        dump(itemURLs.map { $0.path }, name: "items")
        let task = Task {
            defer {
                dump(itemURLs.map { $0.path }, name: "itemsToRefresh")
                for itemURL in itemURLs {
                    refreshItem(at: itemURL)
                }
            }
            
            let itemsURLsByIsVolume = Dictionary(grouping: itemURLs) { $0.isVolume() }
            if let volumeURLs = itemsURLsByIsVolume[true] {
                try await TMUtilPrivileged().setExcluded(exclude, privilege: .volume, urls: volumeURLs)
            }
            if let nonVolumeURLs = itemsURLsByIsVolume[false] {
                try await TMUtilPrivileged().setExcluded(exclude, privilege: .fixedPath, urls: nonVolumeURLs)
            }
        }
        Task {
            let result = await task.result
            dump((result, exclude: exclude, items: itemURLs.map { $0.path }), name: "result")
            DispatchQueue.main.async {
                self.processResultForSetSelectedItemsPathExcludedFromTimeMachine(exclude, result: result)
            }
        }
    }
    
    private func processResultForSetSelectedItemsPathExcludedFromTimeMachine(_ exclude: Bool, result: Result<(), Error>) {
        if case let .failure(error) = result {
            dump((error, exclude: exclude), name: "setSelectedItemsPathExcludedFailed")
            NSApp.presentError(error)
        }
    }
    
    @IBAction func removeExclusionFromTimeMachine(_ sender: AnyObject?) {
        dump((), name: "")
        setSelectedItemsStickyExcludedFromTimeMachine(false)
    }
    
    @IBAction func excludeFromTimeMachine(_ sender: AnyObject?) {
        dump((), name: "")
        setSelectedItemsStickyExcludedFromTimeMachine(true)
    }
    
    private func setSelectedItemsStickyExcludedFromTimeMachine(_ exclude: Bool) {
        guard let itemURLs = syncController.selectedItemURLs() else {
            dump(0, name: "itemCount")
            return
        }
        dump((itemURLs.map { $0.path }, exclude: exclude), name: "items")
        let task = Task {
            defer {
                dump((itemURLs.map { $0.path }, exclude: exclude), name: "itemsToRefresh")
                for itemURL in itemURLs {
                    refreshItem(at: itemURL)
                }
            }
            
            try metadataWriter.setExcluded(exclude, urls: itemURLs)
        }
        Task {
            let result = await task.result
            dump((result, exclude: exclude, items: itemURLs.map { $0.path }), name: "result")
            DispatchQueue.main.async {
                self.processResultForSetSelectedItemsPathExcludedFromTimeMachine(exclude, result: result)
            }
        }
    }
    
    private func processResultForSetSelectedItemsStickyExcludedFromTimeMachine(_ exclude: Bool, result: Result<(), Error>) {
        if case let .failure(error) = result {
            dump((error, exclude: exclude), name: "setSelectedItemsStickyExcludedFailed")
            NSApp.presentError(error)
        }
    }
}

private let defaults = UserDefaults.standard
