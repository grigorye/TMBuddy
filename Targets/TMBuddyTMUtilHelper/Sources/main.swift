import os.log

private let log: OSLog = .default

os_log(.info, log: log, "launched")

runListener()

os_log(.info, log: log, "runLoopEnded")
