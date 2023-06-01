#if canImport(Sentry)

import Sentry

public func activateSentry() {
    SentrySDK.start { options in
        options.environment = environment
        options.dsn = "https://d6dad0ecd0b44864b5be05bca4c03bad@o4505240658444288.ingest.sentry.io/4505275998535680"
#if DEBUG
        options.debug = true
#endif
        
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 1.0
    }
}

private var environment: String {
#if DEBUG
    "debug"
#else
    "production"
#endif
}

#endif
