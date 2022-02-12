private typealias View = FinderSyncExtensionCheckpointView

// MARK: - Boilerplate -

import SwiftUI

extension View: SampledView {
    static var sampleStateEnvironmentValuesKeyPath: SampleStateEnvironmentValuesKeyPath {
        \.sampleState
    }
}

extension EnvironmentValues {
    fileprivate var sampleState: View.State {
        get { self[SampleView<View>.SampleEnvironmentKey.self] }
        set { self[SampleView<View>.SampleEnvironmentKey.self] = newValue }
    }
}

extension View.State: StateWithSample {}
extension View.State.Sample: StateProducing {}
