#  iShop

iShop is a shopping list App built using SwiftUI, available for iPhone and iPad from iOS 14.0+ and MacOS 11.0+

The app features:
- iCloud sync
- Multiple lists
- Item categories
- Item quantities
- Item history (shared across lists)
- Ability to send lists via text, or copy list items
- A host of useful settings to enable customisation

This was a 3 month project, which after some deliberation I have decided to make open source so others may use/learn from it, contribute to development or report issues.

## Notes:
- Data persistence is done through core data.
- Syncronisation is done using iCloud (no login required from users, but doesn't support Android)
- UserDefaults sync using MKiCloudSync.
- Most functions were made global in Functions.swift (I only created methods inside a struct when I needed access to one of the struct's properties).
- All commits were pushed to the Development branch
- The Production branch is the Master branch. I aimed to only push to Production when a new version of the app went live on the App Store.
