extension PostInstallHelperCheckpointView {
    
    init() {
        self.init(
            checkpointProvider: PostInstallHelperCheckpointProvider(),
            blessCheckpointProvider: SMJobBlessCheckpointProvider(),
            actions: PostInstallHelperCheckpointActionHandler()
        )
    }
}
