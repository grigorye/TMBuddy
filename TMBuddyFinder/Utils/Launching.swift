import Foundation

func runAndCaptureOutput(executableURL: URL, arguments: [String] = []) -> Task<Data, Error> {
    let pipe = Pipe()
    
    let process = Process() ≈ {
        $0.executableURL = executableURL
        $0.arguments = arguments
        $0.standardOutput = pipe
    }
    
    process.terminationHandler = {
        assert($0 == process)
    }
    
    return Task { () -> Data in
        process.launch()
        defer {
            process.waitUntilExit()
            dump((executable: executableURL.path, arguments: arguments, status: process.terminationStatus), name: "terminated")
        }
        dump((executable: executableURL.path, arguments: arguments), name: "launched")
        if #available(macOS 10.15.4, *) {
            guard let data = try pipe.fileHandleForReading.readToEnd() else {
                throw dump(RunAndCaptureOutputTaskError.noDataRead)
            }
            return data
        } else {
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return data
        }
    }
}

enum RunAndCaptureOutputTaskError: Swift.Error {
    case noDataRead
}
