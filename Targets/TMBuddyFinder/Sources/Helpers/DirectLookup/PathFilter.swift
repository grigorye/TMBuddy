import Foundation

struct PathFilter {
    
    let skipPaths: [String]
    
    func isExcluded(_ url: URL) -> Bool {
        skipPaths.contains(where: { url.path.hasPrefix($0) })
    }
}
