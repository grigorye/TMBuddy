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
        
        dump(change, name: "change")
        
        handle(change)
    }
}

private var KVOContextImp: Int = 0
private let KVOContext = UnsafeMutableRawPointer(&KVOContextImp)
