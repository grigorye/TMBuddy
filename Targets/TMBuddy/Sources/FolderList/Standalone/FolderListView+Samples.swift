import Foundation

extension FolderListViewSampleState {
    
    typealias State = Self
    
    static let none = Self(urls: [])

    enum Sample: CaseIterable, StateSample {
        
        typealias Namespace = State
        
        case none
        case many
        
        var state: State {
            switch self {
            case .none:
                return .init(urls: [])
            case .many:
                return .init(urls: [
                    URL(fileURLWithPath: "/"),
                    FileManager.default.homeDirectory(forUser: "admin") ?? URL(fileURLWithPath: "/tmp")
                ])
            }
        }
    }
}
