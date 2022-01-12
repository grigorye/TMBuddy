import SwiftUI
import Foundation

let appName = FileManager.default.displayName(atPath: Bundle.main.bundlePath)
let finderName = FileManager.default.displayName(atPath: "/System/Library/CoreServices/Finder.app")

struct ContentView: View {
    
    var body: some View {
        VStack {
            prompt()
                .fixedSize()
            
            Divider().hidden()
            
            SandboxAccessView()
        }
        .padding()
    }
}

@ViewBuilder
private func prompt() -> some View {
    if #available(macOS 12, *) {
        Text("Please see [Instructions](https://github.com/grigorye/TMBuddy#installation) on how to enable \(appName) in \(finderName).")
    } else {
        Button(
            action: {
                NSWorkspace.shared.open(URL(string: "https://github.com/grigorye/TMBuddy#installation")!)
            },
            label: {
                Text("How to enable \(appName) in \(finderName).")
                    .underline()
                    .foregroundColor(Color.blue)
            }
        )
            .buttonStyle(PlainButtonStyle())
            .onHover { inside in
                if inside {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
