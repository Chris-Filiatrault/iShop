//
//  AddList.swift
//  iShop
//
//  Created by Chris Filiatrault on 11/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//


import SwiftUI

struct AddList: View {
   
   @State var newList: String = ""
   @State var duplicateListAlert = false
   @Binding var showingAddListBinding: Bool
   
   var body: some View {
      VStack {
      MultilineTextField("Add item", text: ItemList.textfieldValueBinding, onCommit: {
         print("Commit")
         }, focusTextfieldCursor: true)
         .padding()
         .padding(.top, 40)
         
         Spacer()
         
      }
//      NavigationView {
//         VStack {
//            
//            // when implementing the new textfield, call becomeFirstResponder, and don't use AdaptsToSoftwareKeyboard() (as I get mutating state warnings)
//            
//            // ===Enter item textfield===
//            TextField("Enter list name", text: $newList, onCommit: {
//                        if self.newList != "" && listNameIsUnique(name: self.newList) {
//                           addList(listName: self.newList)
//                           self.showingAddListBinding = false
//                           self.newList = ""
//                        }
//                        else if !listNameIsUnique(name: self.newList) {
//                           self.duplicateListAlert = true
//                        }
//                        else if self.newList == "" {
//                           self.showingAddListBinding = false
//                        }
//            })
//               .textFieldStyle(RoundedBorderTextFieldStyle())
//               .padding(5)
//               .cornerRadius(5)
//               .padding(.bottom, 20)
//               .alert(isPresented: $duplicateListAlert) {
//                  Alert(title: Text("Alert"), message: Text("List names must be unique\nPlease choose another name"), dismissButton: .default(Text("OK")))
//            }
//            
//            
//            // ===Buttons===
//            HStack {
//               
//               // Cancel button
//               Button(action: {self.showingAddListBinding = false}) {
//                  Text("Cancel")
//                     .bold()
//                     .padding()
//               }.padding(.trailing, 5)
//               
//               // Add button
//               Button(action: {
//                  if self.newList != "" && listNameIsUnique(name: self.newList) {
//                     addList(listName: self.newList)
//                     self.showingAddListBinding = false
//                     self.newList = ""
//                  }
//                  else if !listNameIsUnique(name: self.newList) { self.duplicateListAlert = true
//                  }
//               }) {
//                  Text("Add")
//                  .bold()
//                  .modifier(MainBlueButton())
//               }.padding(.leading, 5)
//               
//            }
//            
//            Spacer()
//         }
//         .padding()
//         .modifier(AdaptsToSoftwareKeyboard())
//         .navigationBarTitle("Add List", displayMode: .large)
//         
//      } // End of VStack
//      .environment(\.horizontalSizeClass, .compact)
   }
}
