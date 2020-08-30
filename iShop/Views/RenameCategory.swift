//
//  RenameCategory.swift
//  iShop
//
//  Created by Chris Filiatrault on 28/8/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//




// Create renameCategory function
// Fix up code below as needed





import SwiftUI
import CoreData

struct RenameCategory: View {
   
   //   @EnvironmentObject var globalVariables: GlobalVariableClass
   @Environment(\.editMode) var editMode
   
   @FetchRequest(entity: Category.entity(), sortDescriptors: [
      NSSortDescriptor(key: "name", ascending: true, selector:  #selector(NSString.localizedCaseInsensitiveCompare(_:)))
   ] ,predicate: NSPredicate(format: "NOT name IN %@", ["Uncategorised", "In Cart"])) var categories: FetchedResults<Category>
   
   
   var thisCategory: Category
   
   
   @State var duplicateCategoryAlert: Bool = false
   @Binding var showRenameCategory: Bool
   @Binding var categoryName: String
   
   static var focusTextfield: Bool = true
   static var renamedCategoryName: String = ""
   static var renamedCategoryNameBinding = Binding<String>(get: { renamedCategoryName }, set: { renamedCategoryName = $0 } )
   
   
   var body: some View {
      
      ZStack {
       RoundedRectangle(cornerRadius: 20)
         .foregroundColor(Color("alertWithTextfield")).edgesIgnoringSafeArea(.all)
      
      VStack {
         
         Text("Rename Category")
            .bold()
            .font(.headline)
            .padding(5)
         
         
         // ===Rename Category Textfield===
         CustomTextField("Enter category name",
                         text: RenameCategory.renamedCategoryNameBinding,
                         focusTextfieldCursor: true,
                         onCommit: { self.commit() }
            
            
         )
            .padding(.bottom, 10)
         Divider()
            .padding(.bottom, 5)
            .alert(isPresented: $duplicateCategoryAlert) {
               Alert(title: Text("Alert"), message: Text("Category names must be unique\nPlease choose another name"), dismissButton: .default(Text("OK")))
         }
         
         
         // ===Buttons===
         HStack(alignment: .center) {
            
            Spacer()
            
            // Cancel button
            Button(action: {
               self.showRenameCategory = false
               RenameCategory.renamedCategoryName = ""
               self.editMode?.wrappedValue = .inactive
            }) {
               Text("Cancel")
            }.padding(.trailing, 5)
            
            Spacer()
            Divider()
            Spacer()
            
            // Add button
            Button(action: {
               self.commit()
            }) {
               Text("Rename")
                  .bold()
            }
            .padding(.leading, 5)
            
            Spacer()
         }
      }
      .padding()
      
      .onAppear {
         RenameCategory.renamedCategoryName = self.thisCategory.wrappedName
         RenameCategory.focusTextfield = true
      }
      .onDisappear {
         RenameCategory.focusTextfield = false
         }
         
      }.frame(width: 300, height: 100)
   }
   
   
   
   
   
   /// Setting `focusTextfield = false` prevents the navigation link from glitching after the view is dismissed
   func setFocusTextfieldToFalse() {
      AddCategory.focusTextfield = false
   }
   
   func commit() {
      
      if AddCategory.newCategoryName != "" && categoryNameIsUnique(name: AddCategory.newCategoryName) {
         //      addCategory(categoryName: AddCategory.newCategoryName, thisItem: self.thisItem)
         //      self.setFocusTextfieldToFalse()
         //      self.presentationModeChooseCategory.wrappedValue.dismiss()
         //      AddCategory.newCategoryName = ""
      }
      else if AddCategory.newCategoryName == "" {
         // Do nothing
      }
      else if !categoryNameIsUnique(name: AddCategory.newCategoryName) {
               self.duplicateCategoryAlert = true
      }
      self.editMode?.wrappedValue = .inactive
   }
   
}




//var body: some View {
//   VStack {
//
//      Text("Category Details")
//         .bold()
//         .font(.largeTitle)
//         .padding(.top, 50)
//      Divider()
//         .padding(.bottom, 30)
//         .offset(y: -15)
//
//      // ===Rename Category Textfield===
//      CustomTextField("Enter category name",
//                      text: AddCategory.newCategoryNameBinding,
//                      focusTextfieldCursor: false,
//                      onCommit: { self.commit() }
//      )
//         .padding(.bottom)
//         .alert(isPresented: $duplicateCategoryAlert) {
//            Alert(title: Text("Alert"), message: Text("Category names must be unique\nPlease choose another name"), dismissButton: .default(Text("OK")))
//      }
//
//
//      // ===Buttons===
//      HStack(alignment: .center) {
//
//         // Cancel button
//         Button(action: {
//            self.showRenameCategory = false
//            //                 AddCategory.newCategoryName = ""
//         }) {
//            Text("Cancel")
//               .modifier(CancelButton())
//         }.padding(.trailing, 5)
//
//         // Add button
//         Button(action: {
//            self.commit()
//         }) {
//            Text("Add")
//               .bold()
//               .modifier(MainBlueButton())
//         }
//         .padding(.leading, 5)
//
//      }
//      Spacer()
//   }
//   .padding()
//   .environment(\.horizontalSizeClass, .compact)
//   .background(Color("plainSheetBackground").edgesIgnoringSafeArea(.all))
//   .onAppear {
//      //            RenameList.newListName = self.thisList.wrappedName
//   }
//}

struct RenameCategory_Previews: PreviewProvider {
   static var previews: some View {
      
      RenameCategory(thisCategory: uncategorisedCategory()!, showRenameCategory: PreviewValues().$myBinding, categoryName: PreviewValues().$categoryName)
   }
   
}
