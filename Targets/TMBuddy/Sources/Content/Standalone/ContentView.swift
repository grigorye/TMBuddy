import SwiftUI
import Foundation

struct ContentView: View {
    
    var body: some View {
        TabView {
            SandboxAccessView.new()
                .tabItem {
                    Text("Setup")
                }
                .padding()
            
            LegendView()
                .tabItem {
                    Text("Legend")
                }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
