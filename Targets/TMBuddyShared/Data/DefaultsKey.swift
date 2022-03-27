enum DefaultsKey: String, CaseIterable {
    case sandboxedBookmarks
    case scopedSandboxedBookmarks
    
    case errorReportingEnabled
    case elapsedTimeTrackingEnabled
    case activityTrackingEnabled
    case actionTrackingEnabled
    case analyticsEnabled
    case debug
    case debugAlienPlugin
    case debugAlienPrivilegedHelper
    case suppressNSLog
    case enableDump
    case forceAppStoreLikeWindowTitle
    
    case finderSyncInfoRequestPayload
    case finderSyncInfoRequestPayloadEncoding
    case finderSyncInfoResponsePayload
    case finderSyncInfoResponsePayloadEncoding

    case forceTMUtilBasedStatusProvider
    case forceTMUtilMetadataWriter
    case forcePostInstallCheckpoint
    
    case fakeFailureOnSetExcludedPrivileged
}
