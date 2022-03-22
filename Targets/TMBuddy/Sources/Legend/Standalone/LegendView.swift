import SwiftUI
import AppKit

struct LegendView: View {
    
    struct State {}

    let state: State
    let actions: LegendViewActions!

    var body: some View {
        let cases = TMStatus.allCases.filter { [.included, .unknown].contains($0) == false }
        VStack(alignment: .leading) {
            ForEach(cases, id: \.self) { status in
                let sampleImage = sampleImageForStatus(status)
                let badge = Image(nsImage: imageForStatus(status)!)
                let label = localizedStatus(status)

                HStack {
                    ImageWithBadge(image: sampleImage, badge: badge, scale: 0.4)
                    Text(label)
                }
            }
        }
        .padding()
        .fixedSize()
        .onVisibilityChange(perform: actions?.track(visible:))
    }
}

func sampleImageForStatus(_ status: TMStatus) -> Image {
    let sampleIcon: NSImage = {
        switch status {
        case .unsupportedVolume:
            return volumeIcon
        case .excludedVolume:
            return volumeIcon
        case .included:
            return folderIcon
        case .parentExcluded:
            return folderIcon
        case .stickyExcluded:
            return folderIcon
        case .pathExcluded:
            return folderIcon
        case .unknown:
            return folderIcon
        }
    }()

    let sampleNSImage = sampleIcon ≈ {
        $0.size = .init(width: 128, height: 128)
    }
    let sampleImage = Image(nsImage: sampleNSImage)
    return sampleImage
}

var folderIcon: NSImage {
    NSWorkspace.shared.icon(forFile: FileManager.default.temporaryDirectory.path)
}

var volumeIcon: NSImage {
    NSWorkspace.shared.icon(forFile: "/")
}

struct ImageWithBadge: View {
    
    let image: Image
    let badge: Image
    var scale: CGFloat = 1
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            image
                .resizable()
                .frame(width: 128 * scale, height: 128 * scale)
            badge
                .resizable()
                .frame(width: 40 * scale, height: 40 * scale)
        }
    }
}

func localizedStatus(_ status: TMStatus) -> LocalizedStringKey {
    switch status {
    case .unsupportedVolume:
        return "Unsupported disk"
    case .excludedVolume:
        return "Excluded disk"
    case .parentExcluded:
        return "Excluded because of parent folder"
    case .stickyExcluded:
        return "Excluded by sticky flag attached"
    case .pathExcluded:
        return "Excluded by path"
    case .included:
        return "Not excluded"
    case .unknown:
        return "Unknown"
    }
}

struct LegendView_Previews: PreviewProvider {
    
    static var previews: some View {
        LegendView(state: .init(), actions: nil)
    }
}
