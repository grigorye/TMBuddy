import class Foundation.Thread

struct CallStack {
    let returnAddresses = Thread.callStackReturnAddresses.dropFirst(ignoredCallStackFrames)
#if false
    let symbols = Thread.callStackSymbols.dropFirst(ignoredCallStackFrames)
#endif
}

private let ignoredCallStackFrames = [
    "CallStack.init()",
    "dump(..., callStack: CallStack = .init())"
].count
