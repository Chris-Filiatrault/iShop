//
//  ItemList.swift
//  iShop
//
//  Created by Chris Filiatrault on 13/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import CoreData

struct ItemList: View {
   @Environment(\.presentationMode) var presentationMode
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   @State var showMoreOptions: Bool = false
   @State var showListSettings: Bool = false
   var useCategories = UserDefaults.standard.bool(forKey: "syncUseCategories")
   var itemsFetchRequest: FetchRequest<Item>
   var categoriesFetchRequest: FetchRequest<Category>
   var thisList: ListOfItems
   let uncategorised = uncategorisedCategory()
   let inCart = inCartCategory()
   var startUp: StartUp
   
   init(listFromHomePage: ListOfItems, startUpPassedIn: StartUp) {
      
      thisList = listFromHomePage
      startUp = startUpPassedIn
      let originPredicate = NSPredicate(format: "origin = %@", thisList)
      let inListPredicate = NSPredicate(format: "addedToAList == true")
      let markedOffPredicate = NSPredicate(format: "markedOff == false")
      let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, inListPredicate, markedOffPredicate])
      
      if UserDefaults.standard.string(forKey: "syncSortListBy") == "Alphabetical" {
         itemsFetchRequest = FetchRequest<Item>(entity: Item.entity(), sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
            ], predicate: compoundPredicate)
      } else {
         itemsFetchRequest = FetchRequest<Item>(entity: Item.entity(), sortDescriptors: [
                  NSSortDescriptor(key: "position", ascending: true
               )], predicate: compoundPredicate)
      }

      categoriesFetchRequest = FetchRequest<Category>(entity: Category.entity(), sortDescriptors: [
         NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
      ], predicate: NSPredicate(format: "NOT name IN %@", ["Uncategorised", "In Cart"])
      )
   }
   
   var body: some View {
      
      VStack(spacing: 0) {
         // ===Enter item textfield===
         TextField("Add item", text: self.$globalVariables.itemInTextfield, onEditingChanged: { changed in
            self.globalVariables.catalogueShown = true
         }, onCommit: {
            if self.globalVariables.itemInTextfield != "" {
               addNewItem(itemName: self.$globalVariables.itemInTextfield, listOrigin: self.thisList)
               self.globalVariables.itemInTextfield = ""
            }
            self.globalVariables.itemInTextfield = ""
         })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .background(Color(.white))
            .padding(15)
            .padding(.top, 10)
            .disableAutocorrection(userDefaultsManager.disableAutoCorrect)
            
         
//          ===List of items WITH categories===
         if globalVariables.catalogueShown == false && useCategories == true {
            
            List {
               ForEach(categoriesFetchRequest.wrappedValue, id: \.self) { category in
                  ItemCategory(listFromHomePage: self.thisList, categoryFromItemList: category)
               }
               ItemCategory(listFromHomePage: self.thisList, categoryFromItemList: uncategorised!)
               
               InCart(listFromHomePage: self.thisList, categoryFromItemList: self.inCart!)
               
            }.padding(.bottom)
            .sheet(isPresented: self.$showListSettings){
               RenameList(thisList: self.thisList, newListName: self.thisList.wrappedName, showingRenameListBinding: self.$showListSettings)
                  .environmentObject(self.globalVariables)
            }
         }
            
         
         // ===List of items WITHOUT categories===
         if globalVariables.catalogueShown == false && useCategories == false {
            
            List {
               ForEach(itemsFetchRequest.wrappedValue, id: \.self) { item in
                  ItemRow(thisList: self.thisList, thisItem: item, markedOff: item.markedOff, position: item.position)
               }
               .onMove(perform: moveItem)
               
               InCart(listFromHomePage: self.thisList, categoryFromItemList: self.inCart!)
               
            }.padding(.bottom)
            .sheet(isPresented: self.$showListSettings){
               RenameList(thisList: self.thisList, newListName: self.thisList.wrappedName, showingRenameListBinding: self.$showListSettings)
                  .environmentObject(self.globalVariables)
            }
         }
         
         // ===Catalogue===
         else if globalVariables.catalogueShown == true {
            Catalogue(passedInList: thisList, filter: globalVariables.itemInTextfield)
         }
      }
      .background(Color("listBackground").edgesIgnoringSafeArea(.all))
      .modifier(AdaptsToSoftwareKeyboard())
      .onDisappear() {
         self.globalVariables.itemInTextfield = ""
      }
      .onAppear() {
         self.globalVariables.catalogueShown = false
      }
      
      // ===Navigation bar===
      .navigationBarTitle(globalVariables.catalogueShown ? "Item History" : thisList.wrappedName)
      .navigationBarItems(trailing:
         NavBarItems(showMoreOptions: $showMoreOptions, showRenameList: $showListSettings, thisList: thisList, startUp: startUp, presentationModeNav: self.presentationMode)
      )
      
   }// End of body
   
   func moveItem(IndexSet: IndexSet, destination: Int) {

      guard let appDelegate =
         UIApplication.shared.delegate as? AppDelegate else {
            return
      }

      let managedContext =
         appDelegate.persistentContainer.viewContext

      // Need an origin predicate!
      let originPredicate = NSPredicate(format: "origin = %@", thisList)
      let addedToAListPredicate = NSPredicate(format: "addedToAList == true")
      let markedOffPredicate = NSPredicate(format: "markedOff == false")
      let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, addedToAListPredicate, markedOffPredicate])
      
      
      let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
      fetchRequest.predicate = compoundPredicate
      fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.position, ascending: true)]
      

      do {
         let items = try managedContext.fetch(fetchRequest) as! [Item]

         for item in items {
            print(item.wrappedName)
         }
         
         let firstIndex = IndexSet.min()!
         let lastIndex = IndexSet.max()!

         let firstRowToReorder = (firstIndex < destination) ? firstIndex : destination
         let lastRowToReorder = (lastIndex > (destination-1)) ? lastIndex : (destination-1)

         if firstRowToReorder != lastRowToReorder && items != [] {

              var newOrder = firstRowToReorder
              if newOrder < firstIndex {
                  // Moving dragged items up, so re-order dragged items first

               // Re-order dragged items
               for index in IndexSet {
                      items[index].setValue(newOrder, forKey: "position")
                      newOrder = newOrder + 1
                  }

                  // Re-order non-dragged items
                  for rowToMove in firstRowToReorder..<lastRowToReorder {
                     if !IndexSet.contains(rowToMove) {
                          items[rowToMove].setValue(newOrder, forKey: "position")
                          newOrder = newOrder + 1
                      }
                  }
              } else if items != [] {
                  // Moving dragged items down, so re-order dragged items last

                  // Re-order non-dragged items
                  for rowToMove in firstRowToReorder...lastRowToReorder {
                     if !IndexSet.contains(rowToMove) {
                          items[rowToMove].setValue(newOrder, forKey: "position")
                          newOrder = newOrder + 1
                      }
                  }

               // Re-order dragged items
               for index in IndexSet {
                      items[index].setValue(newOrder, forKey: "position")
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
}



