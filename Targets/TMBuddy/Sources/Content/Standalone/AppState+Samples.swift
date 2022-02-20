import SwiftUI

enum AppStateSample: CaseIterable {
    case allGreen
    case allRed
}

extension View {
    
    func appStateSample(_ state: AppStateSample) -> some SwiftUI.View {
        switch state {
        case .allGreen:
            return AnyView(allGreen())
        case .allRed:
            return AnyView(allRed())
        }
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
                .init(fullDiskAccess: .denied, finderSync: .init(enabled: false, alienInfo: .none)),
                for: PlugInFullDiskAccessCheckpointView.self
            )
            .state(
                .init(enabled: false, alienInfo: .none),
                for: FinderSyncExtensionCheckpointView.self
            )
    }
}
