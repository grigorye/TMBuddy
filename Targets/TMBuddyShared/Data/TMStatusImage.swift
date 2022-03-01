import AppKit

func imageForStatus(_ status: TMStatus) -> NSImage? {
    class BundleTag {}
    let statusImage = Bundle(for: BundleTag.self).image(forResource: "Status")!
    let alpha: CGFloat = 0.4
    switch status {
    case .included:
        return nil
    case .parentExcluded:
        return statusImage.tint(color: .systemGray.withAlphaComponent(alpha))
    case .stickyExcluded:
        return statusImage.tint(color: .systemPurple.withAlphaComponent(alpha))
    case .pathExcluded:
        return statusImage.tint(color: .systemRed.withAlphaComponent(alpha))
    case .unknown:
        return statusImage.tint(color: .systemPink.withAlphaComponent(alpha))
    case .unsupportedVolume:
        return statusImage.tint(color: .systemMint.withAlphaComponent(alpha))
    case .excludedVolume:
        return statusImage.tint(color: .systemPurple.withAlphaComponent(alpha))
    }
}

extension NSImage {
    
    func tint(color: NSColor) -> NSImage {
        //
        // Borrowed from https://stackoverflow.com/a/50074538/1859783
        //
        
        let image = self.copy() as! NSImage
        image.lockFocus()
        
        color.set()
        
        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        imageRect.fill(using: .sourceAtop)
        
        image.unlockFocus()
        
        return image
    }
}
