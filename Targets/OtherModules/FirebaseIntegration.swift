import Firebase

func activateFirebase() {
    #if !DEBUG
    FirebaseApp.configure()
    #endif
}
