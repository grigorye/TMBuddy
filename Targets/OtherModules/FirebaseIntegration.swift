#if canImport(Firebase)

import Firebase

func activateFirebase() {
    #if !DEBUG
    FirebaseApp.configure()
    #endif
}

#endif
