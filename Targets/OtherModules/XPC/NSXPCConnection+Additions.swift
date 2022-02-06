import Foundation

extension NSXPCConnection {

    /// "Typed" variant of synchronousRemoteObjectProxyWithErrorHandler.
    func synchronousRemoteObjectProxyWithErrorHandler<ServiceProtocol>(handler: @escaping (Error) -> Void) -> ServiceProtocol {
        let serviceProtocol = objCProtocolFromType(ServiceProtocol.self)
        remoteObjectInterface = .init(with: serviceProtocol)
        return synchronousRemoteObjectProxyWithErrorHandler(handler) as! ServiceProtocol
    }
    
    /// Given a block that operates on the proxy, lets the block resume the given continuation, making sure that any connection errors are thrown via the very same continuation.
    func perform<ServiceProtocol, T>(
        block: (ServiceProtocol, _ continuation: CheckedContinuation<T, Error>) -> Void
    ) async throws -> T {
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<T, Error>) in
            
            let proxy: ServiceProtocol = synchronousRemoteObjectProxyWithErrorHandler { error in
                continuation.resume(throwing: error)
            }
            
            resume()
            
            block(proxy, continuation)
            
            invalidate()
        }
    }
}
