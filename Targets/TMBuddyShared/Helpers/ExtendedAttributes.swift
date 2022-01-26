import Foundation

// Borrowed from https://stackoverflow.com/a/38343753/1859783

extension URL {
    
    /// Get extended attribute.
    func extendedAttribute(forName name: String) throws -> Data  {
        
        let data = try self.withUnsafeFileSystemRepresentation { fileSystemPath -> Data in
            
            // Determine attribute size:
            let length = getxattr(fileSystemPath, name, nil, 0, 0, 0)
            guard length >= 0 else { throw POSIXError(errno: errno) }
            
            // Create buffer with required size:
            var data = Data(count: length)
            
            // Retrieve attribute:
            let result = data.withUnsafeMutableBytes { [count = data.count] in
                getxattr(fileSystemPath, name, $0.baseAddress, count, 0, 0)
            }
            guard result >= 0 else { throw POSIXError(errno: errno) }
            return data
        }
        return data
    }
    
    /// Set extended attribute.
    func setExtendedAttribute(data: Data, forName name: String) throws {
        
        try self.withUnsafeFileSystemRepresentation { fileSystemPath in
            let result = data.withUnsafeBytes {
                setxattr(fileSystemPath, name, $0.baseAddress, data.count, 0, 0)
            }
            debug { dump((result, name: name, data: data), name: "result") }
            guard result == 0 else { throw dump(POSIXError(errno: errno), name: "error") }
        }
    }
    
    /// Remove extended attribute.
    func removeExtendedAttribute(forName name: String) throws {
        
        try self.withUnsafeFileSystemRepresentation { fileSystemPath in
            let result = removexattr(fileSystemPath, name, 0)
            guard result >= 0 else { throw POSIXError(.init(rawValue: errno)!)  }
        }
    }
    
    /// Get list of all extended attributes.
    func listExtendedAttributes() throws -> [String] {
        
        let list = try self.withUnsafeFileSystemRepresentation { fileSystemPath -> [String] in
            let length = listxattr(fileSystemPath, nil, 0, 0)
            guard length >= 0 else { throw POSIXError(errno: errno)  }
            
            // Create buffer with required size:
            var namebuf = Array<CChar>(repeating: 0, count: length)
            
            // Retrieve attribute list:
            let result = listxattr(fileSystemPath, &namebuf, namebuf.count, 0)
            guard result >= 0 else { throw POSIXError(errno: errno) }
            
            // Extract attribute names:
            let list = namebuf.split(separator: 0).compactMap {
                $0.withUnsafeBufferPointer {
                    $0.withMemoryRebound(to: UInt8.self) {
                        String(bytes: $0, encoding: .utf8)
                    }
                }
            }
            return list
        }
        return list
    }
}

extension POSIXError {
    init(errno: Int32) {
        let code = POSIXError.Code(rawValue: errno) ?? {
            assertionFailure("Unsupported errno: \(errno)")
            return .ELAST
        }()
        self.init(code)
    }
}
