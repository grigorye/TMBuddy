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
        
        let task = Task {
            try await helperVersion()
        }
        Task {
            let result = await task.result
            dump(result, name: "helperVersionResult")
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .failure:
                    self?.state = .toolNotInstalled
                case .success:
                    self?.state = .toolInstalled
                }
            }
        }
    }
}
