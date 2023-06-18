import AppKit

@MainActor
func snapshotFlakyBorderWindow(window: NSWindow, snapshotBaseURL: URL) {
    // Snapshot shadowless, and *bail out* unless it changed.
    do {
        let snapshotURL = snapshotBaseURL.appendingPathExtension("borderless.png")
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
        let snapshotURL = snapshotBaseURL.appendingPathExtension("png")
        let snapshot = try! window.snapshot(options: [.bestResolution])
        let newBitmapRep = NSBitmapImageRep(data: snapshot.tiffRepresentation!)!.representation(using: .png, properties: [:])!
        try! newBitmapRep.write(to: snapshotURL)
    }
}
