import SwiftUI
import Foundation

struct ContentView: View {
    
    var body: some View {
        if #available(macOS 11.0, *) {
            TabView {
                SandboxAccessView.new()
                    .tabItem {
                        Text("Setup")
                    }
                    .padding()
                
                LegendView()
                    .frame(minHeight: 240)
                    .tabItem {
                        Text("Legend")
                    }
            }
            .padding()
        } else {
            VStack(alignment: .leading) {
                Text("Setup")
                GroupBox {
                    SandboxAccessView.new()
                        .padding()
                }
                
                Text("Legend")
                GroupBox() {
                    LegendView()
                        .padding()
                }
                
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
