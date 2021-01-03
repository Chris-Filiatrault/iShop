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
   
   @GestureState private var dragOffset = CGSize.zero
   
   @Environment(\.presentationMode) var presentationMode
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @Environment(\.editMode)  var editMode
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   @State var showListOptions: Bool = false
   @State var showRenameList: Bool = false
   var useCategories = UserDefaults.standard.bool(forKey: "syncUseCategories")
   var itemsFetchRequest: FetchRequest<Item>
   var categoriesFetchRequest: FetchRequest<Category>
   var thisList: ListOfItems
   let uncategorised = uncategorisedCategory()
   let inCart = inCartCategory()
   var startUp: StartUp
   
   static var focusTextfield: Bool = true
   static var itemInTextfield: String = ""
   static var itemInTextfieldBinding = Binding<String>(get: { itemInTextfield }, set: { itemInTextfield = $0 } )
   
   init(listFromHomePage: ListOfItems, startUpPassedIn: StartUp) {
      
      thisList = listFromHomePage
      startUp = startUpPassedIn
      let originPredicate = NSPredicate(format: "origin = %@", thisList)
      let inListPredicate = NSPredicate(format: "addedToAList == true")
      let markedOffPredicate = NSPredicate(format: "markedOff == false")
      let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, inListPredicate, markedOffPredicate])
      
      itemsFetchRequest = FetchRequest<Item>(entity: Item.entity(), sortDescriptors: [
         UserDefaults.standard.string(forKey: "syncSortItemsBy") == "Alphabetical" ?
            NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))) :
            NSSortDescriptor(key: "position", ascending: true)
      ], predicate: compoundPredicate)
      
      
      categoriesFetchRequest = FetchRequest<Category>(entity: Category.entity(), sortDescriptors: [
         NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
         ], predicate: NSPredicate(format: "NOT name IN %@", ["Uncategorised", "In Cart"])
      )
   }
   
   var body: some View {
      
      VStack(spacing: 0) {
            
            // ===Add Item Textfield===
            CustomTextField("Add item", text: $globalVariables.itemInTextfield, focusTextfieldCursor: false, onCommit: {
                        if self.globalVariables.itemInTextfield != "" {
                           addNewItem(itemName: self.$globalVariables.itemInTextfield, listOrigin: self.thisList)
                           hapticFeedback()
                           self.globalVariables.itemInTextfield = ""
                        }
                        else if self.globalVariables.itemInTextfield == "" {
                           withAnimation {
                              self.globalVariables.catalogueShown = false
                              UIApplication.shared.endEditing()
                           }
                        }
                        
                     }, onBeginEditing: {
                        self.globalVariables.catalogueShown = true
                        self.editMode?.wrappedValue = .inactive
                     })
                     .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing:
                        globalVariables.itemInTextfield == "" ? 15 : 0
                     ))
                     .padding(.top, 10)
                     .modifier(ClearButton())
                     .environmentObject(globalVariables)
         
         
         VStack {
         // ===List of items WITH categories===
         if globalVariables.catalogueShown == false && useCategories == true {
            
            List {
               ForEach(categoriesFetchRequest.wrappedValue) { category in
                  ItemCategory(listFromHomePage: self.thisList, categoryFromItemList: category)
               }
               
               // Can't use if let ... here to unwrap uncategorised, so do a quick check to see if it's nil. Same for inCart. If it is nil, then the category won't be shown (bad, but better than a crash).
               if uncategorised != nil {
                  ItemCategory(listFromHomePage: thisList, categoryFromItemList: uncategorised!)
               }
               
               if inCart != nil {
               InCart(listFromHomePage: thisList, categoryFromItemList: inCart!)
               }
               
            }.padding(.bottom)

         }
         
         // ===List of items WITHOUT categories===
         else if globalVariables.catalogueShown == false && useCategories == false {
            
            List {
               ForEach(itemsFetchRequest.wrappedValue) { item in
                  ItemRow(thisList: self.thisList, thisItem: item, markedOff: item.markedOff, position: item.position)
               }
               .onDelete(perform: removeSwipedItem)
               .onMove(perform: moveItem)
               
               if inCart != nil {
               InCart(listFromHomePage: self.thisList, categoryFromItemList: self.inCart!)
               }
               
            }.padding(.bottom)
               .sheet(isPresented: self.$showRenameList){
                  RenameList(thisList: self.thisList, showingRenameListBinding: self.$showRenameList)
                     .environmentObject(self.globalVariables)
            }
         }

         // ===Catalogue===
         else if globalVariables.catalogueShown == true {
            Catalogue(passedInList: thisList, filter: globalVariables.itemInTextfield)
            }
         }

      } // End of VStack
         .sheet(isPresented: self.$showRenameList){
            RenameList(thisList: self.thisList, showingRenameListBinding: self.$showRenameList)
               .environmentObject(self.globalVariables)
      }
      .navigationBarColor(backgroundColor: globalVariables.navBarColor, fontColor: UIColor.white)
      .background(Color("listBackground").edgesIgnoringSafeArea(.all))
      .onDisappear() {
         self.globalVariables.itemInTextfield = ""
      }
      .onAppear() {
         self.globalVariables.catalogueShown = false
      }
         
         // ===Navigation bar===
         .navigationBarTitle(globalVariables.catalogueShown ? "Item History" : thisList.wrappedName)
         .navigationBarBackButtonHidden(true)
         .navigationBarItems(
            leading:
            NavBarLeading(presentationMode: self.presentationMode, thisList: self.thisList, startUp: self.startUp, showListOptions: self.$showListOptions, showRenameList: self.$showRenameList),
            trailing:
            HStack {
            if globalVariables.catalogueShown == false && UserDefaults.standard.string(forKey: "syncSortItemsBy") == "Manual" && UserDefaultsManager().useCategories == false {
               EditButton()
                  .foregroundColor(Color("navBarFont"))
                  .padding()
               
               
               
               
               
               
               
               
               
               
               
               
               
               
               
            }
               NavBarTrailing(thisList: self.thisList, startUp: self.startUp, showListOptions: self.$showListOptions, showRenameList: self.$showRenameList, presentationMode: self.presentationMode)
            }
      )
      
   }// End of body
   
   
   // REMOVE (swiped) ITEM
   func removeSwipedItem(indices: IndexSet) {
      
      guard let appDelegate =
         UIApplication.shared.delegate as? AppDelegate else {
            return
      }
      let managedContext =
         appDelegate.persistentContainer.viewContext
      
      let originPredicate = NSPredicate(format: "origin = %@", thisList)
      let addedToAListPredicate = NSPredicate(format: "addedToAList == true")
      let markedOffPredicate = NSPredicate(format: "markedOff == false")
      let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, addedToAListPredicate, markedOffPredicate])
      
      let fetchRequest:NSFetchRequest<Item> = NSFetchRequest.init(entityName: "Item")
      fetchRequest.predicate = compoundPredicate
      
      if UserDefaults.standard.string(forKey: "syncSortItemsBy") == "Manual" {
         fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Item.position, ascending: true)
         ]
         print("Fetch by position")
      }
      else if UserDefaults.standard.string(forKey: "syncSortItemsBy") == "Alphabetical" {
         fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
         ]
         print("Fetch by name")
      }
      
      do {
         let items = try managedContext.fetch(fetchRequest)
         
         for index in indices {
            
            let swipedItem = items[index] // find item
            
            for item in items {
               if item.position > swipedItem.position {
                  item.position -= 1
               }
            }
            
            swipedItem.addedToAList = false
            swipedItem.markedOff = false
            swipedItem.quantity = 1
            swipedItem.position = 0
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
   
   
   // ===MOVE ITEM===
   func moveItem(IndexSet: IndexSet, destination: Int) {
      
      guard let appDelegate =
         UIApplication.shared.delegate as? AppDelegate else {
            return
      }
      
      let managedContext =
         appDelegate.persistentContainer.viewContext
      
      let originPredicate = NSPredicate(format: "origin = %@", thisList)
      let addedToAListPredicate = NSPredicate(format: "addedToAList == true")
      let markedOffPredicate = NSPredicate(format: "markedOff == false")
      let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, addedToAListPredicate, markedOffPredicate])
      
      let fetchRequest:NSFetchRequest<Item> = NSFetchRequest.init(entityName: "Item")
      fetchRequest.predicate = compoundPredicate
      fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.position, ascending: true)]
      
      do {
         let items = try managedContext.fetch(fetchRequest)
         
         let firstIndex = IndexSet.min() ?? 0
         let lastIndex = IndexSet.max() ?? 0
         
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

