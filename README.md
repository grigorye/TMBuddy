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
   ![Checklist-Red.png](.Images/Checklist-Red.png)
   turned green:
   ![Checklist-Green.png](.Images/Checklist-Green.png)

When selecting folders for the application, typically you want to navigate to Computer and select all the disks for which you want to employ TMBuddy:
![](.Images/Disk-Selection.png)

## What works

- Shows exclusion status for every item on each monitored folder/disk:
  
  - Item excluded by path via Time Machine Settings:
    
    <img src=".Images/Finder-Badge-Path-Excluded.png" title="" alt="" width="120">
  
  - Item excluded via sticky non-backup attribute:
    
    <img src=".Images/Finder-Badge-Sticky-Excluded.png" title="" alt="" width="120">
  
  - Item excluded as it resides in a folder excluded from backup (this will be default for all items in excluded folders):
    
    <img src=".Images/Finder-Badge-Parent-Excluded.png" title="" alt="" width="120">

- Toggling *sticky* exclusion via contextual menu (or toolbar item):

<img src=".Images/Finder-Contextual-Exclude.png" title="" alt="" height="400">
  <img title="" src=".Images/Finder-Contextual-Remove-Exclusion.png" alt="" height="400">

## TODO

- Add support for toggling fixed-path exclusions
- Menu bar item

## System Requirements

- macOS 10.15 or later

## License

MIT License. See [LICENSE](LICENSE).
