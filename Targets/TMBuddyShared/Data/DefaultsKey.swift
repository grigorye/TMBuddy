enum DefaultsKey: String, CaseIterable {
    case sandboxedBookmarks
    case scopedSandboxedBookmarks
    
    case suppressErrorReporting
    case debug
    case debugAlienPlugin
    case suppressNSLog
    case enableDump
    case forceAppStoreLikeWindowTitle
    
    case finderSyncInfoRequestPayload
    case finderSyncInfoRequestPayloadEncoding
    case finderSyncInfoResponsePayload
    case finderSyncInfoResponsePayloadEncoding

    case forceTMUtilBasedStatusProvider
    case forceMDItemMetadataReader
    case forceTMUtilMetadataWriter
    
    case forceFakeFailureOnExcludeByPath
}
