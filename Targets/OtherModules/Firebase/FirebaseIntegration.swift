#if canImport(Firebase)

import Firebase
import GoogleUtilities_Logger

func activateFirebase() {
    _ = configureFirebaseAppOnce
    _ = firebaseAnalyticsEnabler
}

let configureFirebaseAppOnce: Void = configureFirebase()

func configureFirebase() {
    injectCustomGoogleLogger()
    FirebaseApp.configure()
    dump(Performance.sharedInstance().isDataCollectionEnabled, name: "dataCollectionEnabled")
    dump(Performance.sharedInstance().isInstrumentationEnabled, name: "instrumentationEnabled")
}

let firebaseAnalyticsEnabler = FirebaseAnalyticsEnabler()

#endif
