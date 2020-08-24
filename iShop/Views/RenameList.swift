//
//  RenameList.swift
//  iShop
//
//  Created by Chris Filiatrault on 25/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//


import SwiftUI

struct RenameList: View {
      
   static var focusTextfield: Bool = true
   static var newListName: String = ""
   static var newListNameBinding = Binding<String>(get: { newListName }, set: { newListName = $0 } )
   
   var thisList: ListOfItems
   @State var duplicateListAlert = false
   @Binding var showingRenameListBinding: Bool
   @Environment(\.managedObjectContext) var context
   @EnvironmentObject var globalVariables: GlobalVariableClass
   
   var body: some View {
      
      NavigationView {
         VStack {
            
            CustomTextField("", text: RenameList.newListNameBinding, focusTextfieldCursor: RenameList.focusTextfield, onCommit: {
               self.commit()
            })
               .padding()
               .padding(.top, 40)
               .alert(isPresented: $duplicateListAlert) {
                  Alert(title: Text("Alert"), message: Text("List names must be unique\nPlease choose another name"), dismissButton: .default(Text("OK")))
            }

            // ===Buttons===
            HStack(alignment: .center) {
               
               // Cancel button
               Button(action: {
                  self.preventKeyboardFromPoppingUp()
                  self.showingRenameListBinding = false
               }) {
                  Text("Cancel")
                     .bold()
                  
               }
               
               // Add button
               Button(action: {
                  self.commit()
                  }) {
                  Text("Rename")
                     .bold()
                     .modifier(MainBlueButton())
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
         .onAppear {
            RenameList.newListName = self.thisList.wrappedName
      }
         .onDisappear {
            //                  // This simply makes the string being reset unseen by the user (cleaner)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            RenameList.newListName = ""
            }
      }
      
   }
   func commit() {
      if RenameList.newListName != "" && listNameIsUnique(name: RenameList.newListName) {
         renameList(thisList: self.thisList, newName: RenameList.newListName)
         self.preventKeyboardFromPoppingUp()
         self.showingRenameListBinding = false
      }
      else if RenameList.newListName == self.thisList.wrappedName {
         self.preventKeyboardFromPoppingUp()
         self.showingRenameListBinding = false
      }
      else if !listNameIsUnique(name: RenameList.newListName) {
         self.duplicateListAlert = true
      }
      else if RenameList.newListName == "" {
         self.preventKeyboardFromPoppingUp()
         self.showingRenameListBinding = false
      }
   }
   
   /// Setting `focusTextfield = false` prevents the keyboard from popping up after the sheet is dismissed
   func preventKeyboardFromPoppingUp() {
      RenameList.focusTextfield = false
   }
   
}
