import SwiftUI

struct CheckpointView<Content: View>: View {
    
    let title: String
    let subtitle: String?
    let value: String
    let completed: Bool
    
    @ViewBuilder
    let content: () -> Content
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            completed ? greenCheckmark: redXMark
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(title + ":")
                        Text(value)
                    }
                    if let subtitle = subtitle {
                        Text(" * " + subtitle)
                            .font(.footnote)
                    }
                }
                content()
            }
        }.fixedSize()
    }
}

private let greenCheckmark = Image(nsImage: NSImage(named: NSImage.statusAvailableName)!)
private let redXMark = Image(nsImage: NSImage(named: NSImage.statusUnavailableName)!)

struct CheckpointView_Previews : PreviewProvider {
    
    static var previews: some View {
        CheckpointView(
            title: "Title",
            subtitle: "Subtitle",
            value: "Value",
            completed: true
        ) {
            Text("Content")
        }
    }
}
