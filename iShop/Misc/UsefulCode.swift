


// ==============================================================================
// ==============================================================================
// ============================INDIVIDUAL LIST===================================
// ==============================================================================
// ==============================================================================



//      KeyboardDoneButton(keyboardType: .default, returnVal: .done, tag: 0, text: $newItem, isfocusAble: $focused)






//                  // Edit button
//                  Button(action: {
//                     self.modifyingItem = (thisItem as? Item)?.name ?? "Error: couldn't find item"
//                     self.newItem = (thisItem as? Item)?.name ?? "Error: couldn't find item"
//                     self.showItemSheet = true
//                     print("Edit button pressed")
//                  }) {
//                     Image(systemName: "square.and.pencil")
//                        .imageScale(.large)
//                  }
//                  .padding(.trailing, 20)
//                  .sheet(isPresented: self.$showItemSheet) {
//                     Text("Edit details here")
//                  }
//
// Delete button
//                  Button(action: {
//                     print("Delete button pressed")
//                  }) {
//                     Image(systemName: "trash")
//                        .imageScale(.large)
//                  }
//                  .padding(.trailing, 5)
//





// TEXTFIELD WITH CHECKS
//===Add item textfield===
//       TextField("Enter item...", text: $newItem, onCommit: {
//
//          // Check if the item exists (in entire managed context)
//          if self.checkIfItemExists(name: self.newItem) {
//
//             // If so, set the popup flag to true, popup message item to the item entered, and reset the textfield to an empty string.
//             self.duplicateItemPopup = self.checkIfItemExists(name: self.newItem)
//             self.messageItem = self.newItem
//             self.newItem = ""
//          }
//             // Otherwise, if the item isn't blank add to moc and reset the textfield
//          else if self.newItem != "" {
//             self.addNewItem()
//             self.newItem = ""
//          }
//       })
//          .textFieldStyle(RoundedBorderTextFieldStyle())
//          .padding(5)
//          .background(Color("lightDarkGrey"))
//          .cornerRadius(5)
//          .padding()
//
//







// OLD ADD ITEM BUTTON WITH POPUP
//
//
//
//// ===Add button===
//if addItemButtonIsShown == true {
//
//   Button(action: {
//
//      // Check if the item exists (in entire managed context)
//      if self.checkIfItemExists(name: self.newItem) {
//
//         // If so, set the popup flag to true, popup message item to the item entered, and reset the textfield to an empty string.
//         self.duplicateItemPopup = self.checkIfItemExists(name: self.newItem)
//         self.messageItem = self.newItem
//         self.newItem = ""
//      }
//         // Otherwise, if the item isn't blank add to moc and reset the textfield
//      else if self.newItem != "" {
//         self.addNewItem()
//         self.newItem = ""
//      }
//   })
//   {
//      Text("Add item")
//         .bold()
//         .frame(minWidth: 50)
//         .font(.subheadline)
//         .padding(10)
//         .background(Color.blue)
//         .foregroundColor(.white)
//         .cornerRadius(10)
//   }.padding(.bottom, 10)
//      .contentShape(Rectangle())
//      .alert(isPresented: $duplicateItemPopup) {
//         Alert(title: Text("Message"), message: Text("\"\(messageItem)\" is already in the list"))
//   }
//
//}






// Custom textfield
//   @State var newItem = ""
//@State var focused: [Bool] = [false, true]

//   @ObservedObject var kGuardian = keyboardGuardian(textFieldCount: 1)
//   //@Environment(\.presentationMode) var presentationMode
//@Environment(\.managedObjectContext) var moc



// LIST OF ITEMS
         //List(items, id: \.self) { thisItem in
//         List {
//            ForEach(itemsFromFetchRequest, id: \.self) { thisItem in
//
//               // toggle is declared in helper functions
//               Button(action: self.toggle) {
//                     self.isChecked ?
//                     Text((thisItem as? Item)?.name ?? "Error: unknown item")
//                        .frame(width:200, height:20, alignment: .leading)
//                        .foregroundColor(Color("blackWhiteFont"))
//                        .font(.system(size: 20))
//                        .padding(.horizontal, 3)
//                     :
//                     Text((thisItem as? Item)?.name ?? "Error: unknown item")
//                        .strikethrough(true, color: .red)
//                        .frame(width:200, height:20, alignment: .leading)
//                        .foregroundColor(Color("blackWhiteFont"))
//                        .font(.system(size: 20))
//                        .padding(.horizontal, 3)
//                     }
//                  }
//               .onDelete(perform: deleteSwipedItem)
//            .onAppear(){
//               }
//            }



//   @FetchRequest(entity: Item.entity(), sortDescriptors: [
//      NSSortDescriptor(keyPath: \Item.name, ascending: true)
//   ])
//   var itemsFromFetchRequest: FetchedResults<Item>
//




//// ===Add item button===
//if addItemButtonIsShown == true {
//
//   Button(action: {
//      if self.itemName != "" {
//         addItemToThisList(itemName: self.$itemName, listOrigin: self.thisList)
//         self.itemName = ""
//      }}) {
//
//            ZStack {
//               Rectangle()
//                  .frame(width: 200, height: 50)
//                  .hidden()
//                  .offset(y: -10)
//
//               Text("Add")
//                  .bold()
//                  .frame(minWidth: 60)
//                  .font(.subheadline)
//                  .padding(10)
//                  .background(Color(.systemTeal))
//                  .foregroundColor(Color("standardDarkBlue"))
//                  .cornerRadius(10)
//                  .transition(.scale)
//            }
//
//
//   }
//
//}


//
//// ===Enter item textfield===
//TextField("Add item", text: $itemName, onEditingChanged: { tfActive in
//   withAnimation {
//      self.addItemButtonIsShown = tfActive
//   }
//}, onCommit: {
//   if self.itemName != "" {
//      addItemToThisList(itemName: self.$itemName, listOrigin: self.thisList)
//      self.itemName = ""
//   }
//})
//   .textFieldStyle(RoundedBorderTextFieldStyle())
//   .padding(5)
//   .cornerRadius(5)
//   .padding(.top)
//   .padding(.horizontal)
//



















// ITEMLIST STARTED WITH BUTTON POPUP FOR ITEM CATALOGUE


//
//  ItemList.swift
//  iShop
//
//  Created by Chris Filiatrault on 13/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
////
//
//import SwiftUI
//import CoreData
//
//struct ItemList: View {
//   
//   var thisList: ListOfItems
//   
//   @State var test: Bool = false
//   
//   @State var itemName: String = ""
//   @State var addItemButtonIsShown: Bool = false
//   @State var showMoreOptions: Bool = false
//   
//   @FetchRequest(entity: Item.entity(), sortDescriptors: []) var items: FetchedResults<Item>
//   
//   
//   var body: some View {
//      GeometryReader { geometry in
//         ZStack {
//            
//            // Background color
//            Color("listBackground")
//            
//            VStack {
//               
//               
//               
//               
//               
//               // ============== Flip colors of button? ==================
//               
//               
//               
//               
//               // ===Add item button===
//               Button(action: {
//                  self.test.toggle()
//                  print(self.test)
//                  }) {
//                     
//                     ZStack {
//                        Rectangle()
//                           .frame(width: geometry.size.width * 0.7, height: 55)
//                          .hidden()
//                           .foregroundColor(.black)
//                           
//                        
//                        Text("Add items")
//                           .bold()
//                           .frame(width: geometry.size.width * 0.6, height: 35)
//                           .font(.subheadline)
//                       //    .padding(10)
//                           .background(Color(.systemTeal))
//                           .foregroundColor(Color("standardDarkBlue"))
//                           .cornerRadius(10)
//                           .transition(.scale)
//                     }
//               }.padding(.top, 10)
//               
//                  // ===Nav bar items===
//                  .navigationBarItems(trailing:
//                     HStack {
//                        
//                        // Edit button
//                        EditButton()
//                           .padding(.trailing, 5)
//                           .foregroundColor(Color("navBarFont"))
//                        
//                        // More options ellipsis
//                        Button(action: {
//                           self.showMoreOptions.toggle()
//                        }) {
//                           Image(systemName: "ellipsis.circle")
//                              .imageScale(.large)
//                              .foregroundColor(Color("navBarFont"))
//                        }.sheet(isPresented: self.$showMoreOptions){
//                           MoreOptions()
//                        }
//                  })
//                  .navigationBarTitle(Text(self.thisList.wrappedName), displayMode: .inline)
//               
//               
//               // ===List of items===
//               List {
//                  ForEach(self.thisList.itemArray, id: \.self) { item in
//                     ItemCategoryRow(thisItem: item, itemName: item.wrappedName, itemInListMarkedOff: item.markedOff)
//                  }
//                  .onDelete(perform: self.deleteSwipedItem)
//                  .listRowBackground(Color(.white))
//               }
//               .background(Color("listBackground"))
//               .navigationBarTitle(Text(self.thisList.wrappedName), displayMode: .inline)
//               
//               
//               
//            }
//            //.modifier(AdaptsToSoftwareKeyboard())
//         }
//      }
//      
//      
//   } // End of body
//   
//   
//   // DELETE (swiped) ITEM
//   func deleteSwipedItem(at offsets: IndexSet) {
//      
//      guard let appDelegate =
//         UIApplication.shared.delegate as? AppDelegate else {
//            return
//      }
//      
//      let managedContext =
//         appDelegate.persistentContainer.viewContext
//      
//      let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
//      fetchRequest.predicate = NSPredicate(format: "origin = %@", thisList)
//      
//      
//      do {
//         
//         let fetchReturn = try managedContext.fetch(fetchRequest)
//         
//         for offset in offsets {
//            // find object
//            let object = fetchReturn.reversed()[offset]
//            
//            // delete that object
//            managedContext.delete(object as! NSManagedObject)
//            
//         }
//         
//         do {
//            try managedContext.save()
//            print("Item successfully deleted")
//         } catch let error as NSError {
//            print("Could not delete. \(error), \(error.userInfo)")
//         }
//         
//      } catch let error as NSError {
//         print("Could not fetch. \(error), \(error.userInfo)")
//      }
//   }
//   
//   
//}
//




//
//// ===LOAD ITEMS===
//func loadItems() -> [NSManagedObject]{
//   
//   guard let appDelegate =
//      UIApplication.shared.delegate as? AppDelegate else {
//         return []
//   }
//   
//   let managedContext =
//      appDelegate.persistentContainer.viewContext
//   
//   let fetchRequest =
//      NSFetchRequest<NSManagedObject>(entityName: "Item")
//   
//   do {
//      let results = try managedContext.fetch(fetchRequest)
//      
//      return results
//      
//      // make sure to modify itemObjects always in main queue
//      //      DispatchQueue.main.async {
//      //         GlobalVariableClass.shared.itemObjects = results
//      //      }
//   }   catch let error as NSError {
//      print("Could not fetch items. \(error), \(error.userInfo)")
//      return []
//   }
//}




//// ===LOAD LISTS===
//func loadLists() -> [NSManagedObject] {
//
//   guard let appDelegate =
//      UIApplication.shared.delegate as? AppDelegate else {
//         return []
//   }
//
//   let managedContext =
//      appDelegate.persistentContainer.viewContext
//
//   let fetchRequest =
//      NSFetchRequest<NSManagedObject>(entityName: "ListOfItems")
//
//   do {
//      let fetchResults = try managedContext.fetch(fetchRequest)
//
//      return fetchResults
//
//      // make sure to modify itemObjects always in main queue
//      //      DispatchQueue.main.async {
//      //         GlobalVariableClass.shared.listObjects = results
//      //      }
//   }   catch let error as NSError {
//      print("Could not fetch lists. \(error), \(error.userInfo)")
//      return []
//   }
//}




//
//// ===ADD STARTUP ITEMS===
//// For turning the array of strings in Home.swift into Items
//func addStartupItems(itemName: Binding<String>, listOrigin: ListOfItems) {
//
//   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//      return
//   }
//
//   let managedContext = appDelegate.persistentContainer.viewContext
//
//   let entity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)!
//
//
//   let newItem = Item(entity: entity, insertInto: managedContext)
//   newItem.name = itemName.wrappedValue
//   newItem.id = UUID()
//   newItem.dateAdded = Date()
//   newItem.addedToAList = true
//   newItem.origin = listOrigin
//
//
//   listOrigin.addToItems(newItem)
//   do {
//      try managedContext.save()
//      print("Saved item successfully -- \(itemName.wrappedValue)")
//   } catch let error as NSError {
//      print("Could not save items. \(error), \(error.userInfo)")
//   }
//}






//// ===ADD NEW ITEM COPY===
//
//func addNewItem(itemName: Binding<String>, listOrigin: ListOfItems) {
//
//   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//      return
//   }
//
//   let managedContext = appDelegate.persistentContainer.viewContext
//
//   let entity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)!
//
//
//
//   // New item --> create + add to list
//   if itemNameIsUnique(name: itemName.wrappedValue, thisList: listOrigin) {
//      let newItem = Item(entity: entity, insertInto: managedContext)
//      newItem.name = itemName.wrappedValue
//      newItem.id = UUID()
//      newItem.dateAdded = Date()
//      newItem.addedToAList = true
//      newItem.origin = listOrigin
//      newItem.quantity = 1
//      listOrigin.addToItems(newItem)
//
//
//      print("listOrigin name after adding new item part is:  \(listOrigin.wrappedName)")
//   }
//
//
//      // Existing item --> only add to list
//   else if !itemNameIsUnique(name: itemName.wrappedValue, thisList: listOrigin) {
//
//      print("listOrigin name just before declaring fetch request is:  \(listOrigin.wrappedName)")
//
//
//      let originPredicate = NSPredicate(format: "origin = %@", listOrigin)
//      let namePredicate = NSPredicate(format: "name = %@", itemName.wrappedValue)
//      let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, namePredicate])
//
//
//      let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
//
//      fetchRequest.predicate = compoundPredicate
//
//      do {
//         let fetchReturn = try managedContext.fetch(fetchRequest)
//
//         let items = fetchReturn as! [Item]
//         for item in items {
//            print(item.wrappedName)
//            print(item.wrappedOriginName)
//         }
//
//         let returnedItem = fetchReturn[0] as! Item
//
//         if returnedItem.addedToAList == true {
//            returnedItem.quantity += 1
//
//            print("returnedItem name listOrigin is: \(returnedItem.wrappedOriginName)")
//
//         }
//         else if returnedItem.addedToAList == false {
//            returnedItem.addedToAList = true
//            print("Set addedToAList = true")
//         }
//
//      } catch let error as NSError {
//         print("Could not fetch. \(error), \(error.userInfo)")
//      }
//   }
//
//   do {
//      try managedContext.save()
//   } catch let error as NSError {
//      print("Could not save items. \(error), \(error.userInfo)")
//   }
//}




//
//// ===MARK OFF ITEM===
//// Mark off the tick circle in a list as having been added to the users basket
//func markOffItemInList(thisItem: Item, itemID: UUID, itemOrigin: String) {
//
//   var checkedOffValue: Bool = thisItem.markedOff
//   checkedOffValue.toggle()
//
//   guard let appDelegate =
//      UIApplication.shared.delegate as? AppDelegate else {
//         return
//   }
//
//   let managedContext =
//      appDelegate.persistentContainer.viewContext
//
//   let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
//   fetchRequest.predicate = NSPredicate(format: "id = %@", itemID as CVarArg)
//
//   do {
//      let fetchReturn = try managedContext.fetch(fetchRequest)
//
//      let objectBeingUpdated = fetchReturn[0] as! NSManagedObject
//      objectBeingUpdated.setValue(checkedOffValue, forKey: "markedOff")
//
//      do {
//         try managedContext.save()
//         print("Checked off successfully")
//      } catch let error as NSError {
//         print("Could not save checked off status. \(error), \(error.userInfo)")
//      }
//
//   } catch let error as NSError {
//      print("Could not fetch. \(error), \(error.userInfo)")
//   }
//}





//func addAllItemsToAllLists() {
//
//   guard let appDelegate =
//      UIApplication.shared.delegate as? AppDelegate else {
//         return
//   }
//
//   let managedContext =
//      appDelegate.persistentContainer.viewContext
//
//   let listFetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ListOfItems")
//
//   let itemFetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
//
//   //   let listEntity = NSEntityDescription.entity(forEntityName: "ListOfItems", in: managedContext)!
//
//   let itemEntity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)!
//
//
//   do {
//      let lists = try managedContext.fetch(listFetchRequest) as! [ListOfItems]
//      let items = try managedContext.fetch(itemFetchRequest) as! [Item]
//
//      for list in lists {
//         for existingItem in items {
//
//            let item = Item(entity: itemEntity, insertInto: managedContext)
//            item.name = existingItem.wrappedName
//            item.id = UUID()
//            item.dateAdded = Date()
//            item.addedToAList = false
//            item.markedOff = false
//            item.quantity = 1
//            item.origin = list
//            list.addToItems(item)
//
//            //            newGroceryCategory.addToItemsInCategory(item)
//            //            newItem = Item(entity: itemEntity, insertInto: managedContext)
//
//
//
//            print("Added \(item.wrappedName) to \(list.wrappedName)")
//         }
//
//      }
//
//
//      do {
//         try managedContext.save()
//      } catch let error as NSError {
//         print("Could not save. \(error), \(error.userInfo)")
//      }
//
//   } catch let error as NSError {
//      print("Could not fetch. \(error), \(error.userInfo)")
//   }
//}
