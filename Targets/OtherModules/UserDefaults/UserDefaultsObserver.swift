import Foundation

class UserDefaultsObserver: NSObject {
    
    let defaults: UserDefaults
    let key: String
    
    let handle: ([NSKeyValueChangeKey : Any]?) -> Void
    
    deinit {
        defaults.removeObserver(self, forKeyPath: key)
    }
    
    init(defaults: UserDefaults, key: String, options: NSKeyValueObservingOptions = [], handle: @escaping ([NSKeyValueChangeKey : Any]?) -> Void) {
        
        self.defaults = defaults
        self.key = key
        self.handle = handle

        super.init()

        defaults.addObserver(self, forKeyPath: key, options: options, context: KVOContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard context == KVOContext else {
            return
        }

        if debug {
            if let change = change {
                dump((keyPath: keyPath ?? "nil", kind: change[.kindKey], new: change[.newKey], old: change[.oldKey]), name: "change", maxDepth: 1)
            } else {
                dump(change, name: "change")
            }
        }
        
        handle(change)
    }
}

private let KVOContext = malloc(1)
