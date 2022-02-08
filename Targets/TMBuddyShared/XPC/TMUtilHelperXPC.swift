import Foundation

@objc protocol TMUtilHelperXPC: CommonHelperXPC {
    func setExcludedByPath(_ value: Bool, paths: [String], reply: @escaping (Error?) -> Void)
}
