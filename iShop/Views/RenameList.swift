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
      
      VStack {
         
         Text("Rename List")
            .bold()
            .font(.largeTitle)
            .padding(.top, 50)
         Divider()
            .padding(.bottom, 30)
            .offset(y: -15)
         
         // ===Rename List Textfield===
         CustomTextField("", text: RenameList.newListNameBinding, focusTextfieldCursor: RenameList.focusTextfield, onCommit: {
            self.commit()
         })
            .padding(.bottom)
            .alert(isPresented: $duplicateListAlert) {
               Alert(title: Text("Alert"), message: Text("List names must be unique\nPlease choose another name"), dismissButton: .default(Text("Done")))
         }
         
         // ===Buttons===
         HStack(alignment: .center) {
            
            // Cancel button
            Button(action: {
               self.setFocusTextfieldToFalse()
               self.showingRenameListBinding = false
            }) {
               Text("Cancel")
               .bold()
               .modifier(CancelButton())
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
         
      }// End of VStack
         
         .padding()
         .environment(\.horizontalSizeClass, .compact)
         .background(Color("plainSheetBackground").edgesIgnoringSafeArea(.all))
         
         .onAppear {
            RenameList.newListName = self.thisList.wrappedName
      }
         .onDisappear {
            // This simply makes the string being reset unseen by the user (cleaner)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               RenameList.newListName = ""
            }
         }
      
   }
   func commit() {
      if RenameList.newListName != "" && listNameIsUnique(name: RenameList.newListName) {
         renameList(thisList: self.thisList, newName: RenameList.newListName)
         self.setFocusTextfieldToFalse()
         self.showingRenameListBinding = false
      }
      else if RenameList.newListName == self.thisList.wrappedName {
         self.setFocusTextfieldToFalse()
         self.showingRenameListBinding = false
      }
      else if !listNameIsUnique(name: RenameList.newListName) {
         self.duplicateListAlert = true
      }
      else if RenameList.newListName == "" {
         self.setFocusTextfieldToFalse()
         self.showingRenameListBinding = false
      }
   }
   
   /// Setting `focusTextfield = false` prevents the keyboard from popping up after the sheet is dismissed
   func setFocusTextfieldToFalse() {
      RenameList.focusTextfield = false
   }
   
}
