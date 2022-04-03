#if canImport(Firebase)

import Firebase
import GoogleUtilities_Logger

func activateFirebase() {
    _ = configureFirebaseAppOnce
    _ = firebaseAnalyticsEnabler
}

let customGULLogImp: GULLogImp = { (level: GoogleLoggerLevel, version: String, service: String, messageCode: String, message: String) in
    dump((service: service, message: message), name: "GULLog")
}

let configureFirebaseAppOnce: Void = {
    GULLoggerConfig.logImp = customGULLogImp
    FirebaseApp.configure()
}()

let firebaseAnalyticsEnabler = FirebaseAnalyticsEnabler()

#endif
