[![build-app](https://github.com/grigorye/TMBuddy/actions/workflows/build-app.yml/badge.svg)](https://github.com/grigorye/TMBuddy/actions/workflows/build-app.yml)

# TMBuddy

See and manipulate exclusions from Time Machine backup, right in Finder.

## Installation

1. Get the app
   
   - if you're on macOS 12 or later, from TestFlight:
     [Join the ™ Buddy beta - TestFlight - Apple](https://testflight.apple.com/join/gQCBR8p7)
   
   - from Homebrew:
     
     ```
     brew install grigorye/tools/time-machine-buddy
     ```

2. Launch the app and follow the checklist, making sure all the red lights:
   <img src="Targets/TMBuddy/Sources/Content/Standalone/MainWindow+Snapshots/test.allRed.png" alt="Checklist-Red.png" style="zoom:50%;" />
   turned green:
   <img src="Targets/TMBuddy/Sources/Content/Standalone/MainWindow+Snapshots/test.allGreen.png" alt="Checklist-Green.png" style="zoom:50%;" />

When selecting folders for the application, typically you want to navigate to Computer and select all the disks for which you want to employ TMBuddy:
<img src=".Images/Disk-Selection.png" style="zoom:50%;" />

## Features

- See exclusion status for every item of each monitored folder/disk:
  
  <img src="./Targets/TMBuddy/Sources/Legend/LegendView+Snapshots/test.1.png" alt="test.1" height="329" />
  
- Toggle *sticky* or *fixed-path* [^*] exclusion via contextual menu (or toolbar item):
  
  |                  Exclude from Time Machine                   |              Remove Exclusion from Time Machine              |
  | :----------------------------------------------------------: | :----------------------------------------------------------: |
  | <img src="Targets/TMBuddy/Sources/Content/Standalone/Menu+Snapshots/testPathExclusion.adding.png" alt="testPathExclusion.adding" style="zoom:50%;" /> | <img src="Targets/TMBuddy/Sources/Content/Standalone/Menu+Snapshots/testPathExclusion.removal.png" alt="testPathExclusion.removal" style="zoom:50%;" /> |
  
  [^*]: Fixed-path exclusions are not availabile in AppStore/TestFlight version, but in Homebrew due to the need to install the privileged helper.
  
- Toggle exclusion of disks via contextual menu (or toolbar item):
  
  |                  Exclude from Time Machine                   |              Remove Exclusion from Time Machine              |
  | :----------------------------------------------------------: | :----------------------------------------------------------: |
  | <img src="Targets/TMBuddy/Sources/Content/Standalone/Menu+Snapshots/testVolumeExclusion.adding.png" alt="testVolumeExclusion.adding" style="zoom:50%;" /> | <img src="Targets/TMBuddy/Sources/Content/Standalone/Menu+Snapshots/testVolumeExclusion.removal.png" alt="testVolumeExclusion.removal" style="zoom:50%;" /> |
  
- Reveal the parent folders which implicitly affect the exclusion of the given item:
  
  <img src="Targets/TMBuddy/Sources/Content/Standalone/Menu+Snapshots/testRevealParentExclusion.1.png" alt="testRevealParentExclusion.1" style="zoom:50%;" />

## Troubleshooting

- Sometimes attempt to toggle sticky exclusion results in nothing. Try re-adding the monitored folders in this case.
- If attempt to change fixed-path exclusion fails, please add TMBuddy.app (in addition to .appex) to the [list of applications eligible for full disk access](x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles) and make sure the access is enabled.

## TODO

- Menu bar item

## System Requirements

- macOS 10.15 or later

## License

MIT License. See [LICENSE](LICENSE).
