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
   
   @State var createdCategoryName: String = ""
   @State var duplicateCategoryAlert = false
   var thisItem: Item
   @Binding var newItemCategory: Category
   @Binding var categoryName: String
   
   
   
   var body: some View {
      NavigationView {
         VStack {
            // ===Enter item textfield===
            TextField("Enter category name", text: $createdCategoryName,
                      onCommit: {
                        if self.createdCategoryName != "" && categoryNameIsUnique(name: self.createdCategoryName) {
                           addCategory(categoryName: self.createdCategoryName, thisItem: self.thisItem)
                           self.categoryName = self.createdCategoryName
                           self.createdCategoryName = ""
                           self.presentationMode.wrappedValue.dismiss()
                        }
                        else if !categoryNameIsUnique(name: self.createdCategoryName) {
                           self.duplicateCategoryAlert = true
                        }
                        else if self.createdCategoryName == "" {
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
                  if self.createdCategoryName != "" && categoryNameIsUnique(name: self.createdCategoryName) {
                     addCategory(categoryName: self.createdCategoryName, thisItem: self.thisItem)
                     self.categoryName = self.createdCategoryName
                     self.createdCategoryName = ""
                     self.presentationMode.wrappedValue.dismiss()
                  }
                  else if !categoryNameIsUnique(name: self.createdCategoryName) {
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
         .navigationBarTitle("Add category", displayMode: .inline)
   }
}

  
