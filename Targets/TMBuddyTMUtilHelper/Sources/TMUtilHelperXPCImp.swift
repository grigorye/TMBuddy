import Foundation

final class TMUtilHelperXPCImp: CommonHelperXPCImp, TMUtilHelperXPC {
    
    func setExcluded(_ value: Bool, privilege: TMPrivilegedExclusionKind, paths: [String], reply: @escaping (Error?) -> Void) {
        let result = Result {
            try setExcluded(value, privilege: privilege, paths: paths)
        }
        dump(result, name: "result")
        result.send(to: reply)
    }
    
    func setExcluded(_ value: Bool, privilege: TMPrivilegedExclusionKind, paths: [String]) throws {
        dump(paths, name: "paths")
        try TMUtilLauncher().setExcluded(value, privilege: privilege, paths: paths)
        if UserDefaults.standard.bool(forKey: DefaultsKey.fakeFailureOnSetExcludedPrivileged) {
            enum Error: Swift.Error {
                case fakeFailure
            }
            throw Error.fakeFailure
        }
    }
}
