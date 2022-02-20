import SwiftUI

struct LegendView: View {
    
    var body: some View {
        let cases = TMStatus.allCases.filter { [.included, .unknown].contains($0) == false }
        VStack(alignment: .leading) {
            ForEach(cases, id: \.self) { status in
                HStack {
                    if let image = imageForStatus(status) {
                        Image(nsImage: image)
                    } else {
                        let placeholderImage = imageForStatus(.stickyExcluded)!
                        Image(nsImage: placeholderImage)
                            .hidden()
                    }
                    let label = localizedStatus(status)
                    Text(label)
                }
            }
        }.fixedSize()
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
        LegendView()
    }
}
