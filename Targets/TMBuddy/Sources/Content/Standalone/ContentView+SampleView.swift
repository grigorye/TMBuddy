import SwiftUI

struct ContentViewSampleState {
    var tab: ContentView.Tab
}

@available(macOS 11.0, *)
extension ContentView {
    typealias State = ContentViewSampleState
    typealias Actions = ()
    
    init(state: State, actions: ()?) {
        self.init(
            selection: state.tab
        )
    }
}

private typealias View = ContentView

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
