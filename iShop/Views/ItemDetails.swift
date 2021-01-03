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
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @Environment(\.presentationMode) var presentationMode
   @Environment(\.managedObjectContext) var context
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   @FetchRequest(entity: ListOfItems.entity(), sortDescriptors: [
      NSSortDescriptor(key: "name", ascending: true, selector:  #selector(NSString.localizedCaseInsensitiveCompare(_:)))
   ], predicate: NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D")) var lists: FetchedResults<ListOfItems>
   
   
   @State var thisItem: Item
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
   
   static var itemName: String = ""
   static var itemNameBinding = Binding<String>(get: { itemName }, set: { itemName = $0 } )

   
   @State var testText: String = ""
   
   var body: some View {
      
      NavigationView {
         GeometryReader { geometry in
            VStack {
               
               Form {
                  
                  // Name
                  HStack {
                  Text("Name: ")
                  CustomTextField("", text: ItemDetails.itemNameBinding, focusTextfieldCursor: false, onCommit: {
                     self.commit()
                  }, onBeginEditing: {
                     self.textfieldActive = true
                  })
                     
               }
                  
                  // Quantity
                  HStack {
                     Text("Quantity: ")
                     Text("\(self.thisItemQuantity)")
                     Spacer()
                     Image(systemName: "plus")
                        .foregroundColor(.black)
                        .imageScale(.large)
                        .onTapGesture {
                           incrementItemQuantity(thisItem: self.thisItem)
                           self.thisItemQuantity += 1
                           hapticFeedback()
                     }
                     Image(systemName: "minus")
                        .foregroundColor(.black)
                        .imageScale(.large)
                        .onTapGesture {
                           hapticFeedback()
                           if self.thisItemQuantity > 1 {
                              self.thisItemQuantity -= 1
                              decrementItemQuantity(thisItem: self.thisItem)
                           }
                     }
                     .padding(.leading, 10)
                  }
                  
                  
                  // Choose category
                     NavigationLink(destination: ChooseCategory(
                        thisItem: self.thisItem,
                        oldItemCategory: self.$oldItemCategory,
                        newItemCategory: self.$newItemCategory,
                        categoryName: self.$categoryName,
                        textfieldActive: self.$textfieldActive)
                     .environment(\.managedObjectContext, self.context)
                     ) {
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
                     removeItemFromList(thisItem: self.thisItem, listOrigin: self.newList)
                     self.showItemDetails = false
//                     self.presentationMode.wrappedValue.dismiss()
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
                     
                     self.commit()
                     
                     // Change list if needed
                     if self.oldList != self.newList {
                        print("change list")
                        changeItemList(thisItem: self.thisItem, oldList: self.oldList, newList: self.newList)
                     }
                     
                  }) {
                     Text("Save")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 5))
               })
         }
         .navigationBarColor(backgroundColor: .clear, fontColor: UIColor.black)
      }
      .environment(\.horizontalSizeClass, .compact)
      
      .onAppear {
         ItemDetails.itemName = self.thisItem.wrappedName
      }
      .onDisappear {
         if self.oldItemCategory != self.newItemCategory {
            changeCategory(thisItem: self.thisItem,
                                oldItemCategory: self.oldItemCategory,
                                newItemCategory: self.newItemCategory)
         }
      }
   }
   
   func commit() {
      UIApplication.shared.endEditing()
      self.showItemDetails.toggle()
      
      if ItemDetails.itemName != "" && ItemDetails.itemName != self.thisItem.wrappedName {
         renameItem(currentName: self.thisItem.wrappedName, newName: ItemDetails.itemName)
      }
   }
   
}
