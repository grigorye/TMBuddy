import Foundation

struct TMUtilLauncher {
    
    let tmUtilURL = URL(fileURLWithPath: "/usr/bin/tmutil")
    let osascriptURL = URL(fileURLWithPath: "/usr/bin/osascript")

    func removeExclusion(urls: [URL]) async throws {
        let tmUtilArguments = ["addexclusion", "-p"] + urls.map { $0.standardized.path }
        
        let data = try await runAndCaptureOutput(executableURL: tmUtilURL, arguments: tmUtilArguments).result.get()
        
        dump(String(data: data, encoding: .utf8)!, name: "tmUtilOutput")
    }
    
    func addExclusion(urls: [URL]) async throws {
        let tmUtilArguments = ["-e", "do shell script \"tmutil addexclusion -p ~/tmp\" with administrator privileges"]
        
        let data = try await runAndCaptureOutput(executableURL: osascriptURL, arguments: tmUtilArguments).result.get()
        
        dump(String(data: data, encoding: .utf8)!, name: "tmUtilOutput")
    }

    func isExcluded(urls: [URL]) async throws -> [URL: Bool] {
        let tmUtilArguments = ["isexcluded", "-X"] + urls.map { $0.standardized.path }
        
        let data = try await runAndCaptureOutput(executableURL: tmUtilURL, arguments: tmUtilArguments).result.get()
        
        dump(String(data: data, encoding: .utf8)!, name: "tmUtilOutput")

        let responses = try PropertyListDecoder().decode([PlutilIsExcludedResponse].self, from: data)
        let urlsWithFlag: [(URL, Bool)] = try responses.map { response in
            let url = URL(fileURLWithPath: response.path).resolvingSymlinksInPath()
            let isExcluded: Bool = try {
                switch response.isExcluded {
                case 0:
                    return false
                case 1:
                    return true
                default:
                    throw dump(TMUtilIsExcludedOutputParseError.unrecognizableIsExcluded(response))
                }
            }()
            return (url, isExcluded)
        }
        return Dictionary.init(uniqueKeysWithValues: urlsWithFlag)
    }
}

struct PlutilIsExcludedResponse: Codable {
    let path: String
    let isExcluded: Int
    
    private enum CodingKeys: String, CodingKey {
        case path = "Path"
        case isExcluded = "IsExcluded"
    }
}

enum TMUtilIsExcludedOutputParseError: Swift.Error {
    case unrecognizableIsExcluded(PlutilIsExcludedResponse)
}
