import Cocoa
import FinderSync

func badgeIdentifierForStatus(_ status: TMStatus) -> String {
    status.rawValue
}

func labelForStatus(_ status: TMStatus) -> String {
    "\(status)"
}

let syncController = FIFinderSyncController.default()

class FinderSync: FIFinderSync {

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
    
    func updateBadgeIdentifier(for url: URL) {
        Task {
            let status = try! await statusProvider.statusForItem(url)
            dump((status, path: url.path), name: "status")
            let badgeIdentifier = badgeIdentifierForStatus(status)
            syncController.setBadgeIdentifier(badgeIdentifier, for: url)
        }
    }
    
    func refreshItem(at url: URL) {
        dump(url.path, name: "path")
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
        addMetadataExclusionMenuItems(menu)
        addPathExclusionMenuItems(menu)
        return menu
    }
    
    private func addMetadataExclusionMenuItems(_ menu: NSMenu) {
        let itemURLs = syncController.selectedItemURLs() ?? []
        let exclusions = itemURLs.map { metadataReader.excludedBasedOnMetadata($0) }
        let mask = Set(exclusions)
        
        if mask.contains(true) {
            menu.addItem(
                withTitle: NSLocalizedString("Remove Exclusion from Time Machine", comment: ""),
                action: #selector(removeExclusionFromTimeMachine(_:)),
                keyEquivalent: ""
            )
        }
        if mask.contains(false) {
            menu.addItem(
                withTitle: NSLocalizedString("Exclude from Time Machine", comment: ""),
                action: #selector(excludeFromTimeMachine(_:)),
                keyEquivalent: ""
            )
        }
    }
    
    private func addPathExclusionMenuItems(_ menu: NSMenu) {
        let itemURLs = syncController.selectedItemURLs() ?? []
        let exclusions = itemURLs.map { url -> Bool in
            let status = try? DirectLookupBasedStatusProvider().statusForItem(url)
            dump((status, item: url.path), name: "statusForItem")
            return status == .pathExcluded
        }
        let mask = Set(exclusions)
        
        if mask.contains(true) {
            menu.addItem(
                withTitle: NSLocalizedString("Remove Path Exclusion from Time Machine", comment: ""),
                action: #selector(removePathExclusionFromTimeMachine(_:)),
                keyEquivalent: ""
            )
        }
        if mask.contains(false) {
            menu.addItem(
                withTitle: NSLocalizedString("Exclude Path from Time Machine", comment: ""),
                action: #selector(excludePathFromTimeMachine(_:)),
                keyEquivalent: ""
            )
        }
    }
    
    @IBAction func removePathExclusionFromTimeMachine(_ sender: AnyObject?) {
        setSelectedItemsPathExcludedFromTimeMachine(false)
    }
    
    @IBAction func excludePathFromTimeMachine(_ sender: AnyObject?) {
        setSelectedItemsPathExcludedFromTimeMachine(true)
    }

    private func setSelectedItemsPathExcludedFromTimeMachine(_ exclude: Bool) {
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
            
            try await TMUtilPrivileged().setExcludedByPath(exclude, urls: itemURLs)
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
            NSApp.presentError(error)
        }
    }
    
    @IBAction func removeExclusionFromTimeMachine(_ sender: AnyObject?) {
        setSelectedItemsStickyExcludedFromTimeMachine(false)
    }
    
    @IBAction func excludeFromTimeMachine(_ sender: AnyObject?) {
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
            NSApp.presentError(error)
        }
    }
}

private let defaults = UserDefaults.standard
