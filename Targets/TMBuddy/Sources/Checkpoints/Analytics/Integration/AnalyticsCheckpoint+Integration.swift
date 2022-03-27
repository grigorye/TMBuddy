import SwiftUI

extension AnalyticsCheckpointView {
    
    static func new() -> some View {
        let analyticsEnabledValueProvider = BoolUserDefaultsProvider(key: DefaultsKey.analyticsEnabled.rawValue, defaults: sharedDefaults)
        return ObservableWrapperView(analyticsEnabledValueProvider) { provider in
            Self(
                state: .init(analyticsEnabled: provider.value),
                actions: AnalyticsCheckpointActionsHandler()
            )
        }
    }
}
