[![build-app](https://github.com/grigorye/TMBuddy/actions/workflows/build-app.yml/badge.svg)](https://github.com/grigorye/TMBuddy/actions/workflows/build-app.yml)

# TMBuddy

See and manipulate exclusions from Time Machine backup, right in Finder.

## Installation

1. Get the app
   
   - from TestFlight:
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
    
    ![](.Images/Finder-Badge-Path-Excluded.png)
  
  - Item excluded via sticky non-backup attribute:
    
    ![](.Images/Finder-Badge-Sticky-Excluded.png)
  
  - Item excluded as it resides in a folder excluded from backup (this will be default for all items in excluded folders):
        
    ![](.Images/Finder-Badge-Parent-Excluded.png)

## TODO

- Add support for managing exclusion from backup via contextual menu command

## License

MIT License. See [LICENSE](LICENSE).
