import SnapshotTesting
import Foundation

@objc(SnapshotRecordingLoadHook)
class SnapshotRecordingLoadHook: NSObject {

    // Invoked by SnapshotRecordingLoadHookInjector on +load.
    @objc class func loadHook() {
        isRecording = ProcessInfo.processInfo.environment["SNAPSHOT_RECORDING"] == "YES"
        dump(isRecording, name: "isRecording")
    }
}
