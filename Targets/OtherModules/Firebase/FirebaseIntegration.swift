#if canImport(Firebase)

import Firebase

func activateFirebase() {
    _ = configureFirebaseAppOnce
    _ = firebaseAnalyticsEnabler
}

let configureFirebaseAppOnce: Void = FirebaseApp.configure()
let firebaseAnalyticsEnabler = FirebaseAnalyticsEnabler()

#endif
