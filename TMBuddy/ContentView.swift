import SwiftUI

struct ContentView: View {
    init() {
        Task {
            let status = try await TMStatusProvider().statusForItem(URL(fileURLWithPath: "/tmp"))
            dump(status, name: "status")
        }
    }
    var body: some View {
        Text("Hi there!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
