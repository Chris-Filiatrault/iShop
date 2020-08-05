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
// ====================== Item =========================
// =====================================================


// ===ADD NEW ITEM===
func addNewItem(itemName: Binding<String>, listOrigin: ListOfItems) {
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   let itemEntity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)!
   
   let listFetchRequest:NSFetchRequest<ListOfItems> = NSFetchRequest.init(entityName: "ListOfItems")
   
   let categoryFetchRequest:NSFetchRequest<Category> = NSFetchRequest.init(entityName: "Category")
   categoryFetchRequest.predicate = NSPredicate(format: "name == %@", "Uncategorised")
   
   
   //   let originPredicate = NSPredicate(format: "origin == %@", listOrigin)
   ////   let addedToAListPredicate = NSPredicate(format: "addedToAList == %@", true)
   //   let markedOffPredicate = NSPredicate(format: "markedOff == %@", false)
   //   let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, markedOffPredicate])
   //
   //   let itemFetchRequest:NSFetchRequest<Item> = NSFetchRequest.init(entityName: "Item")
   //   itemFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.position, ascending: true)]
   //   itemFetchRequest.predicate = compoundPredicate
   
   do {
      let lists = try managedContext.fetch(listFetchRequest)
      let returnedCategories = try managedContext.fetch(categoryFetchRequest)
      
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
            newItem.originName = listOrigin.name
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
               var numItemsInList = 0
               for item in list.itemArray {
                  if item.addedToAList == true && item.markedOff == false {
                     numItemsInList += 1
                  }
               }
               newItem.addedToAList = true
               newItem.position = Int32(numItemsInList)
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
   
   let originPredicate = NSPredicate(format: "origin = %@", listOrigin)
   let inListPredicate = NSPredicate(format: "addedToAList == true")
   let markedOffPredicate = NSPredicate(format: "markedOff == false")
   let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, inListPredicate, markedOffPredicate])
   
   let fetchRequest: NSFetchRequest<Item> = NSFetchRequest.init(entityName: "Item")
   fetchRequest.predicate = compoundPredicate
   
   do {
      
      let items = try managedContext.fetch(fetchRequest)
      
      item.addedToAList = true
      item.position = Int32(items.count - 1)
      
      
      do {
         try managedContext.save()
      } catch let error as NSError {
         print("Could not save items. \(error), \(error.userInfo)")
      }
      
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
}


// ===REMOVE ITEM FROM LIST===
func removeItemFromList(thisItem: Item, listOrigin: ListOfItems) {
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   let originPredicate = NSPredicate(format: "origin = %@", listOrigin)
   let addedToAListPredicate = NSPredicate(format: "addedToAList == true")
   let markedOffPredicate = NSPredicate(format: "markedOff == false")
   let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, addedToAListPredicate, markedOffPredicate])
   
   let fetchRequest: NSFetchRequest<Item> = NSFetchRequest.init(entityName: "Item")
   fetchRequest.predicate = compoundPredicate
   
   do {
      
      let items = try managedContext.fetch(fetchRequest)
      
      if items != [] && thisItem.markedOff == false {
         for item in items {
            if item.position > thisItem.position {
               item.position -= 1
            }
         }
      }
      
      thisItem.addedToAList = false
      thisItem.markedOff = false
      thisItem.quantity = 1
      thisItem.position = 0
      
      do {
         try managedContext.save()
      } catch let error as NSError {
         print("Could not save items. \(error), \(error.userInfo)")
      }
      
      
   } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
   }
}


// ===RENAME ITEM===
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


// ===INCREMENT QUANTITY===
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
   
   let originPredicate = NSPredicate(format: "origin = %@", thisList)
   let addedToAListPredicate = NSPredicate(format: "addedToAList == true")
   let markedOffPredicate = NSPredicate(format: "markedOff == false")
   let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, addedToAListPredicate, markedOffPredicate])
   
   let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
   fetchRequest.predicate = compoundPredicate
   
   do {
      let items = try managedContext.fetch(fetchRequest) as! [Item]
      
      for item in items {
         if item.position > thisItem.position {
            item.position -= 1
         }
      }
      
      thisItem.markedOff = true
      thisItem.position = 0
      GlobalVariableClass().refreshingID = UUID()
      
      
      do {
         try managedContext.save()
      } catch let error as NSError {
         print("Could not save checked off status. \(error), \(error.userInfo)")
      }
      
      
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
   
}


// ===RESTORE ITEM IN LIST===
func restoreItemInList(thisItem: Item, thisList: ListOfItems) {
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   let originPredicate = NSPredicate(format: "origin = %@", thisList)
   let addedToAListPredicate = NSPredicate(format: "addedToAList == true")
   let markedOffPredicate = NSPredicate(format: "markedOff == false")
   let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, addedToAListPredicate, markedOffPredicate])
   
   let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
   fetchRequest.predicate = compoundPredicate
   
   do {
      let items = try managedContext.fetch(fetchRequest) as! [Item]
      
      thisItem.markedOff = false
      thisItem.position = Int32(items.count)
      GlobalVariableClass().refreshingID = UUID()
      
      do {
         try managedContext.save()
      } catch let error as NSError {
         print("Could not save checked off status. \(error), \(error.userInfo)")
      }
      
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
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


// DELETE (swiped) ITEM
// Use to remove from a specific list
// The code below needs to be in the same struct in order to access "thisList"



// =====================================================
// ================== ListOfItems ======================
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
   
   let itemFetchRequest: NSFetchRequest<Item> = NSFetchRequest.init(entityName: "Item")
   
   let listFetchRequest: NSFetchRequest<ListOfItems> = NSFetchRequest.init(entityName: "ListOfItems")
   listFetchRequest.predicate = NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D")
   
   
   do {
      let items = try managedContext.fetch(itemFetchRequest)
      let lists = try managedContext.fetch(listFetchRequest)
      
      let newList = ListOfItems(entity: listEntity, insertInto: managedContext)
      newList.name = listName
      newList.id = UUID()
      newList.position = Int32(lists.count)
      
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
            newItem.position = 0
            
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


// ===RENAME LIST===
func renameList(thisList: ListOfItems, newName: String) {
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
   }
   let managedContext = appDelegate.persistentContainer.viewContext
   
   thisList.name = newName
   
   do {
      try managedContext.save()
   } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
   }
}

// ===DELETE SWIPED LIST (alphabetical fetch request)===
func deleteSwipedListAlphabetical(indices: IndexSet) {
   
   guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
         return
   }
   
   let managedContext =
      appDelegate.persistentContainer.viewContext
   
   let fetchRequest:NSFetchRequest<ListOfItems> = NSFetchRequest.init(entityName: "ListOfItems")
   fetchRequest.sortDescriptors = [
      NSSortDescriptor(keyPath: \ListOfItems.name, ascending: true)
   ]
   fetchRequest.predicate = NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D")
   
   do {
      
      let lists = try managedContext.fetch(fetchRequest)
      for index in indices {
         
         let listToBeDeleted = lists[index]
         for list in lists {
            if list.position > listToBeDeleted.position {
               list.position -= 1
            }
         }
         
         for item in listToBeDeleted.itemArray {
            managedContext.delete(item)
         }
         
         managedContext.delete(listToBeDeleted)
         
         if userHasNoLists() {
            addList(listName: "Groceries")
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

// ===DELETE SWIPED LIST (by position fetch request)===
func deleteSwipedListManual(indices: IndexSet) {
   
   guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
         return
   }
   
   let managedContext =
      appDelegate.persistentContainer.viewContext
   
   let fetchRequest:NSFetchRequest<ListOfItems> = NSFetchRequest.init(entityName: "ListOfItems")
   fetchRequest.sortDescriptors = [
      NSSortDescriptor(keyPath: \ListOfItems.position, ascending: true)
   ]
   fetchRequest.predicate = NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D")
   
   
   do {
      let lists = try managedContext.fetch(fetchRequest)
      for index in indices {
         
         let listToBeDeleted = lists[index]
         for list in lists {
            if list.position > listToBeDeleted.position {
               list.position -= 1
            }
         }
         
         for item in listToBeDeleted.itemArray {
            managedContext.delete(item)
         }
         
         managedContext.delete(listToBeDeleted)
         
         if userHasNoLists() {
            addList(listName: "Groceries")
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

// ===DELETE LIST===
func deleteList(thisList: ListOfItems) {
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
   }
   let managedContext = appDelegate.persistentContainer.viewContext
   
   let listFetchRequest: NSFetchRequest<ListOfItems> = NSFetchRequest.init(entityName: "ListOfItems")
   listFetchRequest.sortDescriptors = [
      NSSortDescriptor(keyPath: \ListOfItems.position, ascending: true)
   ]
   listFetchRequest.predicate = NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D")
   
   do {
      let lists = try managedContext.fetch(listFetchRequest)
      
      for list in lists {
         if list.position > thisList.position {
            list.position -= 1
         }
      }
      
      for item in thisList.itemArray {
         managedContext.delete(item)
      }
      managedContext.delete(thisList)
      
      do {
         try managedContext.save()
      } catch let error as NSError {
         print("Could not save. \(error), \(error.userInfo)")
      }
   } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
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


//===GET NUMBER OF UNTICKED ITEMS IN LIST===
func numListUntickedItems(list: ListOfItems) -> Int {
   
   var result: Int = 0
   
   for item in list.itemArray {
      if item.markedOff == false && item.addedToAList == true {
         result += 1
      }
   }
   return result
}


// ===DELETE ALL ITEMS===
func clearList(thisList: ListOfItems) {
   
   guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
         return
   }
   let managedContext =
      appDelegate.persistentContainer.viewContext
   
   for item in thisList.itemArray {
      item.markedOff = false
      item.addedToAList = false
      item.quantity = 1
      item.position = 0
   }
   
   do {
      try managedContext.save()
   } catch let error as NSError {
      print("Could not save checked off status. \(error), \(error.userInfo)")
   }
}


// ===MOVE LIST===
func moveList(IndexSet: IndexSet, destination: Int) {
   
   guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
         return
   }
   
   let managedContext =
      appDelegate.persistentContainer.viewContext
   
   let fetchRequest:NSFetchRequest<ListOfItems> = NSFetchRequest.init(entityName: "ListOfItems")
   fetchRequest.predicate = NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D")
   fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.position, ascending: true)]
   
   
   do {
      let lists = try managedContext.fetch(fetchRequest)
      
      let firstIndex = IndexSet.min()!
      let lastIndex = IndexSet.max()!
      
      let firstRowToReorder = (firstIndex < destination) ? firstIndex : destination
      let lastRowToReorder = (lastIndex > (destination-1)) ? lastIndex : (destination-1)
      
      if firstRowToReorder != lastRowToReorder && lists != [] {
         
         var newOrder = firstRowToReorder
         if newOrder < firstIndex {
            // Moving dragged items up, so re-order dragged items first
            
            // Re-order dragged items
            for index in IndexSet {
               lists[index].setValue(newOrder, forKey: "position")
               newOrder = newOrder + 1
            }
            
            // Re-order non-dragged items
            for rowToMove in firstRowToReorder..<lastRowToReorder {
               if !IndexSet.contains(rowToMove) {
                  lists[rowToMove].setValue(newOrder, forKey: "position")
                  newOrder = newOrder + 1
               }
            }
         } else if lists != [] {
            // Moving dragged items down, so re-order dragged items last
            
            // Re-order non-dragged items
            for rowToMove in firstRowToReorder...lastRowToReorder {
               if !IndexSet.contains(rowToMove) {
                  lists[rowToMove].setValue(newOrder, forKey: "position")
                  newOrder = newOrder + 1
               }
            }
            
            // Re-order dragged items
            for index in IndexSet {
               lists[index].setValue(newOrder, forKey: "position")
               newOrder = newOrder + 1
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


// ===SORT LIST POSITIONS ALPHABETICALLY===
func sortListPositionsAlphabetically() {
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
      else {
         return
   }
   let managedContext = appDelegate.persistentContainer.viewContext
   
   let fetchRequest: NSFetchRequest<ListOfItems> = NSFetchRequest.init(entityName: "ListOfItems")
   fetchRequest.predicate = NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D")
   fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ListOfItems.name, ascending: true)]
   
   do {
      let lists = try managedContext.fetch(fetchRequest)
      var index: Int = 0
      for list in lists {
         list.position = Int32(index)
         index += 1
      }
      
      do {
         try managedContext.save()
      } catch let error as NSError {
         print("Could not save.\(error), \(error.userInfo)")
      }
      
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
   
}


// =====================================================
// ==================== Category =======================
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
// Originally happened in two parts (changing categoryOrigin + changing itemsInCategoryArray) to avoid mutating state warnings etc
// But doing so makes the "done" button stop working in ItemDetails, so decided to just go with the mutating state warning and hope it doesn't cause issues.
// Also triggering changeCategory2 when the user presses "done" in ItemDetails isn't a great way to go, as they may not press it after changing category
func changeCategory(thisItem: Item, oldItemCategory: Category, newItemCategory: Category) {
   
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
            item.categoryOrigin = newItemCategory
         }
      }
      for item in oldItemCategory.itemsInCategoryArray {
         if item.wrappedName == thisItem.wrappedName {
            newItemCategory.addToItemsInCategory(item)
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


//===GET NUMBER OF UNTICKED ITEMS IN CATEGORY===
func numCategoryUntickedItems(category: Category) -> Int {
   
   var result: Int = 0
   
   for item in category.itemsInCategoryArray {
      if item.markedOff == false && item.addedToAList == true {
         result += 1
      }
   }
   return result
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
func inCartCategory() -> Category? {
   
   guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
         return nil
   }
   
   let managedContext =
      appDelegate.persistentContainer.viewContext
   
   let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Category")
   fetchRequest.predicate = NSPredicate(format: "name == %@", "In Cart")
   
   do {
      let fetchReturn = try managedContext.fetch(fetchRequest) as! [Category]
      if fetchReturn != [] {
         let inCart = fetchReturn[0]
         return inCart
      }
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
   return nil
}


//===MERGE STARTUP CATEGORIES TOGETHER===
// For when a user starts using the app on another device and startup items/lists/categories are duplicated
func mergeStartupCategories(context: NSManagedObjectContext) {
   
   let categoryFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Category")
   categoryFetchRequest.predicate = NSPredicate(format: "name IN %@", startupCategoryStrings())
   
   let initDateFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "InitDate")
   initDateFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \InitDate.initDate, ascending: true)]
   
   do {
      let dates = try context.fetch(initDateFetchRequest) as! [InitDate]
      let categories = try context.fetch(categoryFetchRequest) as! [Category]
      
      // Get the earliest date
      if dates != [] {
         let earliestDate = dates[0].initDate
         
         // Get all categories made on the earliest date + all other categories
         var originalCategories: [Category] = []
         var otherCategories: [Category] = []
         var remainingCategoryNames: [String] = []
         for category in categories {
            if category.dateAdded == earliestDate {
               originalCategories.append(category)
               remainingCategoryNames.append(category.wrappedName)
            } else {
               otherCategories.append(category)
            }
         }
         
         // For all other categories:
         
         // If no original category with that name exists (deleted by user), delete any newly created categories with that name
         for otherCategory in otherCategories {
            if !remainingCategoryNames.contains(otherCategory.wrappedName) {
               context.delete(otherCategory)
            }
            else {
               // move all items from the newly created category with the same name into the original category
               for originalCategory in originalCategories {
                  if originalCategory.wrappedName == otherCategory.wrappedName {
                     for item in otherCategory.itemsInCategoryArray {
                        originalCategory.addToItemsInCategory(item)
                        item.categoryOrigin = originalCategory
                     }
                  }
               }
               // then delete the new duplicate category
               context.delete(otherCategory)
            }
         }
      }
      
      do {
         try context.save()
      } catch let error as NSError {
         print("Could not save. \(error), \(error.userInfo)")
      }
      
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
}



// =====================================================
// ==================== InitDate =======================
// =====================================================

// ===CREATE NEW INITDATE===
func createNewInitDate() {
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   let initDateEntity = NSEntityDescription.entity(forEntityName: "InitDate", in: managedContext)!
   
   let newInitDate = InitDate(entity: initDateEntity, insertInto: managedContext)
   newInitDate.initDate = Date()
   
   do {
      try managedContext.save()
   } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
   }
}


// ===CHECK IF INIT CODE WAS RUN ON ANOTHER DEVICE===
func initCodeWasRunOnAnotherDevice(context: NSManagedObjectContext) -> Bool {
   var result: Bool = false
   
   let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "InitDate")
   fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \InitDate.initDate, ascending: true)]
   
   do {
      let dates = try context.fetch(fetchRequest) as! [InitDate]
      
      result = dates.count > 1
      //      print("Result is: \(result)")
      //      print("No. dates is: \(dates.count)")
      
      if dates != [] {
         let earliestDate = dates[0].initDate
         for date in dates {
            if date.initDate != earliestDate {
               context.delete(date)
            }
         }
      }
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
   
   return result
}


// =====================================================
// ====================== Misc =========================
// =====================================================


// ===CHECK WHETHER FIRST TIME LAUNCH===
// Returns true if yes
func isFirstTimeLaunch() -> Bool {
   if UserDefaults.standard.bool(forKey: "syncUserHasLaunchedPreviously") != true {
      UserDefaults.standard.set(true, forKey: "syncUserHasLaunchedPreviously")
      return true
   } else {
      UserDefaults.standard.set(true, forKey: "syncUserHasLaunchedPreviously")
      return false
   }
}


// ===USER HAS NO LISTS===
func userHasNoLists() -> Bool {
   
   var result: Bool = false
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
      else {
         return false
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ListOfItems")
   fetchRequest.predicate = NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D")
   
   do {
      let listsFromFetchRequest = try managedContext.fetch(fetchRequest) as! [ListOfItems]
      
      result = listsFromFetchRequest.count == 0
      
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
   
   return result
}


// ===USER HAS NO CATEGORIES===
func userHasNoCategories() -> Bool {
   
   var result: Bool = false
   
   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
      else {
         return false
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Category")
   
   do {
      let categoriesFromFetchRequest = try managedContext.fetch(fetchRequest) as! [Category]
      
      result = categoriesFromFetchRequest.count == 0
      
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
   
   return result
}


func resetUserDefaults() {
   UserDefaults.standard.set(false, forKey: "syncUserHasLaunchedPreviously")
   UserDefaults.standard.set(0, forKey: "syncNumTimesUsed")
   UserDefaults.standard.set(false, forKey: "onboardingShown")
}

// ===RESET MANAGED OBJECT CONTEXT===
func resetMOC() {
   
   UserDefaults.standard.set(true, forKey: "syncUserHasLaunchedPreviously")
   UserDefaults.standard.set(0, forKey: "syncNumTimesUsed")
   
   guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
         return
   }
   
   let managedContext =
      appDelegate.persistentContainer.viewContext
   
   let itemFetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
   //   itemFetchRequest.predicate = NSPredicate(format: "originName != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D")
   let categoryFetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Category")
   let listFetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ListOfItems")
   //   listFetchRequest.predicate = NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D")
   let initDateFetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "InitDate")
   
   do {
      let itemFetchReturn = try managedContext.fetch(itemFetchRequest)
      let items = itemFetchReturn as! [Item]
      
      let listFetchReturn = try managedContext.fetch(listFetchRequest)
      let lists = listFetchReturn as! [ListOfItems]
      
      let categoryFetchReturn = try managedContext.fetch(categoryFetchRequest)
      let categories = categoryFetchReturn as! [Category]
      
      let initDateFetchReturn = try managedContext.fetch(initDateFetchRequest)
      let dates = initDateFetchReturn as! [InitDate]
      
      
      for item in items {
         managedContext.delete(item)
      }
      for list in lists {
         managedContext.delete(list)
      }
      for category in categories {
         managedContext.delete(category)
      }
      for date in dates {
         managedContext.delete(date)
      }
      
      
      do {
         try managedContext.save()
         print("deleted successfully")
      } catch let error as NSError {
         print("Could not delete. \(error), \(error.userInfo)")
      }
      
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
}


// ===STARTUP CATEGORY & ITEM STRINGS===
// The startup categories and items below need to have the same number of elements in the array
// (String for categories, [String] for items)
func startupCategoryStrings() -> [String] {
   return ["Fruit", "Vegetables", "Dairy", "Pantry", "Meat", "Snacks", "Skin Care", "Supplements", "Medicine", "Dental", "First aid", "Uncategorised", "In Cart"]
}
func startupItemStrings() -> [[String]] {
   return [
      ["Oranges", "Apples", "Bananas"], // Fruit
      ["Carrots", "Cucumber", "Onion", "Potato"], // Vegetables
      ["Milk", "Cheese", "Eggs"], // Dairy
      ["Coffee", "Bread", "Tea", "Soda", "Cereal", "Beer",  ], // Pantry
      ["Chicken", "Bacon"], // Meat
      ["Chocolate", "Chips"], // Snacks
      ["Sunscreen", "Moisturiser"], // Skin care
      ["Probiotic", "Multivitamin"], // Supplements
      ["Tylenol", "Ibuprofen"], // Medicine
      ["Toothpaste", "Toothbrush", "Mouth guard"], // Dental
      ["Band-aids", "Antiseptic"], // First aid
      [], // Uncategorised
      [] // In Cart
   ]
}

// ===LIST ITEMS AS STRING===
// For copying/sending via text
func listItemsAsString(thisList: ListOfItems) -> String {
   var result = ""
   var categoriesAndItems: [String] = []
   
   guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
         return ""
   }
   let managedContext =
      appDelegate.persistentContainer.viewContext
   
   let categoryFetchRequest: NSFetchRequest<Category> = NSFetchRequest.init(entityName: "Category")
   categoryFetchRequest.predicate = NSPredicate(format: "NOT name IN %@", ["Uncategorised", "In Cart"])
   categoryFetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))]
   
   let uncategorisedRequest: NSFetchRequest<Category> = NSFetchRequest.init(entityName: "Category")
   uncategorisedRequest.predicate = NSPredicate(format: "name == %@", "Uncategorised")
   
   //   let inCartRequest: NSFetchRequest<Category> = NSFetchRequest.init(entityName: "Category")
   //   inCartRequest.predicate = NSPredicate(format: "name == %@", "In Cart")
   
   do {
      // Get categories
      let categories = try managedContext.fetch(categoryFetchRequest)
      let uncategorisedReturn = try managedContext.fetch(uncategorisedRequest)
      //      let inCartReturn = try managedContext.fetch(inCartRequest)
      
      // Determine which categories have items in them
      // Add category name to categoriesAndItems if it has items
      if categories != [] {
         
         for category in categories {
            
            var categoryItemNames: [String] = []
            var thisCategoryHasItems: Bool {
               var numItems: Int = 0
               for item in category.itemsInCategoryArray {
                  if item.addedToAList == true && thisList.itemArray.contains(item) && item.markedOff == false {
                     numItems += 1
                     categoryItemNames.append(item.wrappedName)
                  }
               }
               return numItems > 0
            }
            if thisCategoryHasItems {
               categoriesAndItems.append(category.wrappedName.uppercased())
               for itemName in categoryItemNames {
                  categoriesAndItems.append("☐ " + itemName)
               }
               categoriesAndItems.append("")
            }
         }
      }
      
      // Determine if uncategorised or inBasket have categories
      // If so, add the capitalised wrappedName to categoriesAndItems
      if uncategorisedReturn != [] {
         let uncategorised = uncategorisedReturn[0]
         
         var uncategorisedItemNames: [String] = []
         var uncategorisedHasItems: Bool {
            var numItemsUncategorised: Int = 0
            for item in uncategorised.itemsInCategoryArray {
               if item.addedToAList == true && thisList.itemArray.contains(item) && item.markedOff == false {
                  numItemsUncategorised += 1
                  uncategorisedItemNames.append(item.wrappedName)
               }
            }
            return numItemsUncategorised > 0
         }
         if uncategorisedHasItems {
            categoriesAndItems.append(uncategorised.wrappedName.uppercased())
            for itemName in uncategorisedItemNames {
               categoriesAndItems.append("☐ " + itemName)
            }
            categoriesAndItems.append("")
         }
      }
      
      
      var inCartItemNames: [String] = []
      var inCartHasItems: Bool {
         var numItemsInCart: Int = 0
         for item in thisList.itemArray {
            if item.addedToAList == true && item.markedOff == true {
               numItemsInCart += 1
               inCartItemNames.append(item.wrappedName)
            }
         }
         return numItemsInCart > 0
      }
      if inCartHasItems {
         categoriesAndItems.append("IN CART")
         for itemName in inCartItemNames {
            categoriesAndItems.append("☑ " + itemName)
         }
         categoriesAndItems.append("")
      }
      
      // Add all capitalised category names + item names to result
      for categoryItems in categoriesAndItems {
         result.append(categoryItems + "\n")
      }
      
   } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
   }
   
   
   return result
}


// ===HAPTIC FEEDBACK (single)===
func hapticFeedback(enabled: Bool) {
   if enabled {
      let generator = UIImpactFeedbackGenerator(style: .light)
      generator.impactOccurred()
   }
}


// ===HAPTIC FEEDBACK (success)===
func successHapticFeedback (enabled: Bool) {
   if enabled {
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.success)
   }
}
