import Foundation

struct PostInstallController {
    
    let sourceBundlePath: String
    let fixedRootURL = URL(fileURLWithPath: "/Library/Application Support/TMBuddy")
    var fixedFrameworksURL: URL { fixedRootURL.appendingPathComponent("Frameworks") }

    func postInstallNeeded() throws -> Bool {
        let sourceFrameworksURL = try sourceFrameworksURL()
        let executableURL = URL(fileURLWithPath: "/usr/bin/diff")
        let arguments = [
            "-r",
            sourceFrameworksURL.path,
            fixedFrameworksURL.path
        ]
        do {
            let data = try runAndCaptureOutput(executableURL: executableURL, arguments: arguments)
            dump((String(data: data, encoding: .utf8), executable: executableURL.path, arguments: arguments), name: "diffSucceeded")
            return false
        } catch {
            dump((error, executable: executableURL.path, arguments: arguments), name: "diffFailed")
            return true
        }
    }
    
    func postInstall() throws {
        let fileManager = FileManager.default
        do {
            let sourceFrameworksURL = try sourceFrameworksURL()
            try fileManager.createDirectory(
                at: fixedRootURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
            assert(sourceFrameworksURL.lastPathComponent == "Frameworks")
            do {
                try fileManager.copyItem(at: sourceFrameworksURL, to: fixedFrameworksURL)
            } catch CocoaError.fileWriteFileExists {
                try fileManager.removeItem(at: fixedFrameworksURL)
                try fileManager.copyItem(at: sourceFrameworksURL, to: fixedFrameworksURL)
            } catch {
                dump((error, sourceFrameworks: sourceFrameworksURL.path, fixedFrameworks: fixedFrameworksURL.path), name: "frameworksCopyFailed")
                throw error
            }
            
            dump(sourceFrameworksURL.path, name: "frameworksInstallSucceeded")
        } catch {
            dump(error, name: "frameworksInstallationFailed")
            throw error
        }
    }
    
    private func sourceFrameworksURL() throws -> URL {
        let bundleURL = URL(fileURLWithPath: sourceBundlePath)
        
        guard let bundle = Bundle(url: bundleURL) else {
            throw Error.invalidBundle(path: sourceBundlePath)
        }
        
        guard let frameworksURL = bundle.privateFrameworksURL else {
            throw Error.noFrameworksInBundle(path: sourceBundlePath)
        }
        
        return frameworksURL
    }
}

private enum Error: Swift.Error {
    case invalidBundle(path: String)
    case noFrameworksInBundle(path: String)
}
