//
//  ChangeCategory.swift
//  iShop
//
//  Created by Chris Filiatrault on 12/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import CoreData

struct AddCategory: View {
   @Environment(\.presentationMode) var presentationModeChooseCategory: Binding<PresentationMode>
   
   @Environment(\.editMode) var editMode
   @State var duplicateCategoryAlert = false
   var thisItem: Item
   @Binding var newItemCategory: Category
   @Binding var categoryName: String
   
   static var focusTextfield: Bool = true
   static var newCategoryName: String = ""
   static var newCategoryNameBinding = Binding<String>(get: { newCategoryName }, set: { newCategoryName = $0 } )
   
   
   var body: some View {
      
      VStack {
         
         Text("Add Category")
            .bold()
            .font(.largeTitle)
            .padding(.top, 50)
         Divider()
            .padding(.bottom, 30)
            .offset(y: -15)
         
         // ===Add Category Textfield===
         CustomTextField("Enter category name",
                         text: AddCategory.newCategoryNameBinding,
                         focusTextfieldCursor: false,
                         onCommit: { self.commit() }
         )
            .padding(.bottom)
            .alert(isPresented: $duplicateCategoryAlert) {
               Alert(title: Text("Alert"), message: Text("Category names must be unique\nPlease choose another name"), dismissButton: .default(Text("OK")))
         }
         
         
         // ===Buttons===
         HStack(alignment: .center) {
            
            // Cancel button
            Button(action: {
               self.presentationModeChooseCategory.wrappedValue.dismiss()
               AddCategory.newCategoryName = ""
            }) {
               Text("Cancel")
               .bold()
               .modifier(CancelButton())
            }.padding(.trailing, 5)
            
            // Add button
            Button(action: {
               self.commit()
            }) {
               Text("Add")
                  .bold()
                  .modifier(MainBlueButton())
            }
            .padding(.leading, 5)
            
         }
         Spacer()
      }
      .padding()
      .environment(\.horizontalSizeClass, .compact)
      .background(Color("plainSheetBackground").edgesIgnoringSafeArea(.all))

      
   }
   
   /// Setting `focusTextfield = false` prevents the navigation link from glitching after the view is dismissed
   func setFocusTextfieldToFalse() {
      AddCategory.focusTextfield = false
   }
   
   func commit() {
      if AddCategory.newCategoryName != "" && categoryNameIsUnique(name: AddCategory.newCategoryName) {
         addCategory(categoryName: AddCategory.newCategoryName, thisItem: self.thisItem)
         self.setFocusTextfieldToFalse()
         self.presentationModeChooseCategory.wrappedValue.dismiss()
         AddCategory.newCategoryName = ""
         // Add this line if I'm able to automatically move an item into a newly created category:
         // self.categoryName = AddCategory.newCategoryName
      }
      else if AddCategory.newCategoryName == "" {
         // Do nothing
      }
      else if !categoryNameIsUnique(name: AddCategory.newCategoryName) {
         self.duplicateCategoryAlert = true
      }
      else if AddCategory.newCategoryName == "" {
         self.setFocusTextfieldToFalse()
         self.presentationModeChooseCategory.wrappedValue.dismiss()
      }
      
   }
}

