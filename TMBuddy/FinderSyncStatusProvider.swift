import Combine
import FinderSync

class FinderSyncExtensionStatusProvider: ObservableObject {
    
    @Published var isEnabled: Bool
    
    private var timer: Timer?
    
    init() {
        let currentValue = { FIFinderSyncController.isExtensionEnabled }
        self.isEnabled = currentValue()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.isEnabled = currentValue()
        }
    }
}

