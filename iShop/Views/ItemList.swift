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
   
   @State var showActionSheet: Bool = false
   
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
   
   init(listFromHomePage: ListOfItems, startUpPassedIn: StartUp) {
      
      thisList = listFromHomePage
      startUp = startUpPassedIn
      let originPredicate = NSPredicate(format: "origin = %@", thisList)
      let inListPredicate = NSPredicate(format: "addedToAList == true")
      let markedOffPredicate = NSPredicate(format: "markedOff == false")
      let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, inListPredicate, markedOffPredicate])
      
      itemsFetchRequest = FetchRequest<Item>(entity: Item.entity(), sortDescriptors: [
         UserDefaults.standard.string(forKey: "syncSortItemsBy") == "Alphabetical" ?
            NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:))) :
            NSSortDescriptor(key: "position", ascending: true)
      ], predicate: compoundPredicate)
      
      
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
               self.editMode?.wrappedValue = .inactive
            }, onCommit: {
               if self.globalVariables.itemInTextfield != "" {
                  addNewItem(itemName: self.$globalVariables.itemInTextfield, listOrigin: self.thisList)
                  self.globalVariables.itemInTextfield = ""
               }
               self.globalVariables.itemInTextfield = ""
            })
               .textFieldStyle(RoundedBorderTextFieldStyle())
               .background(Color(.white))
               .disableAutocorrection(userDefaultsManager.disableAutoCorrect)
               .modifier(ClearButton())
               .padding(.top, 10)
               .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing:
                  globalVariables.itemInTextfield == "" ? 15 : 0
               ))
         
         // ===List of items WITH categories===
         if globalVariables.catalogueShown == false && useCategories == true {
            
            List {
               ForEach(categoriesFetchRequest.wrappedValue) { category in
                  ItemCategory(listFromHomePage: self.thisList, categoryFromItemList: category)
               }
               ItemCategory(listFromHomePage: self.thisList, categoryFromItemList: uncategorised!)
               
               InCart(listFromHomePage: self.thisList, categoryFromItemList: self.inCart!)
               
            }.padding(.bottom)
               .sheet(isPresented: self.$showRenameList){
                  RenameList(thisList: self.thisList, newListName: self.thisList.wrappedName, showingRenameListBinding: self.$showRenameList)
                     .environmentObject(self.globalVariables)
            }
         }
         
         
         // ===List of items WITHOUT categories===
         if globalVariables.catalogueShown == false && useCategories == false {
            
            List {
               ForEach(itemsFetchRequest.wrappedValue) { item in
                  ItemRow(thisList: self.thisList, thisItem: item, markedOff: item.markedOff, position: item.position)
               }
               .onDelete(perform: removeSwipedItem)
               .onMove(perform: moveItem)
               
               InCart(listFromHomePage: self.thisList, categoryFromItemList: self.inCart!)
               
            }.padding(.bottom)
               .sheet(isPresented: self.$showRenameList){
                  RenameList(thisList: self.thisList, newListName: self.thisList.wrappedName, showingRenameListBinding: self.$showRenameList)
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
         
         .navigationBarItems(
            trailing:
            NavBarList(showListOptions: $showListOptions, showRenameList: $showRenameList, thisList: thisList, startUp: startUp, presentationModeNav: self.presentationMode)
      )
      
   }// End of body
   
   
   
   
   
   
   // REMOVE (swiped) ITEM
   func removeSwipedItem(indicies: IndexSet) {
      
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
         fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.position, ascending: true)]
         print("Fetch by position")
      }
      else if UserDefaults.standard.string(forKey: "syncSortItemsBy") == "Alphabetical" {
         fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))]
         print("Fetch by name")
      }
      
      do {
         let items = try managedContext.fetch(fetchRequest)
         
         for index in indicies {
            
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
      
      let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
      fetchRequest.predicate = compoundPredicate
      fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.position, ascending: true)]
      
      do {
         let items = try managedContext.fetch(fetchRequest) as! [Item]
         
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
   
   
   // ===SORT ITEM POSITIONS ALPHABETICALLY===
   func sortItemPositionsAlphabetically() {
      
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
         else {
            return
      }
      let managedContext = appDelegate.persistentContainer.viewContext
      
      let originPredicate = NSPredicate(format: "origin = %@", thisList)
      let addedToAListPredicate = NSPredicate(format: "addedToAList == true")
      let markedOffPredicate = NSPredicate(format: "markedOff == false")
      let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, addedToAListPredicate, markedOffPredicate])
      
      let fetchRequest: NSFetchRequest<Item> = NSFetchRequest.init(entityName: "Item")
      fetchRequest.predicate = compoundPredicate
      fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))]
      
      do {
         let items = try managedContext.fetch(fetchRequest)
         var index: Int = 0
         for item in items {
            item.position = Int32(index)
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
   
}





struct ClearButton: ViewModifier {

   @EnvironmentObject var globalVariables: GlobalVariableClass

   public func body(content: Content) -> some View {
      HStack() {
         content
         if !globalVariables.itemInTextfield.isEmpty {
            Spacer()
            Button(action: {
               self.globalVariables.itemInTextfield = ""
            }) {
               Image(systemName: "multiply.circle")
                  .imageScale(.large)
                  .foregroundColor(Color(.gray))
                  .padding(5)
            }
            .padding(.trailing, 10)
         }
      }
   }
}
