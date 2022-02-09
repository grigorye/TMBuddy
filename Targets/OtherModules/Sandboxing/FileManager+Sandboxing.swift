import Foundation

extension FileManager {
    
    func homeDirectoryForCurrentUser(ignoringSandbox: Bool) -> URL {
        guard ignoringSandbox else {
            return homeDirectoryForCurrentUser
        }
        
        // Borrowed from https://stackoverflow.com/a/46789483/1859783
        
        let pw = getpwuid(getuid())
        
        let home = pw!.pointee.pw_dir!
        let homePath = self.string(
            withFileSystemRepresentation: home,
            length: strlen(home)
        )
        
        return URL(fileURLWithPath: homePath)
    }
    
    func homeDirectory(forUser user: String, ignoringSandbox: Bool) -> URL? {
        guard ignoringSandbox else {
            return homeDirectory(forUser: user)
        }
		
		guard let pw = getpwnam(user) else {
			dump(user, name: "getpwnamFailure")
			return nil
		}
		
		guard let home = pw.pointee.pw_dir else {
			return nil
		}
		
        let homePath = self.string(
            withFileSystemRepresentation: home,
            length: strlen(home)
        )
        
        return URL(fileURLWithPath: homePath)
    }
}
