import Foundation

extension Array where Element == URL {
    var paths: [String] {
        map { $0.path }
    }
}
