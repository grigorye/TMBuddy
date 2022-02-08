import Foundation

struct TMUtilLauncher {
    
    let tmUtilURL = URL(fileURLWithPath: "/usr/bin/tmutil")
    let osascriptURL = URL(fileURLWithPath: "/usr/bin/osascript")

    func setExcluded(_ excluded: Bool, urls: [URL]) throws {
        dump((excluded, path: urls.paths), name: "args")
        let command = excluded ? "addexclusion" : "removeexclusion"
        let tmUtilArguments = [command] + urls.map { $0.standardized.path }
        
        let data = try runAndCaptureOutput(executableURL: tmUtilURL, arguments: tmUtilArguments)
        
        dump(String(data: data, encoding: .utf8)!, name: "tmUtilOutput")
    }
    
    func setExcludedByPath(_ excluded: Bool, urls: [URL]) throws {
        let command = excluded ? "addexclusion" : "removeexclusion"
        let tmUtilArguments = [command, "-p"] + urls.map { $0.standardized.path }

        let data = try runAndCaptureOutput(executableURL: tmUtilURL, arguments: tmUtilArguments)
        
        dump(String(data: data, encoding: .utf8)!, name: "tmUtilOutput")
    }

    func isExcluded(urls: [URL]) throws -> [URL: Bool] {
        let tmUtilArguments = ["isexcluded", "-X"] + urls.map { $0.standardized.path }
        
        let data = try runAndCaptureOutput(executableURL: tmUtilURL, arguments: tmUtilArguments)
        
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
                    dump((response), name: "unrecognizableIsExcludedInResponse")
                    throw TMUtilIsExcludedOutputParseError.unrecognizableIsExcluded(response)
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

extension TMUtilLauncher: Traceable {}
