import AppKit
import Blessed

class SMJobBlessCheckpointActionHandler: SMJobBlessCheckpointActions, Traceable {
    
    func reinstallHelper() {
        dump((), name: "")
        
        bless()
    }
    
    func installHelper() {
        dump((), name: "")
        
        bless()
    }
    
    func updateHandler() {
        dump((), name: "")
        
        bless()
    }
    
    func bless() {
        dump((), name: "")
        
        let message = String(localized: "\(appName) uses the helper tool for changing Time Machine exclusion paths on behalf of the administrator.")
        let icon = Bundle.main.url(forResource: "bless", withExtension: "png")
        do {
            try LaunchdManager.authorizeAndBless(message: message, icon: icon)
        } catch {
            dump(error, name: "blessFailed")
            NSApp.presentError(error)
        }
    }
}
