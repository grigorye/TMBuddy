import Foundation

/// Standard delegate for a XPC service.
public class XPCListenerDelegate<ServiceProtocol>: NSObject, NSXPCListenerDelegate {
    
    public init(serviceGenerator: @escaping () -> ServiceProtocol) {
        self.serviceGenerator = serviceGenerator
    }
    
    /// Accepts a new connection.
    /// - Parameter listener: XPC listener which owns this delegate.
    /// - Parameter newConnection: XPC connection in a pending state.
    public func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        prepare(newConnection)
        newConnection.resume()
        return true
    }
    
    func prepare(_ connection: NSXPCConnection) {
        let service = serviceGenerator()
        let serviceProtocol = objCProtocolFromType(ServiceProtocol.self)
        connection.exportedInterface = NSXPCInterface(with: serviceProtocol)
        connection.exportedObject = service
    }
    
    private let serviceGenerator: () -> ServiceProtocol
}
