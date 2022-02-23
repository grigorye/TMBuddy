import Foundation

@objc protocol TMUtilHelperXPC: CommonHelperXPC {
    func setExcluded(_ value: Bool, privilege: TMPrivilegedExclusionKind, paths: [String], reply: @escaping (Error?) -> Void)
}
