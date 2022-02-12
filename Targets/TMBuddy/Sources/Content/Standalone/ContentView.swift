import SwiftUI
import Foundation

struct ContentView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Please check the list below to let \(appName) do its job.")
                .font(.headline)
                .fixedSize()
            
            SandboxAccessView.new()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
