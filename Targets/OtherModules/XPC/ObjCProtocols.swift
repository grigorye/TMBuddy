import Foundation

func objCProtocolFromType<T>(_ type: T.Type) -> Protocol {
    guard let objCProtocol = NSProtocolFromString(String(reflecting: type)) else {
        fatalError("\(type) is not Objective-C protocol.")
    }
    return objCProtocol
}
