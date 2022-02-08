extension Result where Failure == Error {
    init(error: Error?, value: Success) {
        if let error = error {
            self = .failure(error)
        } else {
            self = .success(value)
        }
    }
}

extension Result where Failure == Error, Success == () {
    init(error: Error?) {
        if let error = error {
            self = .failure(error)
        } else {
            self = .success(())
        }
    }
}

protocol DefaultInitializable {
    init()
}

extension Result where Failure == Error, Success: DefaultInitializable {
    func send(to reply: @escaping (Error?, Success) -> Void) {
        switch self {
        case let .success(value):
            reply(nil, value)
        case let .failure(error):
            reply(error, .init())
        }
    }
}

extension Result where Failure == Error, Success == () {
    func send(to reply: @escaping (Error?) -> Void) {
        switch self {
        case .success:
            reply(nil)
        case let .failure(error):
            reply(error)
        }
    }
}

extension Bool: DefaultInitializable {}
