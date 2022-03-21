#if canImport(Firebase)

import Firebase

func activateFirebase() {
    _ = configureFirebaseAppOnce
}

let configureFirebaseAppOnce: Void = FirebaseApp.configure()

#endif
