import Foundation

final class TMUtilHelperXPCImp: CommonHelperXPCImp, TMUtilHelperXPC {
    
    func setExcludedByPath(_ value: Bool, paths: [String], reply: @escaping (Error?) -> Void) {
        let result = Result {
            try setExcludedByPath(value, paths: paths)
        }
        dump(result, name: "result")
        result.send(to: reply)
    }
    
    func setExcludedByPath(_ value: Bool, paths: [String]) throws {
        dump(paths, name: "paths")
        try TMUtilLauncher().setExcludedByPath(value, paths: paths)
        if UserDefaults.standard.bool(forKey: DefaultsKey.forceFakeFailureOnExcludeByPath) {
            enum Error: Swift.Error {
                case fakeFailure
            }
            throw Error.fakeFailure
        }
    }
}
