import SwiftUI

enum Readiness {
    case notActual
    case checking
    case blocked
    case ready
}

struct CheckpointView<Content: View>: View {
    
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey?
    let value: LocalizedStringKey
    let readiness: Readiness
    
    @ViewBuilder
    let content: () -> Content
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            { () -> Image in
                switch readiness {
                case .checking:
                    return yellowCheckmark
                case .ready:
                    return greenCheckmark
                case .blocked:
                    return redXMark
                case .notActual:
                    return grayCheckmark
                }
            }()
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(title) + Text(":")
                        Text(value)
                    }
                    if let subtitle = subtitle {
                        (Text(" * ") + Text(subtitle))
                            .font(.footnote)
                    }
                }
                content()
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

private let greenCheckmark = Image(nsImage: NSImage(named: NSImage.statusAvailableName)!)
private let yellowCheckmark = Image(nsImage: NSImage(named: NSImage.statusPartiallyAvailableName)!)
private let redXMark = Image(nsImage: NSImage(named: NSImage.statusUnavailableName)!)
private let grayCheckmark = Image(nsImage: NSImage(named: NSImage.statusNoneName)!)

let sampleCheckpointWidth: CGFloat = 360
