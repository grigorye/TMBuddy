#if canImport(Firebase)

import Firebase

func activateFirebase() {
#if !DEBUG
    _ = configureFirebaseAppOnce
#endif
}

let configureFirebaseAppOnce: Void = FirebaseApp.configure()

#endif
