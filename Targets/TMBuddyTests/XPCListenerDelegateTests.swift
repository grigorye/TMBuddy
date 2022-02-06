import XCTest

class XPCListenerDelegateTests: XCTestCase {

    func tests() throws {
        let listenerDelegate = XPCListenerDelegate<SampleService> {
            SampleServiceImp()
        }
        listenerDelegate.prepare(NSXPCConnection())
    }
}

private class SampleServiceImp: NSObject, SampleService {
    
    func foo() {
    }
}

@objc protocol SampleService {
    func foo()
}
