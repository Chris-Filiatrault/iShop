//
//  AppDelegate.swift
//  iShop
//
//  Created by Chris Filiatrault on 29/4/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
   
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      // Override point for customization after application launch.
      return true
   }
   
   // MARK: UISceneSession Lifecycle
   
   func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
      print("New scene session created")
      // Called when a new scene session is being created.
      // Use this method to select a configuration to create the new scene with.
      return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
   }
   
   func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
      
      print("Scene discarded")
      // Called when the user discards a scene session.
      // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
      // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
   }
   
   // MARK: - Core Data stack
   
   lazy var persistentContainer: NSPersistentCloudKitContainer = {
      /*
       The persistent container for the application. This implementation
       creates and returns a container, having loaded the store for the
       application to it. This property is optional since there are legitimate
       error conditions that could cause the creation of the store to fail.
       */
      let container = NSPersistentCloudKitContainer(name: "iShop")
      
      // Use the persistent containers ability to check for changes, so we can pull/push changes when the order of items is changed
      guard let description = container.persistentStoreDescriptions.first else {
         fatalError("No descriptions found")
      }
      description.setOption(true as NSObject, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
      
      
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
         if let error = error as NSError? {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            
            /*
             Typical reasons for an error here include:
             * The parent directory does not exist, cannot be created, or disallows writing.
             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             * The device is out of space.
             * The store could not be migrated to the current model version.
             Check the error message to determine what the actual problem was.
             */
            fatalError("Unresolved error \(error), \(error.userInfo)")
         }
      })
      
      // Allow conflicts to be merged
      container.viewContext.automaticallyMergesChangesFromParent = true
      
      // Make the iCloud store the source of truth
//      container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
      
      // Make in memory values the source of truth
      container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
      
      
      NotificationCenter.default.addObserver(self, selector: #selector(self.processUpdate), name: .NSPersistentStoreRemoteChange, object: nil)
      
      return container
   }()
   
   // MARK: - Core Data Saving support
   func saveContext () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
         do {
            try context.save()
         } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
         }
      }
   }
   
   
   // Function for performing actions as updates are processed
   @objc
   func processUpdate(notification: NSNotification) {
      operationQueue.addOperation {
         
         let managedContext = self.persistentContainer.viewContext
         managedContext.performAndWait {
            
            // Create initial lists and items, if the user doesn't have any saved on their phone
            let lists: [ListOfItems]
            do {
               try lists = managedContext.fetch(ListOfItems.getListsFetchRequest())
               
               var numLists: Int = 0
               for _ in lists {
                  numLists += 1
               }
               print("numlists: \(numLists)")
               
               if numLists == 0 {
                  
                  print("Creating new list, items and categories")
                  
                  let itemEntity = NSEntityDescription.entity(forEntityName: "Item", in:
                     managedContext)!
                  
                  let listEntity = NSEntityDescription.entity(forEntityName: "ListOfItems", in:
                     managedContext)!
                  
                  let categoryEntity = NSEntityDescription.entity(forEntityName: "Category", in:
                     managedContext)!
                  
                  
                  // The startup categories and items below need to have the same number of elements in the array
                  // String for categories, [String] for items
                  let startupCategories: [String] = ["Fruit", "Vegetables", "Dairy", "Pantry", "Meat", "Snacks", "Skin Care", "Supplements", "Medicine", "Dental", "First aid"]
                  
                  let startupItems: [[String]] = [
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
                     ["Band-aids", "Antiseptic"] // First aid
                  ]
                  
                  
                  // Groceries list
                  let groceriesList = ListOfItems(entity: listEntity, insertInto: managedContext)
                  groceriesList.name = "Groceries"
                  groceriesList.id = UUID()
                  groceriesList.dateAdded = Date()
                  
                  
                  // Grocery categories & items
                  var groceryIndex: Int = 0
                  for categoryName in startupCategories {
                     let newGroceryCategory = Category(entity: categoryEntity, insertInto: managedContext)
                     newGroceryCategory.name = categoryName
                     newGroceryCategory.id = UUID()
                     newGroceryCategory.dateAdded = Date()
                     
                     for itemName in startupItems[groceryIndex] {
                        
                        let item = Item(entity: itemEntity, insertInto: managedContext)
                        item.name = itemName
                        item.id = UUID()
                        item.dateAdded = Date()
                        item.addedToAList = false
                        item.markedOff = false
                        item.quantity = 1
                        item.origin = groceriesList
                        groceriesList.addToItems(item)
                        newGroceryCategory.addToItemsInCategory(item)
                     }
                     groceryIndex += 1
                  }
                  
                  
                  // In Basket category
                  let inBasketCategory = Category(entity: categoryEntity, insertInto: managedContext)
                  inBasketCategory.name = "In Basket"
                  inBasketCategory.id = UUID()
                  inBasketCategory.dateAdded = Date()
                  inBasketCategory.defaultCategory = true
                  
                  // Uncategorised category
                  let uncategorisedCategory = Category(entity: categoryEntity, insertInto: managedContext)
                  uncategorisedCategory.name = "Uncategorised"
                  uncategorisedCategory.id = UUID()
                  uncategorisedCategory.dateAdded = Date()
                  uncategorisedCategory.defaultCategory = true
                  
                  do {
                     try managedContext.save()
                  } catch let error as NSError {
                     print("Could not save startup list, items and categories.. \(error), \(error.userInfo)")
                  }
                  
                  
               }
               
               
            } catch {
               let nserror = error as NSError
               fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }


            
            
         }
      }
   }
   
   
   // Operation cue, for performing changes
   // Only allow 1 operation at a time, to avoid syncing issues
   lazy var operationQueue: OperationQueue = {
      var queue = OperationQueue()
      queue.maxConcurrentOperationCount = 1
      return queue
   }()
   
}

