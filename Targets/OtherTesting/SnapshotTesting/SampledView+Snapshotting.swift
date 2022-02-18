import SwiftUI
import SnapshotTesting

extension SampledView {
    
    static func snapshotSamples(
        frameWidth: CGFloat? = nil,
        record recording: Bool,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        for sample in State.Sample.allCases {
            guard #available(macOS 12.0, *) else {
                fatalError()
            }
            
            let view = Self.new()
                .environment(Self.sampleStateEnvironmentValuesKeyPath, sample.state)
                .overlay {
                    Rectangle()
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [2]))
                }
                .frame(width: frameWidth, alignment: .leading)
                .padding()
                .border(.blue)

            assertSnapshot(
                matching: view,
                named: sample.sampleName,
                record: recording,
                file: file,
                testName: testName,
                line: line
            )
        }
    }
}
