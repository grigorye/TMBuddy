import SwiftUI

struct AppStateSample: CaseIterable {
    var allGreen: Bool
    var tab: ContentView.Tab

    static var allCases: [AppStateSample] {
        [true, false].flatMap { allGreen in
            [ContentView.Tab]([.folders, .setup]).map { tab in
                Self(allGreen: allGreen, tab: tab)
            }
        }
    }
}

extension View {
    
    func appStateSample(_ state: AppStateSample) -> some SwiftUI.View {
        let view: AnyView
        if state.allGreen {
            view = AnyView(allGreen())
        } else {
            view = AnyView(allRed())
        }
        return view
            .state(
                .init(tab: state.tab),
                for: ContentView.self
            )
    }
    
    private func allGreen() -> some SwiftUI.View {
        self
#if GE_BLESS
            .state(
                .blessed,
                for: SMJobBlessCheckpointView.self
            )
            .state(
                .init(bless: .blessed, postInstall: .completed),
                for: PostInstallHelperCheckpointView.self
            )
#endif
            .state(
                .init(bookmarkCount: 3),
                for: FolderSelectionCheckpointView.self
            )
            .state(
                .init(urls: [
                    URL(fileURLWithPath: "/"),
                    FileManager.default.homeDirectory(forUser: "admin") ?? URL(fileURLWithPath: "/tmp"),
                    URL(fileURLWithPath: "/Users/Shared"),
                ]),
                for: FolderListView.self
            )
            .state(
                .init(
                    fullDiskAccess: .granted,
                    finderSync: .init(enabled: true, alienInfo: .same)
                ),
                for: PlugInFullDiskAccessCheckpointView.self
            )
            .state(
                .init(enabled: true, alienInfo: .same),
                for: FinderSyncExtensionCheckpointView.self
            )
    }
    
    private func allRed() -> some SwiftUI.View {
        self
#if GE_BLESS
            .state(
                .missingBless,
                for: SMJobBlessCheckpointView.self
            )
            .state(
                .init(bless: .missingBless, postInstall: .pending),
                for: PostInstallHelperCheckpointView.self
            )
#endif
            .state(
                .none,
                for: FolderSelectionCheckpointView.self
            )
            .state(
                .none,
                for: FolderListView.self
            )
            .state(
                .init(fullDiskAccess: .denied, finderSync: .init(enabled: false, alienInfo: .none)),
                for: PlugInFullDiskAccessCheckpointView.self
            )
            .state(
                .init(enabled: false, alienInfo: .none),
                for: FinderSyncExtensionCheckpointView.self
            )
    }
}
