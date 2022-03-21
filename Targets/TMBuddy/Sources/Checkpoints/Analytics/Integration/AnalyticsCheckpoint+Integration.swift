import SwiftUI

extension AnalyticsCheckpointView {
    
    static func new() -> some View {
        let suppressActionTrackingProvider = BoolUserDefaultsProvider(key: DefaultsKey.suppressActionTracking.rawValue)
        return ObservableWrapperView(suppressActionTrackingProvider) { provider in
            Self(
                state: .init(analyticsEnabled: !provider.value),
                actions: AnalyticsCheckpointActionsHandler()
            )
        }
    }
}
