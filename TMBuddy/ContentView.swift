import SwiftUI
import Foundation

let appName = FileManager.default.displayName(atPath: Bundle.main.bundlePath)
let finderName = FileManager.default.displayName(atPath: "/System/Library/CoreServices/Finder.app")

struct ContentView: View {
    
    var body: some View {
        VStack {
            Text("Please see [Instructions](https://github.com/grigorye/TMBuddy#installation) on how to enable \(appName) in \(finderName).")
                .fixedSize()
            SandboxAccessView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
