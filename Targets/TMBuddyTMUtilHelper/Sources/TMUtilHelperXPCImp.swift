import Foundation

final class TMUtilHelperXPCImp: CommonHelperXPCImp, TMUtilHelperXPC {
    
    func setExcludedByPath(_ value: Bool, paths: [String], completion: @escaping (Error?) -> Void) {
        let task = Task { try await setExcludedByPath(value, paths: paths) }
        Task {
            let result = await task.result
            switch result {
            case .success(()):
                completion(nil)
            case let .failure(error):
                completion(error)
            }
        }
    }
    
    func setExcludedByPath(_ value: Bool, paths: [String]) async throws {
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
