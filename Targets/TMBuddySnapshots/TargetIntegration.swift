func defaultActivityTrackers() -> [ActivityTracker] {
    []
}

func defaultActionTrackers() -> [ActionTracker] {
    []
}

func defaultElapsedTimeTrackers() -> [ElapsedTimeTracker] {
    []
}

func defaultErrorReporters() -> [ErrorReporter] {
    []
}

@MainActor var defaultEnforcedIsAppDistributedViaAppStore: Bool? = nil
@MainActor var defaultEnforcedAppName: String? = nil
