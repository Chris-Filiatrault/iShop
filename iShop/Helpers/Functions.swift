//
//  HelperFunctionsGeneric.swift
//  iShop
//
//  Created by Chris Filiatrault on 11/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import CoreData

// =====================================================
// ================= Item functions ====================
// =====================================================



// ===ADD NEW ITEM===
func addNewItem(itemName: Binding<String>, listOrigin: ListOfItems) {
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   let itemEntity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)!
   
   let listFetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ListOfItems")
   
   let categoryFetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Category")
   categoryFetchRequest.predicate = NSPredicate(format: "name == %@", "Uncategorised")
   
   
   do {
      let lists = try managedContext.fetch(listFetchRequest) as! [ListOfItems]
      
      let returnedCategories = try managedContext.fetch(categoryFetchRequest) as! [Category]
      
      // Unique item name --> create a new object of that name for every list
      if itemNameIsUnique(name: itemName.wrappedValue) {
         
         for list in lists {
            let newItem = Item(entity: itemEntity, insertInto: managedContext)
            newItem.name = itemName.wrappedValue
            newItem.id = UUID()
            newItem.dateAdded = Date()
            newItem.addedToAList = false
            newItem.markedOff = false
            newItem.quantity = 1
            newItem.origin = listOrigin
            list.addToItems(newItem)
            
            if returnedCategories != [] {
               let uncategorised = returnedCategories[0]
               print("Got \(uncategorised.wrappedName)")
               
               // add to uncategorised category
               uncategorised.addToItemsInCategory(newItem)
               print("Added item to \(uncategorised.wrappedName) category in \(list.wrappedName)")
            }
            
            // Add a copy of the new item to the list in which it was added
            if list == listOrigin {
               newItem.addedToAList = true
            }
         }
      }
         
         
         // Existing item name --> add from current catalogue to the current list
         // Or increase quantity by 1 if already in the list
      else if !itemNameIsUnique(name: itemName.wrappedValue) {
         
         let originPredicate = NSPredicate(format: "origin = %@", listOrigin)
         let namePredicate = NSPredicate(format: "name = %@", itemName.wrappedValue)
         let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, namePredicate])
         
         let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
         fetchRequest.predicate = compoundPredicate
         
         do {
            let fetchReturn = try managedContext.fetch(fetchRequest)
            
            let items = fetchReturn as! [Item]
            
            if items != [] {
               
               let itemToModify = fetchReturn[0] as! Item
               
               if itemToModify.addedToAList == true {
                  itemToModify.quantity += 1
                  print("Added 1 to quantity")
               }
               else if itemToModify.addedToAList == false {
                  itemToModify.addedToAList = true
                  print("Set addedToAList = true")
               }
            } else if items == [] {
               print("No items fetched, didn't modify item.")
            }
            
            
         } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
         }
      }
      
      
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
   
   
   do {
      try managedContext.save()
   } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
   }
}





// ===ADD ITEM FROM CATALOGUE===
func addItemFromCatalogue(item: Item, listOrigin: ListOfItems) {
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   item.addedToAList = true
   
   do {
      try managedContext.save()
   } catch let error as NSError {
      print("Could not save items. \(error), \(error.userInfo)")
   }
}


// ===REMOVE ITEM FROM LIST===
func removeItemFromList(item: Item) {
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   item.addedToAList = false
   item.markedOff = false
   item.quantity = 1
   
   do {
      try managedContext.save()
   } catch let error as NSError {
      print("Could not save items. \(error), \(error.userInfo)")
   }
}




// ===RENAME ITEM===
// REVISE THIS TO ENSURE ALL ITEMS OF THE SAME NAME ARE UPDATED IN ALL LISTS
func renameItem(currentName: String, newName: String) {
   
   guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
         return
   }
   
   let managedContext =
      appDelegate.persistentContainer.viewContext
   
   let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
   
   do {
      let items = try managedContext.fetch(fetchRequest) as! [Item]
      
      if items != [] {
         for item in items {
            if item.wrappedName == currentName {
               item.name = newName
            }
         }
      }
      
      do {
         try managedContext.save()
      } catch let error as NSError {
         print("Could not save. \(error), \(error.userInfo)")
      }
      
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
}


// === Increment Quantity ===
func incrementItemQuantity(thisItem: Item, thisList: ListOfItems) {
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   thisItem.quantity += 1
   
   do {
      try managedContext.save()
   } catch {
      print("Could not save.")
   }
}


func decrementItemQuantity(thisItem: Item, thisList: ListOfItems) {
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   thisItem.quantity -= 1
   
   do {
      try managedContext.save()
   } catch {
      print("Could not save.")
   }
}

// ===MARK OFF ITEM===
// Mark off the tick circle in a list as having been added to the users basket
func markOffItemInList(thisItem: Item, thisList: ListOfItems) {
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   thisItem.markedOff.toggle()
   
   do {
      try managedContext.save()
      print("Checked off successfully")
   } catch let error as NSError {
      print("Could not save checked off status. \(error), \(error.userInfo)")
   }
}

func restoreItemInList(thisItem: Item, thisList: ListOfItems) {
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   thisItem.markedOff = false
   
   do {
      try managedContext.save()
      print("Restored successfully")
   } catch let error as NSError {
      print("Could not save checked off status. \(error), \(error.userInfo)")
   }
}




// ===CHANGE LIST===
func changeItemList(thisItem: Item, newList: ListOfItems) {
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   for item in newList.itemArray {
      if item.wrappedName == thisItem.wrappedName {
         item.addedToAList = true
         item.markedOff = thisItem.markedOff
         item.quantity = thisItem.quantity
      }
   }
   thisItem.addedToAList = false
   thisItem.markedOff = false
   thisItem.quantity = 1
   
   do {
      try managedContext.save()
   } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
   }
}



// ===CHECK FOR DUPLICATE ITEM NAMES IN MANAGED CONTEXT===
func itemNameIsUnique(name: String) -> Bool {
   
   var result: Bool = true
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
      else {
         return true
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
   
   do {
      let items = try managedContext.fetch(fetchRequest) as! [Item]
      var itemNames: [String] = []
      for item in items {
         itemNames.append(item.wrappedName)
      }
      for itemName in itemNames {
         if name == itemName {
            result = false
         }
      }
      
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
   
   return result
}



// ===CHECK FOR DUPLICATE ITEM NAMES IN AN INDIVIDUAL LIST===
func itemNameInListIsUnique(name: String, thisList: ListOfItems) -> Bool {
   
   var result: Bool = true
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
      else {
         return true
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
   fetchRequest.predicate = NSPredicate(format: "origin = %@", thisList)
   
   do {
      let itemsFromFetchRequest = try managedContext.fetch(fetchRequest) as! [Item]
      var itemNames: [String] = []
      for itemObject in itemsFromFetchRequest {
         itemNames.append(itemObject.wrappedName)
      }
      for itemName in itemNames {
         if name == itemName {
            result = false
         }
      }
      
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
   
   return result
}



// ===REMOVE TICKED ITEMS FROM LIST===
// For when users have ticked off items as "In Basket" and press the tick button in the nav bar
func removeTickedItemsFromList(listOrigin: ListOfItems) {
   
   guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
         return
   }
   
   let managedContext =
      appDelegate.persistentContainer.viewContext
   
   for item in listOrigin.itemArray {
      if item.markedOff == true {
         item.markedOff = false
         item.addedToAList = false
         item.quantity = 1
      }
   }
   
   do {
      try managedContext.save()
      print("Checked off successfully")
   } catch let error as NSError {
      print("Could not save checked off status. \(error), \(error.userInfo)")
   }
}


// DELETE (swiped) ITEM
// Use to remove from a specific list
// The code below needs to be in the same struct in order to access "thisList"



// =====================================================
// ============= ListOfItems functions =================
// =====================================================



// ===ADD LIST===
func addList(listName: String) {
   
   guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate
      else {
         return
   }
   
   let managedContext =
      appDelegate.persistentContainer.viewContext
   
   let listEntity = NSEntityDescription.entity(forEntityName: "ListOfItems", in: managedContext)!
   let itemEntity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)!
   
   let itemFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
   
   let newList = ListOfItems(entity: listEntity, insertInto: managedContext)
   newList.name = listName
   newList.id = UUID()
   
   
   do {
      let itemFetchReturn = try managedContext.fetch(itemFetchRequest)
      let items = itemFetchReturn as! [Item]
      
      var itemsToBeAdded: [Item] = []
      for item in items {
         if itemNameInListIsUnique(name: item.wrappedName, thisList: newList) {
            
            let newItem = Item(entity: itemEntity, insertInto: managedContext)
            newItem.name = item.wrappedName
            newItem.id = UUID()
            newItem.dateAdded = Date()
            newItem.addedToAList = false
            newItem.markedOff = false
            newItem.quantity = 1
            newItem.origin = newList
            newItem.categoryOrigin = item.categoryOrigin
            
            itemsToBeAdded.append(newItem)
         }
         for item in itemsToBeAdded {
            newList.addToItems(item)
         }
      }
      
   } catch let error as NSError {
      print("Could not fetch. \(error)")
   }
   
   
   do {
      try managedContext.save()
      print("Saved list successfully -- \(listName)")
      
   } catch let error as NSError {
      print("Could not save list. \(error), \(error.userInfo)")
   }
}



// ===DELETE (swiped) LIST===
func deleteSwipedList(at offsets: IndexSet) {
   
   guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
         return
   }
   
   let managedContext =
      appDelegate.persistentContainer.viewContext
   
   let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ListOfItems")
   fetchRequest.sortDescriptors = [
      NSSortDescriptor(keyPath: \ListOfItems.name, ascending: true)
   ]
   
   do {
      let fetchReturn = try managedContext.fetch(fetchRequest)
      for offset in offsets {
         
         let returnedObject = fetchReturn[offset]
         
         let listToBeDeleted = returnedObject as! ListOfItems
         for item in listToBeDeleted.itemArray {
            managedContext.delete(item)
         }
         
         managedContext.delete(listToBeDeleted)
         
      }
      
      do {
         try managedContext.save()
         print("Deleted list successfully")
      } catch let error as NSError {
         print("Could not delete. \(error), \(error.userInfo)")
      }
      
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
}



//===CHECK FOR DUPLICATE LIST===
func listNameIsUnique(name: String) -> Bool {
   
   var result: Bool = true
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
      else {
         return true
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ListOfItems")
   
   do {
      let listsFromFetchRequest = try managedContext.fetch(fetchRequest) as! [ListOfItems]
      var listOfNames: [String] = []
      for list in listsFromFetchRequest {
         listOfNames.append(list.wrappedName)
      }
      for listName in listOfNames {
         if name == listName {
            result = false
         }
      }
      
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
   
   return result
}



//===GET NUMBER OF UNTICKED ITEMS===
func numListUntickedItems(list: ListOfItems) -> Int {
   
   var result: Int = 0
   
   for item in list.itemArray {
      if item.markedOff == false && item.addedToAList == true {
         result += 1
      }
   }
   return result
}









// =====================================================
// =============== Category functions ==================
// =====================================================


// ===ADD CATEGORY===
// Initialise category
// Add the current item to it
func addCategory(categoryName: String, thisItem: Item) {
   
   guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate
      else {
         return
   }
   
   let managedContext =
      appDelegate.persistentContainer.viewContext
   
   let categoryEntity = NSEntityDescription.entity(forEntityName: "Category", in: managedContext)!
   
   let newCategory = Category(entity: categoryEntity, insertInto: managedContext)
   newCategory.name = categoryName
   newCategory.id = UUID()
   newCategory.dateAdded = Date()
   newCategory.defaultCategory = false
   
   let itemFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
   itemFetchRequest.predicate = NSPredicate(format: "name == %@", thisItem.wrappedName)
   
   do {
      
      let itemFetchReturn = try managedContext.fetch(itemFetchRequest)
      let items = itemFetchReturn as! [Item]
      
      if items != [] {
         for item in items {
            item.categoryOrigin = newCategory
            newCategory.addToItemsInCategory(item)
         }
      }
      
   } catch let error as NSError {
      print("Could not fetch. \(error)")
   }
   do {
      try managedContext.save()
      print("Saved category successfully -- \(categoryName)")
      
   } catch let error as NSError {
      print("Could not save list. \(error), \(error.userInfo)")
   }
}


// ===CHANGE CATEGORY===
func changeCategory1(thisItem: Item, oldCategory: Category, newCategory: Category) {
   
   guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
         return
   }
   
   let managedContext =
      appDelegate.persistentContainer.viewContext
   
   let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
   fetchRequest.sortDescriptors = [
      NSSortDescriptor(keyPath: \Item.name, ascending: true)
   ]
   fetchRequest.predicate = NSPredicate(format: "name == %@", thisItem.wrappedName)
   
   do {
      let items = try managedContext.fetch(fetchRequest) as! [Item]
      for item in items {
         if items != [] {
            item.categoryOrigin = newCategory
         }
      }
      do {
         try managedContext.save()
      } catch let error as NSError {
         print("Could not delete. \(error), \(error.userInfo)")
      }
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
}

func changeCategory2(thisItem: Item, oldItemCategory: Category, newItemCategory: Category) {
   for item in oldItemCategory.itemsInCategoryArray {
      if item.wrappedName == thisItem.wrappedName {
         oldItemCategory.removeFromItemsInCategory(item)
      }
   }
   for item in newItemCategory.itemsInCategoryArray {
      if item.wrappedName == thisItem.wrappedName {
         newItemCategory.addToItemsInCategory(item)
      }
   }
}




//===CHECK FOR DUPLICATE CATEGORY===
func categoryNameIsUnique(name: String) -> Bool {
   
   var result: Bool = true
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
      else {
         return true
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Category")
   
   do {
      let categoriesFromFetchRequest = try managedContext.fetch(fetchRequest) as! [Category]
      var listOfCategoryNames: [String] = []
      for category in categoriesFromFetchRequest {
         listOfCategoryNames.append(category.wrappedName)
      }
      for categoryName in listOfCategoryNames {
         if name == categoryName {
            result = false
         }
      }
      
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
   
   return result
}





// ===UNCATEGORISED CATEGORY===
func uncategorisedCategory() -> Category? {
   
   guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
         return nil
   }
   
   let managedContext =
      appDelegate.persistentContainer.viewContext
   
   let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Category")
   fetchRequest.predicate = NSPredicate(format: "name == %@", "Uncategorised")
   
   do {
      let fetchReturn = try managedContext.fetch(fetchRequest) as! [Category]
      if fetchReturn != [] {
      let uncategorised = fetchReturn[0]
      return uncategorised
      }
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
   return nil
}

// ===UNCATEGORISED CATEGORY===
func inBasketCategory() -> Category? {
   
   guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
         return nil
   }
   
   let managedContext =
      appDelegate.persistentContainer.viewContext
   
   let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Category")
   fetchRequest.predicate = NSPredicate(format: "name == %@", "In Basket")
   
   do {
      let fetchReturn = try managedContext.fetch(fetchRequest) as! [Category]
      if fetchReturn != [] {
      let uncategorised = fetchReturn[0]
      return uncategorised
      }
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
   return nil
}









// =====================================================
// ================= Misc functions ====================
// =====================================================


// CHECK WHETHER FIRST TIME LAUNCH
// Returns true if yes
func firstTimeLaunch() -> Bool {
   let defaults = UserDefaults.standard
   if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
      return false
   } else {
      defaults.set(false, forKey: "isAppAlreadyLaunchedOnce")
      return true
   }
}


func userHasNoLists() -> Bool {
   
   var result: Bool = false
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
      else {
         return false
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ListOfItems")
   
   do {
      let listsFromFetchRequest = try managedContext.fetch(fetchRequest) as! [ListOfItems]
      
      result = listsFromFetchRequest.count == 0
      
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
   
   return result
}








func swipeDeleteTestFunction(at offsets: IndexSet) {
   print("Deleted")
}


