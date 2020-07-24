//
//  ItemDetails.swift
//  iShop
//
//  Created by Chris Filiatrault on 9/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import CoreData

struct ItemDetails: View {
   
   
   @FetchRequest(entity: ListOfItems.entity(), sortDescriptors: [
      NSSortDescriptor(keyPath: \ListOfItems.name, ascending: true)
   ], predicate: NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D")) var lists: FetchedResults<ListOfItems>
   
   var thisItem: Item
   @Binding var showItemDetails: Bool
   @State var itemName: String
   @State var oldItemCategory: Category
   @State var newItemCategory: Category
   @State var thisItemQuantity: Int32
   @State var oldList: ListOfItems
   @State var newList: ListOfItems
   @State var showAddNewCategory: Bool = false
   @State var categoryName: String
   @State var textfieldActive: Bool = false
   var thisList: ListOfItems
   
   
   var body: some View {
      
      NavigationView {
         GeometryReader { geometry in
            VStack {
               
               Form {
                  
                  // Name
                  TextField("Enter name", text: self.$itemName,
                     onEditingChanged: { edit in
                              self.textfieldActive = true
                  }, onCommit: {
                     if self.itemName != "" {
                        renameItem(currentName: self.thisItem.wrappedName, newName: self.itemName)
                     }
                  })
                     .cornerRadius(5)
                     .frame(width: geometry.size.width * 0.9)
                     .font(.headline)
                  
                  // Quantity
                  HStack {
                     Text("Quantity: ")
                     Text("\(self.thisItemQuantity)")
                     Spacer()
                     Image(systemName: "plus")
                        .foregroundColor(.black)
                        .imageScale(.large)
                        .onTapGesture {
                           incrementItemQuantity(thisItem: self.thisItem, thisList: self.thisList)
                           self.thisItemQuantity += 1
                     }
                     Image(systemName: "minus")
                        .foregroundColor(.black)
                        .imageScale(.large)
                        .onTapGesture {
                           if self.thisItemQuantity > 1 {
                              self.thisItemQuantity -= 1
                              decrementItemQuantity(thisItem: self.thisItem, thisList: self.thisList)
                           }
                     }
                     .padding(.leading, 10)
                  }
                  
                  // Category
                  NavigationLink(destination: ChooseCategory(thisItem: self.thisItem, newItemCategory: self.$newItemCategory, categoryName: self.$categoryName, textfieldActive: self.$textfieldActive)) {
                     HStack {
                        Text("Category")
                        Spacer()
                        Text("\(self.categoryName)").foregroundColor(.gray)
                     }
                     
                  }
                  
                  // List
                  Picker(selection: self.$newList, label: Text("List")) {
                     ForEach(self.lists, id: \.self) { list in
                        Text(list.wrappedName)
                     }
                  }
                  
                  // Delete (remove from list)
                  Button(action: {
                     removeItemFromList(item: self.thisItem)
                     self.showItemDetails = false
                  }) {
                     Text("Delete")
                        .foregroundColor(.red)
                     
                  }
                  
               }// End of form
               
               
            }// End of VStack
               
               .background(Color("listBackground").edgesIgnoringSafeArea(.all))
               
               // === Nav bar ===
               .navigationBarTitle("Details", displayMode: .inline)
               .navigationBarItems(trailing:
                  Button(action: {
                     self.showItemDetails = false
                     if self.itemName != "" {
                        renameItem(currentName: self.thisItem.wrappedName, newName: self.itemName)
                     }
                     
                     /* Changing an item category happens in two parts:
                      a) onReceive() above changes the categoryOrigin
                      b) Below, if a change was made to the item category, all items with the same name are removed from the old category's item array and added to the new one */
                     if self.oldItemCategory != self.newItemCategory {
                        changeCategory2(thisItem: self.thisItem, oldItemCategory: self.oldItemCategory, newItemCategory: self.newItemCategory)
                     }
                     
                     if self.oldList != self.newList {
                        changeItemList(thisItem: self.thisItem, newList: self.newList)
                     }
                     
                  }) {
                     Text("Done")
                        .font(.headline)
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 5))
               })
         }
      }.environment(\.horizontalSizeClass, .compact)
   }
}
