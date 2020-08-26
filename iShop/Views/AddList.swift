//
//  AddList.swift
//  iShop
//
//  Created by Chris Filiatrault on 11/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//


import SwiftUI
import Foundation

struct AddList: View {
   
   @State var duplicateListAlert = false
   @Binding var showingAddListBinding: Bool
   
   static var focusTextfield: Bool = true
   static var newList: String = ""
   static var newListBinding = Binding<String>(get: { newList }, set: { newList = $0 } )
   
   var body: some View {
      
      VStack {
         
         Text("Add List")
            .bold()
            .font(.largeTitle)
            .padding(.top, 50)
         Divider()
            .padding(.bottom, 30)
            .offset(y: -15)
         
         
         // ===Add List Textfield===
         CustomTextField("Enter list name",
                         text: AddList.newListBinding,
                         focusTextfieldCursor: AddList.focusTextfield,
                         onCommit: { self.commit() }
         )
            .padding(.bottom)
            .alert(isPresented: $duplicateListAlert) {
               Alert(title: Text("Alert"), message: Text("List names must be unique\nPlease choose another name"), dismissButton: .default(Text("OK")))
         }
         
         // ===Buttons===
         HStack {
            
            // Cancel button
            Button(action: {
               self.setFocusTextfieldToFalse()
               self.showingAddListBinding = false
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  // This simply makes the string being reset unseen by the user (cleaner)
                  AddList.newList = ""
               }
            }) {
               Text("Cancel")
                  .bold()
                  .padding()
            }.padding(.trailing, 5)
            
            // Add button
            Button(action: {
               self.commit()
            }) {
               Text("Add")
                  .bold()
                  .modifier(MainBlueButton())
            }.padding(.leading, 5)
            
         }
         
         Spacer()
      }
      .padding()
      .environment(\.horizontalSizeClass, .compact)
      .background(Color("plainSheetBackground").edgesIgnoringSafeArea(.all))
      
   }
   
   
   
   /// Adds list if the name is unique. Alerts user if name not unique. Dismisses sheet if textfield is blank.
   func commit() {
      
      if AddList.newList != "" && listNameIsUnique(name: AddList.newList) {
         addList(listName: AddList.newList)
         self.showingAddListBinding = false
         self.setFocusTextfieldToFalse()
         AddList.newList = ""
      }
         
      else if !listNameIsUnique(name: AddList.newList) {
         self.duplicateListAlert = true
      }
         
      else if AddList.newList.isEmpty {
         self.setFocusTextfieldToFalse()
         self.showingAddListBinding = false
      }
   }
   
   /// Setting `focusTextfield = false` prevents the keyboard from popping up after the sheet is dismissed
   func setFocusTextfieldToFalse() {
      AddList.focusTextfield = false
   }
   
   
}



struct AddList_Previews: PreviewProvider {
   static var previews: some View {
      AddList(showingAddListBinding: PreviewValues().$myBinding)
         .previewDevice(PreviewDevice(rawValue: "iPhone X"))
         .previewDisplayName("iPhone X")
   }
}

