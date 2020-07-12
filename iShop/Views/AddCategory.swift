//
//  ChangeCategory.swift
//  iShop
//
//  Created by Chris Filiatrault on 12/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

struct AddCategory: View {
   
//   @State var newList: String = ""
//   @State var addItemButtonIsShown: Bool = false
//   @State var duplicateListAlert = false
//   
//   @Binding var showingAddListBinding: Bool
    var body: some View {
      Text("Hi")
//        NavigationView {
//           VStack {
//              // ===Enter item textfield===
//              TextField("Enter list name", text: $newList,
//                        onEditingChanged: { tfActive in
//                          withAnimation {
//                             self.addItemButtonIsShown = tfActive
//                          }},
//                        onCommit: {
//                          if self.newList != "" && listNameIsUnique(name: self.newList) {
//                             addList(stateVariable: self.$newList)
//                             self.showingAddListBinding = false
//                             self.newList = ""
//                          }
//                          else if !listNameIsUnique(name: self.newList) {
//                             self.duplicateListAlert = true
//                          }
//                          else if self.newList == "" {
//                             self.showingAddListBinding = false
//                          }
//              })
//                 .textFieldStyle(RoundedBorderTextFieldStyle())
//                 .padding(5)
//                 .cornerRadius(5)
//                 .padding(.bottom, 20)
//                 .alert(isPresented: $duplicateListAlert) {
//                    Alert(title: Text("Alert"), message: Text("List names must be unique\nPlease choose another name"), dismissButton: .default(Text("OK")))
//              }
//              
//              
//              // ===Buttons===
//              HStack(alignment: .center) {
//                 
//                 // Cancel button
//                 Button(action: {self.showingAddListBinding = false}) {
//                    Text("Cancel")
//                       .bold()
//                       .cornerRadius(20)
//                       .font(.subheadline)
//                       .foregroundColor(Color("darkBlueFont"))
//                       .frame(minWidth: 50)
//                 }.contentShape(Rectangle())
//                 
//                 // Add button
//                 //  if addItemButtonIsShown == true {
//                 Button(action: {
//                    if self.newList != "" && listNameIsUnique(name: self.newList) {
//                       addList(stateVariable: self.$newList)
//                       self.showingAddListBinding = false
//                       self.newList = ""
//                    }
//                    else if !listNameIsUnique(name: self.newList) { self.duplicateListAlert = true
//                    }
//                 }) {
//                    Text("Add")
//                       .bold()
//                       .frame(minWidth: 50)
//                       .font(.subheadline)
//                       .padding(10)
//                       .background(Color(.systemTeal))
//                       .foregroundColor(Color("standardDarkBlue"))
//                       .cornerRadius(10)
//                       .transition(.scale)
//                       .edgesIgnoringSafeArea(.horizontal)
//                 }
//                 .contentShape(Rectangle())
//                 .padding(.leading, 20)
//                 // }
//                 
//              }
//              Spacer()
//           }
//           .navigationBarTitle("Add new list")
//           .padding()
//           .modifier(AdaptsToSoftwareKeyboard())
//           
//        } // End of VStack
    }
}

