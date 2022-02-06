import Foundation

@objc protocol TMUtilHelperXPC: CommonHelperXPC {
    func setExcludedByPath(_ value: Bool, paths: [String], completion: @escaping (Error?) -> Void)
}
