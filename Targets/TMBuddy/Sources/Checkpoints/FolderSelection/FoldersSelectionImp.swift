import Foundation

func processURLs(_ urls: [URL]) {
    dump(urls.paths, name: "paths")
    
    try! saveScopedSandboxedBookmark(urls: urls, in: defaults)
    try! saveSandboxedBookmark(urls: urls, in: sharedDefaults)
    
    do {
        let succeeded = sharedDefaults.synchronize()
        dump(succeeded, name: "sharedDefaultsSyncSucceeded")
    }
}

private let defaults = UserDefaults.standard
