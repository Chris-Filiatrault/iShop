#  iShop

iShop is a shopping list app built using SwiftUI, available for iPhone and iPad from iOS 13.0 onwards.

The app features:
- iCloud sync
- Multiple lists
- Item categories
- Item quantities
- Item history (shared across lists)
- Ability to send lists via text, or copy list items
- A host of useful settings to enable customisation

This was a 3 month project, which after some deliberation I have decided to make open source so others may use/learn from it.

## Notes:
- Data persistence is done through core data.
- Syncronisation is done using iCloud (no login required from users, but doesn't support Android)
- UserDefaults sync using MKiCloudSync.
- Most functions were made global in Functions.swift (I only created methods inside a struct when I needed access to one of the struct's properties).



## Known issues:
- Code hasn't been tailored specifically for iOS 13 vs 14 users. I fixed up most bugs after iOS 14 was introduced, though some issues may remain there. Particularly scrolling to the bottom of the Catalogue (Item History) for iOS 13 users. AdaptsToSK can be used to fix this.
- No back button when selecting what list an item belongs to (iOS 14 bug).


## Feature ideas:
- Manage categories section in settings (including an easy way to categorise all the uncategorised items)
- Tab view in Item History, to sort by alphabet / frequently purchased items
- Implement the ability to drag an item from one category to another when using categories (without breaking the swipe to delete function). 
- Ability to search list of items
- Dark Mode
- Custom app icons
- Price of items + subtotal down the bottom (using the *price* property. No coredata migration required.)
- Ability to reorder categories, which is reflected inside each list (using the *position* property. No coredata migration required.)



