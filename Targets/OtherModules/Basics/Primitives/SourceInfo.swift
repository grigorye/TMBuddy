struct SourceInfo {
    
    init(file: StaticString, function: StaticString, line: Int, callStack: CallStack) {
        self.file = file
        self.function = "\(function)"
        self.originalFunction = function
        self.line = line
        self.callStack = callStack
    }
    
    init(file: StaticString, function: String, originalFunction: StaticString, line: Int, callStack: CallStack) {
        self.file = file
        self.function = function
        self.originalFunction = originalFunction
        self.line = line
        self.callStack = callStack
    }

    let file: StaticString
    let function: String
    let originalFunction: StaticString
    let line: Int
    let callStack: CallStack
}
