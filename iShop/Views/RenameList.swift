//
//  RenameList.swift
//  iShop
//
//  Created by Chris Filiatrault on 25/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//


import SwiftUI

struct RenameList: View {
   
   var thisList: ListOfItems
   @State var newListName: String
   @State var duplicateListAlert = false
   @Binding var showingRenameListBinding: Bool
   
   @Environment(\.managedObjectContext) var context
   @EnvironmentObject var globalVariables: GlobalVariableClass
   
   var body: some View {
      
      NavigationView {
         VStack {
            
            // ===Enter item textfield===
            TextField("Enter new name", text: $newListName, onCommit: {
               self.commit()
            })
               .textFieldStyle(RoundedBorderTextFieldStyle())
               .padding(5)
               .cornerRadius(5)
               .padding(.bottom, 20)
               .alert(isPresented: $duplicateListAlert) {
                  Alert(title: Text("Alert"), message: Text("List names must be unique\nPlease choose another name"), dismissButton: .default(Text("OK")))
            }
            

            // ===Buttons===
            HStack(alignment: .center) {
               
               // Cancel button
               Button(action: { self.showingRenameListBinding = false }) {
                  Text("Cancel")
                     .bold()
                     .cornerRadius(20)
                     .font(.subheadline)
                     .frame(minWidth: 50)
               }.contentShape(Rectangle())
               
               // Add button
               Button(action: {
                  self.commit()
                  }) {
                  Text("Rename")
                     .bold()
                     .frame(minWidth: 50)
                     .font(.subheadline)
                     .padding(10)
                     .background(Color("blueButton"))
                     .foregroundColor(.white)
                     .cornerRadius(10)
                     .transition(.scale)
                     .edgesIgnoringSafeArea(.horizontal)
               }
               .contentShape(Rectangle())
               .padding(.leading, 20)
               
            }
            
            Spacer()
         }
         .padding()
         .modifier(AdaptsToSoftwareKeyboard())
            
         .navigationBarTitle("Rename List", displayMode: .large)
         
      } // End of VStack
         .environment(\.horizontalSizeClass, .compact)
      
   }
   func commit() {
      if self.newListName != "" && listNameIsUnique(name: self.newListName) {
         renameList(thisList: self.thisList, newName: self.newListName)
         self.showingRenameListBinding = false
         self.newListName = ""
      }
      else if !listNameIsUnique(name: self.newListName) {
         self.duplicateListAlert = true
      }
      else if self.newListName == "" {
         self.showingRenameListBinding = false
      }
   }
}
