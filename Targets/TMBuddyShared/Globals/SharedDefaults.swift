import Foundation

let sharedDefaults = UserDefaults(suiteName: "\(devTeamID).group.TMBuddy\(bundleIDExtra)")!

let devTeamID = Bundle.main.infoDictionary!["DEVELOPMENT_TEAM"] as! String
