import SwiftUI

struct FolderListViewSampleState {
    var urls: [URL]
}

@available(macOS 11.0, *)
extension FolderListView {
    typealias State = FolderListViewSampleState
    typealias Actions = ()
    
    init(state: State, actions: ()?) {
        self.init(
            urls: state.urls,
            urlFromItemProvider: { _ in fatalError() },
            updateURLs: { _ in fatalError() }
        )
    }
}

private typealias View = FolderListView

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
