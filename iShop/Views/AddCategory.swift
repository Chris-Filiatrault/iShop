//
//  ChangeCategory.swift
//  iShop
//
//  Created by Chris Filiatrault on 12/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

struct AddCategory: View {
   @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
   
   @State var newCategory: String = ""
   @State var duplicateCategoryAlert = false
   
   
   
   var body: some View {
      NavigationView {
         VStack {
            // ===Enter item textfield===
            TextField("Enter category name", text: $newCategory,
                      onCommit: {
                        if self.newCategory != "" && categoryNameIsUnique(name: self.newCategory) {
                           //                             addList(stateVariable: self.$newCategory)
                           print("Add category")
                           self.newCategory = ""
                        }
                        else if !categoryNameIsUnique(name: self.newCategory) {
                           self.duplicateCategoryAlert = true
                        }
                        else if self.newCategory == "" {
                           self.presentationMode.wrappedValue.dismiss()
                        }
            })
               .textFieldStyle(RoundedBorderTextFieldStyle())
               .padding(5)
               .cornerRadius(5)
               .padding(.bottom, 20)
               .alert(isPresented: $duplicateCategoryAlert) {
                  Alert(title: Text("Alert"), message: Text("Category names must be unique\nPlease choose another name"), dismissButton: .default(Text("OK")))
            }
            
            
            // ===Buttons===
            HStack(alignment: .center) {
               
               // Cancel button
               Button(action: {
                  self.presentationMode.wrappedValue.dismiss()
               }) {
                  Text("Cancel")
                     .bold()
                     .cornerRadius(20)
                     .font(.subheadline)
                     .foregroundColor(.black)
                     .frame(minWidth: 50)
               }.contentShape(Rectangle())
               
               // Add button
               Button(action: {
                  if self.newCategory != "" && categoryNameIsUnique(name: self.newCategory) {
                     print("Add category")
                     //                       addList(stateVariable: self.$newCategory)
                     self.newCategory = ""
                  }
                  else if !categoryNameIsUnique(name: self.newCategory) {
                     self.duplicateCategoryAlert = true
                  }
               }) {
                  Text("Add")
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
         
      } // End of VStack
      .navigationBarTitle(Text("New category"), displayMode: .inline)
   }
}


struct AddCategory_Previews: PreviewProvider {
   static var previews: some View {
      AddCategory()
   }
}
