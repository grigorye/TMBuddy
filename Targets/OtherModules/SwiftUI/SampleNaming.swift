protocol SampleNaming {
    /// Type used as the namespace in name generation, typically the "data" type (enum) for the samples.
    associatedtype Namespace
    
    var sampleName: String { get }
}

extension SampleNaming {
    
    static var namespacePrefix: String {
        "\(Namespace.self)".droppingSuffix("State")
    }
    
    var sampleName: String {
        Self.namespacePrefix + "-" + String("\(self)".split(separator: ".").last!)
    }
}

extension String {
    
    fileprivate func droppingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else {
            return self
        }
        return String(prefix(count - suffix.count))
    }
}
