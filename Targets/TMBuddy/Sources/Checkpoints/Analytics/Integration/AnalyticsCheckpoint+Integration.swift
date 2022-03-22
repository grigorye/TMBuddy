import SwiftUI

extension AnalyticsCheckpointView {
    
    static func new() -> some View {
        let forceActionTrackingProvider = BoolUserDefaultsProvider(key: DefaultsKey.forceActionTracking.rawValue)
        return ObservableWrapperView(forceActionTrackingProvider) { provider in
            Self(
                state: .init(analyticsEnabled: provider.value),
                actions: AnalyticsCheckpointActionsHandler()
            )
        }
    }
}
