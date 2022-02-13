import Foundation

func runAndCaptureOutput(executableURL: URL, arguments: [String] = []) -> Task<Data, Error> {
    let standardOutput = Pipe()
    let standardError = Pipe()
    
    let process = Process() ≈ {
        $0.executableURL = executableURL
        $0.arguments = arguments
        $0.standardOutput = standardOutput
        $0.standardError = standardError
    }
    
    process.terminationHandler = {
        assert($0 == process)
    }
    
    return Task { () -> Data in
        process.launch()
        
        dump((executable: executableURL.path, arguments: arguments), name: "launched")
        
        process.waitUntilExit()
        
        dump((executable: executableURL.path, arguments: arguments, status: process.terminationStatus), name: "terminated")
        
        guard process.terminationStatus == ERR_SUCCESS else {
            let standardError: String = {
                let data = standardError.fileHandleForReading.readDataToEndOfFile()
                guard let standardError = String(data: data, encoding: .utf8) else {
                    dump((executable: executableURL.path, arguments: arguments, standarErrorData: data), name: "standardErrorUTF8ConversionFailed")
                    return ""
                }
                return standardError
            }()
            enum Error: Swift.Error {
                case processFailed(
                    executable: String,
                    arguments: [String],
                    terminationStatus: Int32,
                    standardError: String
                )
            }
            throw dump(
                Error.processFailed(
                    executable: executableURL.path,
                    arguments: arguments,
                    terminationStatus: process.terminationStatus,
                    standardError: standardError
                ),
                name: "error"
            )
        }
        
        let data = standardOutput.fileHandleForReading.readDataToEndOfFile()
        return data
    }
}
