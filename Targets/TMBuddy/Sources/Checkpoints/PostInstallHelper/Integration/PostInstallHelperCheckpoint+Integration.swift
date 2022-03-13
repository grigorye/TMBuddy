import SwiftUI

extension PostInstallHelperCheckpointView {
    
    static func new() -> some View {
        ObservableWrapperView(
            SMJobBlessCheckpointProvider(),
            PostInstallHelperCheckpointProvider()
        ) { bless, postInstall in
            Self(
                state: .init(bless: bless.state, postInstall: postInstall.state),
                actions: PostInstallHelperCheckpointActionHandler()
            )
        }
    }
}
