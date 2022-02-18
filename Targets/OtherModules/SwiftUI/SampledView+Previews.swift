import SwiftUI

extension SampledView {
    
    @ViewBuilder
    static func previews(
        frameWidth: CGFloat? = nil
    ) -> some View {
        ForEach(State.Sample.allCases, id: \.self) { sample in
            if #available(macOS 12.0, *) {
                let view = Self.new()
                    .environment(Self.sampleStateEnvironmentValuesKeyPath, sample.state)
                    .overlay {
                        Rectangle()
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [2]))
                    }
                    .frame(width: frameWidth, alignment: .leading)
                view
                    .fixedSize()
                    .previewDisplayName(sample.sampleName)
            } else {
                fatalError()
            }
        }
    }
    
    static var previews: some View {
        previews()
    }
}
