import Foundation

enum TMUtilStandardError {
    static let addExclusionFullDiskAccessMissing = "tmutil: addexclusion requires Full Disk Access privileges.\nTo allow this operation, select Full Disk Access in the Privacy\ntab of the Security & Privacy preference pane, and add Terminal\nto the list of applications which are allowed Full Disk Access.\n"
    static let removeExclusionFullDiskAccessMissing = "tmutil: removeexclusion requires Full Disk Access privileges.\nTo allow this operation, select Full Disk Access in the Privacy\ntab of the Security & Privacy preference pane, and add Terminal\nto the list of applications which are allowed Full Disk Access.\n"
}

@objc
enum TMPrivilegedExclusionKind: Int {
    case fixedPath
    case volume
}

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
    
    func setExcluded(_ exclude: Bool, privilege: TMPrivilegedExclusionKind, paths: [String]) throws {
        let command = exclude ? "addexclusion" : "removeexclusion"
        let exclusionModifier: String = {
            switch privilege {
            case .fixedPath:
                return "-p"
            case .volume:
                return "-v"
            }
        }()
        let tmUtilArguments = [command, exclusionModifier] + paths.map {
            // For some reason "~username/xxx" gets converted into "~root/xxx" when tmutil is invoked from the helper. As a workaround, we just expand it beforehand into the absolute path.
            ($0 as NSString).expandingTildeInPath(ignoringSandbox: true)
        }
        
        do {
            let data = try runAndCaptureOutput(executableURL: tmUtilURL, arguments: tmUtilArguments)
            
            dump(String(data: data, encoding: .utf8)!, name: "tmUtilOutput")
        } catch RunAndCaptureOutputError.processFailed(
            executable: _, arguments: _,
            terminationStatus: 80,
            standardError: (
                exclude
                ? TMUtilStandardError.addExclusionFullDiskAccessMissing
                : TMUtilStandardError.removeExclusionFullDiskAccessMissing
            )
        ) {
            throw TMUtilError.fullDiskAccessMissingForSkipPaths(paths, addition: exclude)
        }
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

enum TMUtilError: Swift.Error {
    case fullDiskAccessMissingForSkipPaths(_ skipPaths: [String], addition: Bool)
}
