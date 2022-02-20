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
                    let label = "\(status)"
                    Text(label)
                }
            }
        }.fixedSize()
    }
}

struct LegendView_Previews: PreviewProvider {
    
    static var previews: some View {
        LegendView()
    }
}
