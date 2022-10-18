import SwiftUI

@MainActor
func snapshotSamples<
    Content: View,
    T1: SampledView
>(
    _ t1: T1.Type,
    record recording: Bool,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line,
    body: () -> Content
) {
    for t1 in T1.State.Sample.allCases {
        let view = body()
            .sample(for: T1.self, sample: t1.state)
        assertSnapshot(
            matching: view,
            named: t1.sampleName,
            record: recording,
            file: file,
            testName: testName,
            line: line
        )
    }
}

@MainActor
func snapshotSamples<
    Content: View,
    T1: SampledView,
    T2: SampledView
>(
    _ t1: T1.Type,
    _ t2: T2.Type,
    record recording: Bool,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line,
    body: () -> Content
) {
    for t1 in T1.State.Sample.allCases {
        for t2 in T2.State.Sample.allCases {
            let view = body()
                .sample(for: T1.self, sample: t1.state)
                .sample(for: T2.self, sample: t2.state)
            let name = [
                t1.sampleName,
                t2.sampleName
            ].joined(separator: "_")
            assertSnapshot(
                matching: view,
                named: name,
                record: recording,
                file: file,
                testName: testName,
                line: line
            )
        }
    }
}

@MainActor
func snapshotSamples<
    Content: View,
    T1: SampledView,
    T2: SampledView,
    T3: SampledView
>(
    _ t1: T1.Type,
    _ t2: T2.Type,
    _ t3: T3.Type,
    record recording: Bool,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line,
    body: () -> Content
) {
    for t1 in T1.State.Sample.allCases {
        for t2 in T2.State.Sample.allCases {
            for t3 in T3.State.Sample.allCases {
                let view = body()
                    .sample(for: T1.self, sample: t1.state)
                    .sample(for: T2.self, sample: t2.state)
                    .sample(for: T3.self, sample: t3.state)
                let name = [
                    t1.sampleName,
                    t2.sampleName,
                    t3.sampleName
                ].joined(separator: "_")
                assertSnapshot(
                    matching: view,
                    named: name,
                    record: recording,
                    file: file,
                    testName: testName,
                    line: line
                )
            }
        }
    }
}

@MainActor
func snapshotSamples<
    Content: View,
    T1: SampledView,
    T2: SampledView,
    T3: SampledView,
    T4: SampledView
>(
    _ t1: T1.Type,
    _ t2: T2.Type,
    _ t3: T3.Type,
    _ t4: T4.Type,
    record recording: Bool,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line,
    body: () -> Content
) {
    for t1 in T1.State.Sample.allCases {
        for t2 in T2.State.Sample.allCases {
            for t3 in T3.State.Sample.allCases {
                for t4 in T4.State.Sample.allCases {
                    let view = body()
                        .sample(for: T1.self, sample: t1.state)
                        .sample(for: T2.self, sample: t2.state)
                        .sample(for: T3.self, sample: t3.state)
                        .sample(for: T4.self, sample: t4.state)
                    let name = [
                        t1.sampleName,
                        t2.sampleName,
                        t3.sampleName,
                        t4.sampleName
                    ].joined(separator: "_")
                    assertSnapshot(
                        matching: view,
                        named: name,
                        record: recording,
                        file: file,
                        testName: testName,
                        line: line
                    )
                }
            }
        }
    }
}

@MainActor
func snapshotSample<
    Content: View,
    T1: SampledView,
    T2: SampledView,
    T3: SampledView,
    T4: SampledView
>(
    _ t1: (T1.Type, T1.State),
    _ t2: (T2.Type, T2.State),
    _ t3: (T3.Type, T3.State),
    _ t4: (T4.Type, T4.State),
    record recording: Bool,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line,
    body: () -> Content
) {
    let view = body()
        .sample(for: T1.self, sample: t1.1)
        .sample(for: T2.self, sample: t2.1)
        .sample(for: T3.self, sample: t3.1)
        .sample(for: T4.self, sample: t4.1)
    assertSnapshot(
        matching: view,
        named: testName,
        record: recording,
        file: file,
        testName: testName,
        line: line
    )
}
