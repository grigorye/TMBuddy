import SnapshotTesting

extension SampledView {
    
    static func snapshotSamples(
        record recording: Bool,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        for sample in State.Sample.allCases {
            let view = Self.new()
                .environment(Self.sampleStateEnvironmentValuesKeyPath, sample.state)
                .border(.red)

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
