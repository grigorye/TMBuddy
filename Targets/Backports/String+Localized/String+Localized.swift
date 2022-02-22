import Foundation

struct LocalizedValue: ExpressibleByStringLiteral, ExpressibleByStringInterpolation, CustomStringConvertible {
    
    struct StringInterpolation: StringInterpolationProtocol {
        var output = ""
        var format = ""
        var arguments: [String] = []
        
        // allocate enough space to hold twice the amount of literal text
        init(literalCapacity: Int, interpolationCount: Int) {
            output.reserveCapacity(literalCapacity * 2)
        }
        
        mutating func appendLiteral(_ literal: String) {
            output += literal
            format += literal
        }
        
        mutating func appendInterpolation(_ x: Any) {
            format += "%@"
            arguments += ["\(x)"]
        }
    }
    
    let description: String
    let format: String
    let arguments: [String]
    
    init(stringLiteral value: String) {
        description = value
        format = value
        arguments = []
    }
    
    init(stringInterpolation: StringInterpolation) {
        description = stringInterpolation.output
        format = stringInterpolation.format
        arguments = stringInterpolation.arguments
    }
}

extension String {
    
    init(localized value: LocalizedValue, comment: String = "") {
        self.init(format: NSLocalizedString(value.format, comment: comment), arguments: value.arguments)
    }
}
