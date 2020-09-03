//
//  Catalogue.swift
//  iShop
//
//  Created by Chris Filiatrault on 24/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import CoreData

struct Catalogue: View {
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   
   var thisList: ListOfItems
   var fetchRequest: FetchRequest<Item>
   var filterVar: String
   @State var showDeleteItemInfoAlert: Bool = false
   
   init(passedInList: ListOfItems, filter: String) {
      
      thisList = passedInList
      filterVar = filter
      
      fetchRequest = FetchRequest<Item>(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
      ], predicate: NSPredicate(format: "origin = %@", thisList))
      
      if filter != "" {
         let originPredicate = NSPredicate(format: "origin = %@", thisList)
         let containsPredicate = NSPredicate(format: "name CONTAINS[c] %@", filter)
         let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, containsPredicate])
         
         fetchRequest = FetchRequest<Item>(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
         ], predicate: compoundPredicate)
      }
   }
   
   var body: some View {
      VStack {
         
         // List of filtered items
         List {
            ForEach(fetchRequest.wrappedValue) { item in
               CatalogueRow(thisList: self.thisList, thisItem: item)
            }
            .onDelete(perform: deleteSwipedCatalogueItem)
            .listRowBackground(Color(.white))
         }
         .background(Color("listBackground").edgesIgnoringSafeArea(.all))
         
         
         // Add button
         VStack {
            if fetchRequest.wrappedValue.count == 0 {
               Button(action: {
//                  UIApplication.shared.endEditing()
                  if self.globalVariables.itemInTextfield != "" {
                     addNewItem(itemName: self.$globalVariables.itemInTextfield, listOrigin: self.thisList)
                     self.globalVariables.itemInTextfield = ""
                     hapticFeedback()
                  }
                  self.globalVariables.itemInTextfield = ""
               }) {
                  Text("Add")
                     .bold()
                     .modifier(MainBlueButton())
                     .transition(.scale)
                     .padding(.horizontal, 40)
                     .padding(.vertical, 7)
               }
               }
            }

      }
         
      .alert(isPresented: $showDeleteItemInfoAlert) {
         Alert(title: Text("Information"),
               message:
            UserDefaults.standard.integer(forKey: "syncNumTimesUsed") == 1 ?
               Text("Tap an item to add it, or type in a new item.") :
            Text("Delete items by swiping left."),
               dismissButton: .default(Text("Done")))
      }
      .onAppear {
         
         // If first use, present info alert advising user they can tap to add items
         if UserDefaults.standard.integer(forKey: "syncNumTimesUsed") == 1 &&
            UserDefaults.standard.bool(forKey: "syncTapToAddAlertShown") != true {
            self.showDeleteItemInfoAlert.toggle()
            UserDefaults.standard.set(true, forKey: "syncTapToAddAlertShown")
         }
         
         // If app has been used > 5 times, present info alert advising user they can swipe left to delete items
         if UserDefaults.standard.integer(forKey: "syncNumTimesUsed") > 5 &&
            UserDefaults.standard.bool(forKey: "syncSwipeToDeleteAlertShown") != true {
         self.showDeleteItemInfoAlert.toggle()
            UserDefaults.standard.set(true, forKey: "syncSwipeToDeleteAlertShown")
         }
      }
      
         
   } // End of body
   
   
   // DELETE (swiped) CATALOGUE ITEM
   func deleteSwipedCatalogueItem(at offsets: IndexSet) {
      
      guard let appDelegate =
         UIApplication.shared.delegate as? AppDelegate else {
            return
      }
      
      let managedContext =
         appDelegate.persistentContainer.viewContext
      
      let allItemsFetchRequest:NSFetchRequest<Item> = NSFetchRequest.init(entityName: "Item")
      
      do {
         let items = try managedContext.fetch(allItemsFetchRequest)
         for offset in offsets {
            
            // get item to be deleted
            let thisItem = fetchRequest.wrappedValue[offset]
            
            // Find all lists where this item has been added
            // For all items in those lists, if the item position is larger than this item, position -= 1
            
            // delete that item and all items with the same name
            for item in items {
               if item.wrappedName == thisItem.wrappedName {
                  managedContext.delete(item)
               }
            }
            self.globalVariables.itemInTextfield = ""
         }
         
         do {
            try managedContext.save()
            print("Item successfully deleted")
         } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
         }
         
      } catch let error as NSError {
         print("Could not fetch. \(error), \(error.userInfo)")
      }
      
      
   } // End of function
   
   
}

