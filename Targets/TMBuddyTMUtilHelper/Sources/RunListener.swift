import Foundation

func runListener() {
    let listenerDelegate = XPCListenerDelegate<TMUtilHelperXPC>(
        serviceGenerator: {
            TMUtilHelperXPCImp()
        }
    )
    
    let listener = NSXPCListener(machServiceName: helperMachServiceName) ≈ {
        $0.delegate = listenerDelegate
    }
    
    listener.resume()
    
    RunLoop.current.run()
    
    _ = listenerDelegate
}
