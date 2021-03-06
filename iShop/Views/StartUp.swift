//
//  Home.swift
//  iShop
//
//  Created by Chris Filiatrault on 2/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import MessageUI
import SwiftUI
import CoreData

struct StartUp: View {
   
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   @State var navBarFont: UIColor = UIColor.white
   @State var navBarColor: UIColor = UIColor(red: 30/255, green: 80/255, blue: 190/255, alpha: 1)
   @State var onboardingShown = UserDefaults.standard.bool(forKey: "onboardingShown")
   @EnvironmentObject var globalVariables: GlobalVariableClass
   let messageComposeDelegate = MessageComposerDelegate()
   
   var body: some View {
//         Home(navBarFont: $navBarFont, navBarColor: $navBarColor, startUp: self)
         
      VStack {
         if onboardingShown != true {
            OnboardingViewHome(onboardingShown: $onboardingShown, navBarColor: $navBarColor, navBarFont: $navBarFont)
         }
         else {
            Home(navBarFont: $navBarFont, navBarColor: $navBarColor, startUp: self)
         }
      }
      
   }
   
   
   // ========================================
   // ========== APP INITIALISATION ==========
   // ========================================
   
   init() {
      
      // Removes extra separators below the list:
      UITableView.appearance().tableFooterView = UIView()
      
      // Remove UITableView background, so the background color can be programmed using SwiftUI
      UITableView.appearance().backgroundColor = .clear
      
      if UIDevice.current.userInterfaceIdiom == .mac {
//         UINavigationBar.appearance().backgroundColor = self.navBarColor
      }
      
      
      // Run first time code after a 3 second delay, to (hopefully) let UserDefaults sync
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
         print("Running delayed code")
         
         
         /// Create initial items, categories, lists and set user defaults accordingly, if it is the first time launch.
         if isFirstTimeLaunch() {
            print("Is first time launch")
            
            UserDefaultsManager().useCategories = true
            UserDefaultsManager().keepScreenOn = true
            
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
               return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let itemEntity = NSEntityDescription.entity(forEntityName: "Item", in:
               managedContext)!
            let listEntity = NSEntityDescription.entity(forEntityName: "ListOfItems", in:
               managedContext)!
            let categoryEntity = NSEntityDescription.entity(forEntityName: "Category", in:
               managedContext)!
            let initDateEntity = NSEntityDescription.entity(forEntityName: "InitDate", in: managedContext)!
            
            let newInitDate = InitDate(entity: initDateEntity, insertInto: managedContext)
            newInitDate.initDate = Date()
            
            let startupCategoryNames = startupCategoryStrings()
            let startupItemNames = startupItemStrings()
            
            if userHasNoLists() {
               
               print("Creating default list")
               // Groceries list
               let defaultList = ListOfItems(entity: listEntity, insertInto: managedContext)
               defaultList.name = "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D"
               defaultList.id = UUID()
               defaultList.dateAdded = newInitDate.initDate
               
               
               if userHasNoCategories() {
                  
                  print("Creating startup items and categories")
                  // Grocery categories & items
                  var groceryIndex: Int = 0
                  var categoryIndex: Int32 = 0
                  
                  for categoryName in startupCategoryNames {
                     let newCategory = Category(entity: categoryEntity, insertInto: managedContext)
                     newCategory.name = categoryName
                     newCategory.id = UUID()
                     newCategory.dateAdded = newInitDate.initDate
                     if !["In Cart", "Uncategorised"].contains(categoryName) {
                     newCategory.position = categoryIndex
                     categoryIndex += 1
                     } else {
                        newCategory.position = 0
                     }
                     
                     for itemName in startupItemNames[groceryIndex] {
                        
                        let item = Item(entity: itemEntity, insertInto: managedContext)
                        item.name = itemName
                        item.id = UUID()
                        item.dateAdded = newInitDate.initDate
                        item.addedToAList = false
                        item.markedOff = false
                        item.quantity = 1
                        item.origin = defaultList
                        item.categoryOrigin = newCategory
                        item.categoryOriginName = newCategory.wrappedName
                        item.position = 0
                        defaultList.addToItems(item)
                        newCategory.addToItemsInCategory(item)
                     }
                     groceryIndex += 1
                  }
               }
            }
            
            print("Creating Groceries list")
            addList(listName: "Groceries")
            
            do {
               try managedContext.save()
            } catch let error as NSError {
               print("Could not save items. \(error), \(error.userInfo)")
            }
            
         }
      }
      
   } // End of init function
}


extension StartUp {
   
   class MessageComposerDelegate: NSObject, MFMessageComposeViewControllerDelegate {
      func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
         // Customize here
         controller.dismiss(animated: true)
      }
   }
   
   /// `presentMessageCompose()` needs to be called from the top of the view hierarchy (`StartUp`), though the button for calling it is inside `NavBarList`. Thus this instance of `StartUp()` is passed down the view hierarchy to `NavBarList`, which then calls `presentMessageCompose`
   func presentMessageCompose(messageBody: String) {
      guard MFMessageComposeViewController.canSendText() else {
         return
      }
      let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
      let composeVC = MFMessageComposeViewController()
      composeVC.messageComposeDelegate = messageComposeDelegate
      composeVC.body = messageBody
      vc?.present(composeVC, animated: true)
   }
   
}

