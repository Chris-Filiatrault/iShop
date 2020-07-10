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
   
   
   @FetchRequest(entity: Category.entity(), sortDescriptors: [
      NSSortDescriptor(keyPath: \Category.name, ascending: true)
   ]) var categories: FetchedResults<Category>
   
   var thisItem: Item
   @Binding var showItemDetails: Bool
   @State var itemName: String
   @State var oldItemCategory: Category
   @State var newItemCategory: Category
   @State var thisItemQuantity: Int32
   var thisList: ListOfItems
   
   
   var body: some View {
      
      NavigationView {
         GeometryReader { geometry in
            VStack(alignment: .leading) {
               
               Form {
                  
                  // Name
                  Section(header: Text("Name")) {
                     
                     TextField("Enter name", text: self.$itemName, onCommit: {
                        if self.itemName != "" {
                           renameItem(currentName: self.thisItem.wrappedName, newName: self.itemName)
                        }
                     })
                        .cornerRadius(5)
                        .frame(width: geometry.size.width * 0.9)
                        .font(.headline)
                  }
                  
                  // Category
                  Section(header: Text("")) {
                     Picker(selection: self.$newItemCategory, label: Text("Category")) {
                        ForEach(self.categories, id: \.self) { category in
                           Text(category.wrappedName)
                        }
                        .onReceive([self.newItemCategory].publisher.first()) { (category) in
                           changeCategory(thisItem: self.thisItem,
                                          oldCategory: self.thisItem.categoryOrigin!,
                                          newCategory: self.newItemCategory)
                        }
                     }
                  }
                  
                  // Quantity
                  Section {
                     
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
                  }
               }
            }
            .padding()
               
               // === Nav bar ===
               .navigationBarTitle("Details", displayMode: .large)
               .navigationBarItems(trailing:
                  Button(action: {
                     self.showItemDetails.toggle()
                     if self.itemName != "" {
                        renameItem(currentName: self.thisItem.wrappedName, newName: self.itemName)
                     }
                     
                     /* Changing an item category happens in two parts:
                      a) onReceive() above changes the categoryOrigin
                      b) If a change was made to the item category, all items with the same name are removed from the old category's item array and added to the new one */
                     if self.oldItemCategory != self.newItemCategory {
                        for item in self.oldItemCategory.itemsInCategoryArray {
                           if item.wrappedName == self.thisItem.wrappedName {
                              self.oldItemCategory.removeFromItemsInCategory(item)
                           }
                        }
                        for item in self.newItemCategory.itemsInCategoryArray {
                           if item.wrappedName == self.thisItem.wrappedName {
                              self.newItemCategory.addToItemsInCategory(item)
                           }
                        }
                     }
                     
                  }) {
                     Text("Done")
                        .font(.headline)
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 5))
               })
         }
      }
   }
}

