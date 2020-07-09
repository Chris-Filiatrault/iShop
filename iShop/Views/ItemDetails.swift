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
   @State var itemCategory: Category
   
   var body: some View {
      
      NavigationView {
         GeometryReader { geometry in
         VStack(alignment: .leading) {
            
            Form {
               Section(header: Text("Name")) {
                  TextField("", text: self.$itemName, onCommit: {
                     if self.itemName != "" {
                        renameItem(currentName: self.thisItem.wrappedName, newName: self.itemName)
                     }
                  })
                  .cornerRadius(5)
                  .frame(width: geometry.size.width * 0.9)
               }
               
               Section(header: Text("Category")) {
                  Picker(selection: self.$itemCategory, label: Text("Category")) {
                     ForEach(self.categories, id: \.self) { category in
                        Text(category.wrappedName)
                     }
                  }.pickerStyle(WheelPickerStyle())
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
            }) {
               Text("Done")
                  .font(.headline)
                  .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 5))
         })
      }
      }
   }
}


//
//
////
////  EditNameView.swift
////  Simple List
////
////  Created by Chris Filiatrault on 13/6/20.
////  Copyright © 2020 Chris Filiatrault. All rights reserved.
//
//
//import SwiftUI
//
//struct EditNameView: View {
//
//   var thisItem: Item
//   @State var newName: String
//   @Binding var showEditNameView: Bool
//   @Binding var isEditMode: EditMode
//
//   var body: some View {
//
//      NavigationView {
//         GeometryReader { geometry in
//            VStack {
//                  Text("Rename ")
//                     .font(.title)
//
//
//               // ===Enter item textfield===
//               TextField("Enter new name...", text: self.$newName, onCommit: {
//                  if self.newName != "" {
//                     editName(thisItem: self.thisItem, itemNewName: self.newName)
//                     self.showEditNameView.toggle()
//                     self.newName = ""
//                  }
//                  print(self.showEditNameView)
//               })
//                  .textFieldStyle(RoundedBorderTextFieldStyle())
//                  .padding(5)
//                  .cornerRadius(5)
//                  .padding(.bottom, 10)
//
//
//               // ===Buttons===
//               HStack(alignment: .center) {
//
//                  // Cancel button
//                  Button(action: {
//                     self.showEditNameView.toggle()
//                     print(self.showEditNameView)
//                  }) {
//                     Text("Cancel")
//                        .bold()
//                        .cornerRadius(20)
//                        .font(.subheadline)
//                        .frame(minWidth: 50)
//                  }.contentShape(Rectangle())
//
//                  // Add button
//                  Button(action: {
//                     if self.newName != "" {
//                        editName(thisItem: self.thisItem, itemNewName: self.newName)
//                        self.newName = ""
//                        self.showEditNameView.toggle()
//                        print(self.showEditNameView)
//                     }
//                  }) {
//
//
//                     Text("Done")
//                        .bold()
//                        .frame(minWidth: 50)
//                        .font(.subheadline)
//                        .padding(10)
//                        .background(Color("blueButton"))
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                        .transition(.scale)
//                        .edgesIgnoringSafeArea(.horizontal)
//                  }
//                  .contentShape(Rectangle())
//                  .padding(.leading, 20)
//               }
//            }
//            .padding(.bottom, geometry.size.height * 0.55)
//            .padding()
//            .onDisappear {
//               withAnimation {
//                  self.isEditMode = .inactive
//                  self.showEditNameView = false
//               }
//            }
//         }
//
//
//         // === Nav bar items ===
//         .navigationBarTitle("", displayMode: .inline)
//         .navigationBarItems(leading:
//            Button(action: {
//               self.showEditNameView.toggle()
//               print(self.showEditNameView)
//            }) {
//               Text("Cancel")
//                  .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 15))
//            }
//         )
//
//      }
//      .environment(\.horizontalSizeClass, .compact)
//   }
//}
//
//
//
//
//
//
//
//
//

