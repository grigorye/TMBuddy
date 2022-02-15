import Foundation

let bundleIDPrefix = bundleExtras.bundleIDPrefix
let bundleIDExtra = bundleExtras.bundleIDExtra

private struct BundleExtras: Decodable {
    var bundleIDPrefix: String
    var bundleIDExtra: String
}

private let bundleExtras = try! PropertyListDecoder().decode(
    BundleExtras.self,
    from: Data(contentsOf: bundleExtrasPlistURL)
)

private class BundleTag {}

private let bundleExtrasPlistURL = Bundle(for: BundleTag.self)
    .url(forResource: "BundleExtras", withExtension: "plist")!
