import Foundation

func runListener() {
    let listenerDelegate = XPCListenerDelegate<TMUtilHelperXPC>(
        serviceGenerator: {
            TMUtilHelperXPCImp()
        }
    )
    
    let listener = NSXPCListener(machServiceName: Bundle.main.bundleIdentifier!) ≈ {
        $0.delegate = listenerDelegate
    }
    
    listener.resume()
    
    RunLoop.current.run()
    
    _ = listenerDelegate
}
