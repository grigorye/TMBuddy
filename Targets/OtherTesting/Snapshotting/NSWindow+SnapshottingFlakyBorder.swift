import AppKit

@MainActor
func snapshotFlakyBorderWindow(window: NSWindow, snapshotBaseURL: URL) {
    let borderlessSnapshotURL = snapshotBaseURL.appendingPathExtension("borderless.png")
    let shadowSnapshotURL = snapshotBaseURL.appendingPathExtension("png")
    defer {
        try? FileManager.default.setAttributes([.modificationDate: Date()], ofItemAtPath: borderlessSnapshotURL.path)
        try? FileManager.default.setAttributes([.modificationDate: Date()], ofItemAtPath: shadowSnapshotURL.path)
    }
    // Snapshot shadowless, and *bail out* unless it's changed.
    do {
        let snapshotURL = borderlessSnapshotURL
        let snapshot = try! window.snapshot(options: [.bestResolution, .boundsIgnoreFraming])
        let newBitmapRep = NSBitmapImageRep(data: snapshot.tiffRepresentation!)!.representation(using: .png, properties: [:])!
        if let oldBitmapRep = try? Data(contentsOf: snapshotURL) {
            guard oldBitmapRep != newBitmapRep else {
                return // Avoid recording yet another (flaky) snapshot with shadow.
            }
        }
        try! FileManager.default.createDirectory(at: snapshotURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try! newBitmapRep.write(to: snapshotURL)
    }
    
    // Take another snapshot variant, now with shadow.
    do {
        let snapshotURL = shadowSnapshotURL
        let snapshot = try! window.snapshot(options: [.bestResolution])
        let newBitmapRep = NSBitmapImageRep(data: snapshot.tiffRepresentation!)!.representation(using: .png, properties: [:])!
        try! newBitmapRep.write(to: snapshotURL)
    }
}
