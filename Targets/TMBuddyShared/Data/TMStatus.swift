enum TMStatus: String /* badge identifier */, CaseIterable {
    case unsupportedVolume
    case excludedVolume
    case parentExcluded
    case stickyExcluded
    case pathExcluded
    case included
    case unknown
}
