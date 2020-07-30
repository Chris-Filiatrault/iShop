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
   @State var navBarColor: UIColor = UIColor(red: 0/255, green: 10/255, blue: 30/255, alpha: 1)
   @State var onboardingShown = UserDefaults.standard.object(forKey: "onboardingShown") as? Bool ?? nil
   @EnvironmentObject var globalVariables: GlobalVariableClass
   let messageComposeDelegate = MessageComposerDelegate()
   var body: some View {
      VStack {
         if onboardingShown != true {
            OnboardingView(onboardingShown: $onboardingShown, navBarColor: $navBarColor, navBarFont: $navBarFont)
         }
         else {
            Home(navBarFont: $navBarFont, navBarColor: $navBarColor, startUp: self)
         }
         
         
//         Button(action: {
//            self.presentMessageCompose()
//         }) {
//            Text("Button")
//         }
         
         
         
      }
      
   } // End of body
   
   
   // ========================================
   // ========== APP INITIALISATION ==========
   // ========================================
   
   init() {
      
      // To remove all separators in list:
      // UITableView.appearance().separatorStyle = .none
      
      // To remove only extra separators below the list:
      UITableView.appearance().tableFooterView = UIView()
      
      // Remove UITableView background, so it can be programmed using SwiftUI
      UITableView.appearance().backgroundColor = .clear
      
      if userDefaultsManager.useCategories != true && userDefaultsManager.useCategories != false {
         userDefaultsManager.useCategories = true
      }
      
      if isFirstTimeLaunch() {
         print("Is first time launch.")
         
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
         
         let startupCategories = startupCategoryStrings()
         let startupItems = startupItemStrings()
         
         
         if userHasNoLists() {
            print("Creating startup list")
            // Groceries list
            let groceriesList = ListOfItems(entity: listEntity, insertInto: managedContext)
            groceriesList.name = "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D"
            groceriesList.id = UUID()
            groceriesList.dateAdded = newInitDate.initDate
            
            
            if userHasNoCategories() {
               
               print("Creating startup items and categories")
               // Grocery categories & items
               var groceryIndex: Int = 0
               
               for categoryName in startupCategories {
                  let newCategory = Category(entity: categoryEntity, insertInto: managedContext)
                  newCategory.name = categoryName
                  newCategory.id = UUID()
                  newCategory.dateAdded = newInitDate.initDate
                  
                  for itemName in startupItems[groceryIndex] {
                     
                     let item = Item(entity: itemEntity, insertInto: managedContext)
                     item.name = itemName
                     item.id = UUID()
                     item.dateAdded = newInitDate.initDate
                     item.addedToAList = false
                     item.markedOff = false
                     item.quantity = 1
                     item.origin = groceriesList
                     groceriesList.addToItems(item)
                     newCategory.addToItemsInCategory(item)
                  }
                  groceryIndex += 1
               }
            }
         }
         
         
         do {
            try managedContext.save()
         } catch let error as NSError {
            print("Could not save items. \(error), \(error.userInfo)")
         }
      }
   } // End of init function
}


// presentMessageCompose needs to be called from the top of the view hierarchy (StartUp), though the button for calling it is inside NavBarItems. Thus StartUp() passes self into Home, which is passed into ItemList, and then into NavBarItems, which calls presentMessageCompose
extension StartUp {

   class MessageComposerDelegate: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            // Customize here
            controller.dismiss(animated: true)
        }
    }
    // Present a message compose view controller modally in UIKit environment
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

