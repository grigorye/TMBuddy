import SwiftUI

struct AnalyticsCheckpointView: View {

    struct State {
        let analyticsEnabled: Bool
    }
    
    let state: State
    let actions: AnalyticsCheckpointActions?
    
    var body: some View {
        CheckpointView(
            title: "Analytics",
            subtitle: "Let \(appName) gather information about its usage, for further improvements.",
            value: state.analyticsEnabled ? "enabled" : "disabled",
            readiness: .ready
        ) {
            switch state.analyticsEnabled {
            case false:
                Button("Enable Analytics") {
                    actions?.setAnalyticsEnabled()
                }
            case true:
                Button("Disable Analytics") {
                    actions?.setAnalyticsDisabled()
                }
            }
        }
        .onVisibilityChange(perform: actions?.track(visible:))
    }
}
