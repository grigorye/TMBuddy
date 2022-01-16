import Foundation

extension NSString {
    
    func expandingTildeInPath(ignoringSandbox: Bool) -> String {
        let string = self.expandingTildeInPathImp(ignoringSandbox: ignoringSandbox) as NSString
        
        assert(string.pathComponents.count < 2 || (string.lastPathComponent == self.lastPathComponent))
        
        return string as String
    }
    
    func abbreviatingWithTildeInPath(ignoringSandbox: Bool) -> String {
        guard ignoringSandbox else {
            return self.abbreviatingWithTildeInPath
        }

        let currentUserHomeDirectoryPath = FileManager.default.homeDirectoryForCurrentUser(ignoringSandbox: true).path
        guard self.hasPrefix(currentUserHomeDirectoryPath) else {
            return self as String
        }
        
        return "~" + (self as String)[currentUserHomeDirectoryPath.count...]
    }

    
    private func expandingTildeInPathImp(ignoringSandbox: Bool) -> String {
        guard ignoringSandbox else {
            return self.expandingTildeInPath
        }
        let components = self.pathComponents
        guard let firstComponent = components.first else {
            return self.expandingTildeInPath
        }
        guard firstComponent.hasPrefix("~") else {
            return self.expandingTildeInPath
        }
        
        let fileManager = FileManager()
        guard firstComponent != "~" else {
            let homeDirectory = fileManager.homeDirectoryForCurrentUser(ignoringSandbox: true)
            return NSString.path(withComponents: homeDirectory.pathComponents + components[1...]) as String
        }
        
        let loginName = firstComponent[1...]
        
        guard let homeDirectory = fileManager.homeDirectory(forUser: loginName, ignoringSandbox: true) else {
            return self as String
        }
        
        return NSString.path(withComponents: homeDirectory.pathComponents + components[1...]) as String
    }
}
