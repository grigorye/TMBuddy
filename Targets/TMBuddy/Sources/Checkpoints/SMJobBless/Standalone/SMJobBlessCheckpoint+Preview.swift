import SwiftUI

struct SMJobBlessCheckpointView_Previews: PreviewProvider {
    
    static var previews: some View {
        Preview()
    }
}

private let samples = SMJobBlessCheckpointState.Sample.allCases

private struct Preview: View {
    
    @State var sampleIndex = 0
    
    var sample: SMJobBlessCheckpointState.Sample {
        samples[sampleIndex]
    }
    
    var state: SMJobBlessCheckpointState {
        sample.state
    }

    var nextSampleIndex: Int {
        let wouldBeNextSampleIndex = sampleIndex + 1
        guard wouldBeNextSampleIndex < samples.endIndex else {
            return 0
        }
        return wouldBeNextSampleIndex
    }
    
    var body: some View {
        VStack {
            Text(.verbatim("\(sample)"))
            Button(.verbatim("Next")) {
                sampleIndex = nextSampleIndex
            }
            SMJobBlessCheckpointView(state: state, actions: nil)
                .border(.red)
        }
        .padding()
    }
}
