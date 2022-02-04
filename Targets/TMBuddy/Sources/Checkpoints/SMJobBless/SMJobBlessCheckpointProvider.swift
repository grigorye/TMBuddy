import SharedKit
import Foundation

class SMJobBlessCheckpointProvider: ObservableObject, Traceable {
    
    enum State {
        case toolInstalled
        case toolNotInstalled
    }
    
    @Published var state: State?
    
    private var timer: Timer?
    
    init() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.invalidateInfoTick()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func invalidateInfoTick() {
        let tmUtilXPC = XPC<MetadataWriterInterface>(
            configuration: .machServiceName("com.grigorye.TMBuddy.TMUtilHelper", options: .privileged),
            errorHandler: { [weak self] error in
                self?.state = .toolNotInstalled
            }
        )
        
        tmUtilXPC.callProxy { [weak self] proxy in
            proxy.ping()
            self?.state = .toolInstalled
        }
    }
}

