import AppKit

func imageForStatus(_ status: TMStatus) -> NSImage? {
    switch status {
    case .included:
        return nil
    case .excludedByParent:
        return NSImage(named: NSImage.statusNoneName)
    case .stickyExcluded:
        return NSImage(named: NSImage.statusUnavailableName)
    case .pathExcluded:
        return NSImage(named: NSImage.statusPartiallyAvailableName)
    case .unknown:
        return NSImage(named: NSImage.statusNoneName)
    }
}
