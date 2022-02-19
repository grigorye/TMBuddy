import AppKit

func imageForStatus(_ status: TMStatus) -> NSImage? {
    switch status {
    case .included:
        return nil
    case .parentExcluded:
        return NSImage(named: NSImage.statusNoneName)
    case .stickyExcluded:
        return NSImage(named: NSImage.statusUnavailableName)
    case .pathExcluded:
        return NSImage(named: NSImage.statusPartiallyAvailableName)
    case .unknown:
        return NSImage(named: NSImage.statusNoneName)
    case .unsupportedVolume:
        return NSImage(named: NSImage.statusUnavailableName)
    case .excludedVolume:
        return NSImage(named: NSImage.statusUnavailableName)
    }
}
