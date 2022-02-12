import SwiftUI

protocol StateWithSample {
    associatedtype Sample: CaseIterable, StateProducing
    where
    Sample.State == Self, Sample: SampleNaming
    
    static var none: Self { get }
}

protocol StateProducing {
    associatedtype State
    var state: State { get }
}

protocol SampledView: View {
    associatedtype State: StateWithSample
    associatedtype Actions
    init(state: State, actions: Actions?)
    static var sampleStateEnvironmentValuesKeyPath: WritableKeyPath<EnvironmentValues, State> { get }
}

extension SampledView {
    
    typealias SampleStateEnvironmentValuesKeyPath = WritableKeyPath<EnvironmentValues, State>
    
    static func new() -> some View {
        SampleView<Self>()
    }
}

struct SampleView<Content: SampledView>: View {
    
    @Environment(Content.sampleStateEnvironmentValuesKeyPath) private var sampleState
    
    var body: some View {
        Content(state: sampleState, actions: nil)
    }
    
    struct SampleEnvironmentKey: EnvironmentKey {
        static var defaultValue: Content.State { .none }
    }
}

extension SwiftUI.View {
    
    func sample<Content: SampledView>(for: Content.Type, sample: Content.State) -> some SwiftUI.View {
        environment(Content.sampleStateEnvironmentValuesKeyPath, sample)
    }
    
    func state<Content: SampledView>(_ value: Content.State, for: Content.Type) -> some SwiftUI.View {
        environment(Content.sampleStateEnvironmentValuesKeyPath, value)
    }
}
