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

## What works

- Shows exclusion status for every item on each monitored folder/disk:
  
  - Item excluded by path via Time Machine Settings:
    
    <img src=".Images/Finder-Badge-Path-Excluded.png" style="zoom:50%;" >
  
  - Item excluded via sticky non-backup attribute:
    
    <img src=".Images/Finder-Badge-Sticky-Excluded.png" style="zoom:50%;" >
  
  - Item excluded as it resides in a folder excluded from backup (this will be default for all items in excluded folders):
    
    <img src=".Images/Finder-Badge-Parent-Excluded.png" style="zoom:50%;" >

- Toggling *sticky* exclusion via contextual menu (or toolbar item):
  
  <img src=".Images/Finder-Contextual-Exclude.png" style="zoom:50%;" >
  
  <img title="" src=".Images/Finder-Contextual-Remove-Exclusion.png" style="zoom:50%;" >

## TODO

- Add support for toggling fixed-path exclusions
- Menu bar item

## System Requirements

- macOS 10.15 or later

## License

MIT License. See [LICENSE](LICENSE).
