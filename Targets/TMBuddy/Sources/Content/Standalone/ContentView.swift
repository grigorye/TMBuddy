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
                
                LegendView.new()
                    .frame(minHeight: 240)
                    .tabItem {
                        Text("Legend")
                    }
            }
            .padding()
            .frame(width: 640)
        } else {
            VStack(alignment: .leading) {
                VStack {
                    GroupBox {
                        SandboxAccessView.new()
                            .padding()
                    }
                }.frame(maxWidth: 640)
                
                VStack(alignment: .leading) {
                    Text("Legend")
                    GroupBox() {
                        LegendView.new()
                            .padding()
                    }
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
