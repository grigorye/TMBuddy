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
                        Text(value).font(.callout)
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

private let greenCheckmark = Text("􀁣").foregroundColor(.green)
private let redXMark = Text("􀁠").foregroundColor(.red)

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
