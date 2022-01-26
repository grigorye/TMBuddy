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
   <img src=".Images/Checklist-Red.png" alt="Checklist-Red.png" style="zoom:50%;" />
   turned green:
   <img src=".Images/Checklist-Green.png" alt="Checklist-Green.png" style="zoom:50%;" />

When selecting folders for the application, typically you want to navigate to Computer and select all the disks for which you want to employ TMBuddy:
<img src=".Images/Disk-Selection.png" style="zoom:50%;" />

## Features

- See exclusion status for every item of each monitored folder/disk:
  
  |                             Icon                             | State                                      |
  | :----------------------------------------------------------: | ------------------------------------------ |
  | <img src=".Images/Finder-Badge-Path-Excluded.png" style="zoom:50%;" > | Excluded by path via Time Machine Settings |
  | <img src=".Images/Finder-Badge-Sticky-Excluded.png" style="zoom:50%;" > | Excluded via sticky non-backup attribute   |
  | <img src=".Images/Finder-Badge-Parent-Excluded.png" style="zoom:50%;" > | Excluded due to excluded parent            |
  
  
  
- Toggle *sticky* exclusion via contextual menu (or toolbar item):
  
  
  
  |                  Exclude from Time Machine                   |              Remove Exclusion from Time Machine              |
  | :----------------------------------------------------------: | :----------------------------------------------------------: |
  | <img src=".Images/Finder-Contextual-Exclude.png" style="zoom:50%;" > | <img title="" src=".Images/Finder-Contextual-Remove-Exclusion.png" style="zoom:50%;" > |

## Troubleshooting

- Sometimes attempt to toggle sticky exclusion results in nothing. Try re-adding the monitored folders in this case.

## TODO

- Add support for toggling fixed-path exclusions
- Menu bar item

## System Requirements

- macOS 10.15 or later

## License

MIT License. See [LICENSE](LICENSE).
