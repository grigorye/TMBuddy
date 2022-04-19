#if canImport(Firebase)

import GoogleUtilities_Logger

let customGULLogImp: GULLogImp = { (level: GoogleLoggerLevel, version: String, service: String, messageCode: String, message: String) in
    dump((service: service, message: message), name: "GULLog")
}

func injectCustomGoogleLogger() {
    GULLoggerConfig.logImp = customGULLogImp
}

#endif
