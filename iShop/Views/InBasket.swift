//
//  InBasket.swift
//  iShop
//
//  Created by Chris Filiatrault on 17/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import CoreData

struct InBasket: View {
   var thisList: ListOfItems
   var category: Category
   var items: FetchRequest<Item>
//   var noItems: Int {
//      var numItems: Int = 0
//      for item in items.wrappedValue {
//         numItems += 1
//      }
//      return numItems
//   }
//   var oneOrMoreItemsAreMarkedOff: Bool {
//      var numItems: Int = 0
//      ForEach(items.wrappedValue, id: \.self) { item in
//         if item.markedOff == true {
//            numItems += 1
//         }
//      }
//      return numItems > 0
//   }
//
//
   init(listFromHomePage: ListOfItems, categoryFromItemList: Category) {

      thisList = listFromHomePage
      category = categoryFromItemList

      let originPredicate = NSPredicate(format: "origin = %@", thisList)
      let inListPredicate = NSPredicate(format: "addedToAList == true")
      let markedOffPredicate = NSPredicate(format: "markedOff == true")
//      let categoryPredicate = NSPredicate(format: "categoryOrigin = %@", category)
      let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, inListPredicate, markedOffPredicate])

      items = FetchRequest<Item>(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
      ], predicate: compoundPredicate)

   }

   var body: some View {

      Group {
         if items.wrappedValue.count > 0 {

            Text(category.wrappedName)
               .font(.headline)
               .listRowBackground(Color("listBackground"))
               .offset(y: 7)

            ForEach(items.wrappedValue, id: \.self) { item in
               ItemRow(thisList: self.thisList, thisItem: item, itemInListMarkedOff: item.markedOff)
            }.onDelete(perform: removeSwipedItem)
         }
      }

   }

   // REMOVE (swiped) ITEM
   func removeSwipedItem(at offsets: IndexSet) {

      guard let appDelegate =
         UIApplication.shared.delegate as? AppDelegate else {
            return
      }

      let managedContext =
         appDelegate.persistentContainer.viewContext

      let thisListsAndCategoryFetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
      thisListsAndCategoryFetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
      ]
      thisListsAndCategoryFetchRequest.predicate = NSPredicate(format: "origin = %@", thisList)
      thisListsAndCategoryFetchRequest.predicate = NSPredicate(format: "categoryOrigin = %@", category)

      for offset in offsets {
         let thisItem = items.wrappedValue[offset]
         thisItem.addedToAList = false
         thisItem.markedOff = false
      }
      do {
         try managedContext.save()
      } catch let error as NSError {
         print("Could not delete. \(error), \(error.userInfo)")
      }
   } // End of function

}



//
////
////  ItemCategory.swift
////  iShop
////
////  Created by Chris Filiatrault on 1/6/20.
////  Copyright © 2020 Chris Filiatrault. All rights reserved.
////
////
//import SwiftUI
//import CoreData
//
//struct InBasket: View {
//   var thisList: ListOfItems
//   var thisCategory: Category
//   var items: FetchRequest<Item>
//   var thisCategoryHasItems: Bool {
//      var numItems: Int = 0
//      for item in thisCategory.itemsInCategoryArray {
//         if item.addedToAList == true && thisList.itemArray.contains(item) && item.markedOff == true {
//            numItems += 1
//         }
//      }
//      return numItems > 0
//   }
//
//   init(listFromHomePage: ListOfItems, categoryFromItemList: Category) {
//
//
//      thisList = listFromHomePage
//      thisCategory = categoryFromItemList
//
//      let originPredicate = NSPredicate(format: "origin = %@", thisList)
//      let inListPredicate = NSPredicate(format: "addedToAList == true")
//      let categoryPredicate = NSPredicate(format: "categoryOrigin = %@", thisCategory)
//      let markedOffPredicate = NSPredicate(format: "markedOff == true")
//      let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, inListPredicate, categoryPredicate, markedOffPredicate])
//
//      items = FetchRequest<Item>(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
//      ], predicate: compoundPredicate)
//
//   }
//
//   var body: some View {
//
//      Group {
//         if thisCategoryHasItems {
//
//            Text(thisCategory.wrappedName)
//               .font(.headline)
//               .listRowBackground(Color("listBackground"))
//               .offset(y: 7)
//
//
//            ForEach(items.wrappedValue, id: \.self) { item in
//               ItemRow(thisList: self.thisList, thisItem: item, itemInListMarkedOff: item.markedOff)
//            }.onDelete(perform: removeSwipedItem)
//         }
//      }
//
//   }
//
//   // REMOVE (swiped) ITEM
//   func removeSwipedItem(at offsets: IndexSet) {
//
//      guard let appDelegate =
//         UIApplication.shared.delegate as? AppDelegate else {
//            return
//      }
//
//      let managedContext =
//         appDelegate.persistentContainer.viewContext
//
//      let thisListsAndCategoryFetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
//      thisListsAndCategoryFetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
//      ]
//      thisListsAndCategoryFetchRequest.predicate = NSPredicate(format: "origin = %@", thisList)
//      thisListsAndCategoryFetchRequest.predicate = NSPredicate(format: "categoryOrigin = %@", thisCategory)
//
//      for offset in offsets {
//         let thisItem = items.wrappedValue[offset]
//         thisItem.addedToAList = false
//         thisItem.markedOff = false
//      }
//      do {
//         try managedContext.save()
//      } catch let error as NSError {
//         print("Could not delete. \(error), \(error.userInfo)")
//      }
//   } // End of function
//
//}
//
