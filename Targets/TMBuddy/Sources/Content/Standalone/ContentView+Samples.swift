import Foundation

extension ContentViewSampleState {
    
    typealias State = Self
    
    static let none = Self(tab: .setup)

    struct Sample: CaseIterable, StateSample {
        static var allCases: [ContentViewSampleState.Sample] {
            ContentView.Tab.allCases.map { tab in
                Sample(tab: tab)
            }
        }
        
        typealias Namespace = State
        
        var tab: ContentView.Tab
        
        var state: State {
            .init(tab: tab)
        }
    }
}

