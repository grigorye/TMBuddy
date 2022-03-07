[![build-app](https://github.com/grigorye/TMBuddy/actions/workflows/build-app.yml/badge.svg)](https://github.com/grigorye/TMBuddy/actions/workflows/build-app.yml)

# TMBuddy

See and manipulate exclusions from Time Machine backup, right in Finder.

## Features

- See exclusion status for every item of each monitored folder/disk:
  
  <img src="./Targets/TMBuddy/Sources/Legend/LegendView+Snapshots/macOS-12.2/test.1.@2x.png" alt="test.1" width=50% style="zoom:50%;" />
  
- Toggle *sticky* or *fixed-path* [^*] exclusion via contextual menu (or toolbar item):
  
  |                  Exclude from Time Machine                   |              Remove Exclusion from Time Machine              |
  | :----------------------------------------------------------: | :----------------------------------------------------------: |
  | <img src="Targets/TMBuddy/Sources/Content/Standalone/Menu+Snapshots/macOS-12.2/testPathExclusion.adding.@2x.png" alt="testPathExclusion.adding" width=75% style="zoom:50%;" /> | <img src="Targets/TMBuddy/Sources/Content/Standalone/Menu+Snapshots/macOS-12.2/testPathExclusion.removal.@2x.png" alt="testPathExclusion.removal" width=75% style="zoom:50%;" /> |
  
  [^*]: Fixed-path exclusions are not availabile in AppStore/TestFlight version, but in Homebrew due to the need to install the privileged helper.
  
- Toggle exclusion of disks via contextual menu (or toolbar item):
  
  |                  Exclude from Time Machine                   |              Remove Exclusion from Time Machine              |
  | :----------------------------------------------------------: | :----------------------------------------------------------: |
  | <img src="Targets/TMBuddy/Sources/Content/Standalone/Menu+Snapshots/macOS-12.2/testVolumeExclusion.adding.@2x.png" alt="testVolumeExclusion.adding" width=75% style="zoom:50%;" /> | <img src="Targets/TMBuddy/Sources/Content/Standalone/Menu+Snapshots/macOS-12.2/testVolumeExclusion.removal.@2x.png" alt="testVolumeExclusion.removal" width=75% style="zoom:50%;" /> |
  
- Reveal the parent folders which implicitly affect the exclusion of the given item:
  
  <img src="Targets/TMBuddy/Sources/Content/Standalone/Menu+Snapshots/macOS-12.2/testRevealParentExclusion.1.@2x.png" alt="testRevealParentExclusion.1" width=50% style="zoom:50%;" />

## Installation

1. Get the app

   - if you're on macOS 12 or later, from TestFlight:
     [Join the ™ Buddy beta - TestFlight - Apple](https://testflight.apple.com/join/gQCBR8p7)

   - from Homebrew:

     ```
     brew install grigorye/tools/time-machine-buddy
     ```

2. Launch the app and follow the checklist, making sure all the red lights:

   <img src="Targets/TMBuddy/Sources/Content/Standalone/MainWindow+Snapshots/macOS-12.2/test.allRed.@2x.png" alt="Checklist-Red.png" width=75% style="zoom:50%;" />

   turned green:

   <img src="Targets/TMBuddy/Sources/Content/Standalone/MainWindow+Snapshots/macOS-12.2/test.allGreen.@2x.png" alt="Checklist-Green.png" width=75% style="zoom:50%;" />

When selecting folders for the application, typically you want to navigate to Computer and select all the disks for which you want to employ TMBuddy:

<img src=".Images/Disk-Selection.png" width=75% style="zoom:50%;" />

## Troubleshooting

- Sometimes attempt to toggle sticky exclusion results in nothing. Try re-adding the monitored folders in this case.
- If attempt to change fixed-path exclusion fails, please add TMBuddy.app (in addition to .appex) to the [list of applications eligible for full disk access](x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles) and make sure the access is enabled.

## TODO

- Menu bar item

## System Requirements

- macOS 10.15 or later

## License

MIT License. See [LICENSE](LICENSE).
