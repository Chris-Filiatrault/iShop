////
////  RenameCategory.swift
////  iShop
////
////  Created by Chris Filiatrault on 28/8/20.
////  Copyright © 2020 Chris Filiatrault. All rights reserved.
////
//
//
//
//
//// Create renameCategory function
//// Fix up code below as needed
//
//
//
//
//
//import SwiftUI
//import CoreData
//
//struct RenameCategory: View {
//   
//   //   @EnvironmentObject var globalVariables: GlobalVariableClass
//   
//   @FetchRequest(entity: Category.entity(), sortDescriptors: [
//      NSSortDescriptor(key: "name", ascending: true, selector:  #selector(NSString.localizedCaseInsensitiveCompare(_:)))
//   ] ,predicate: NSPredicate(format: "NOT name IN %@", ["Uncategorised", "In Cart"])) var categories: FetchedResults<Category>
//   
//   
//   var thisCategory: Category
//   
//   
//   @Binding var showRenameCategory: Bool
//   @Binding var duplicateCategoryAlert: Bool
//   @Binding var categoryName: String
//   
//   static var focusTextfield: Bool = true
//   static var renamedCategoryName: String = ""
//   static var renamedCategoryNameBinding = Binding<String>(get: { renamedCategoryName }, set: { renamedCategoryName = $0 } )
//   
//   
//   
//   var body: some View {
//      VStack {
//         
//         Text("Category Details")
//            .bold()
//            .font(.largeTitle)
//            .padding(.top, 50)
//         Divider()
//            .padding(.bottom, 30)
//            .offset(y: -15)
//         
//         // ===Rename Category Textfield===
//         CustomTextField("Enter category name",
//                         text: AddCategory.newCategoryNameBinding,
//                         focusTextfieldCursor: false,
//                         onCommit: { self.commit() }
//         )
//            .padding(.bottom)
//            .alert(isPresented: $duplicateCategoryAlert) {
//               Alert(title: Text("Alert"), message: Text("Category names must be unique\nPlease choose another name"), dismissButton: .default(Text("OK")))
//         }
//         
//         
//         // ===Buttons===
//         HStack(alignment: .center) {
//            
//            // Cancel button
//            Button(action: {
//               self.showRenameCategory = false
//               //                 AddCategory.newCategoryName = ""
//            }) {
//               Text("Cancel")
//                  .modifier(CancelButton())
//            }.padding(.trailing, 5)
//            
//            // Add button
//            Button(action: {
//               self.commit()
//            }) {
//               Text("Add")
//                  .bold()
//                  .modifier(MainBlueButton())
//            }
//            .padding(.leading, 5)
//            
//         }
//         Spacer()
//      }
//      .padding()
//      .environment(\.horizontalSizeClass, .compact)
//      .background(Color("plainSheetBackground").edgesIgnoringSafeArea(.all))
//      .onAppear {
//         //            RenameList.newListName = self.thisList.wrappedName
//      }
//   }
//   
//   
//   
//   /// Setting `focusTextfield = false` prevents the navigation link from glitching after the view is dismissed
//   func setFocusTextfieldToFalse() {
//      AddCategory.focusTextfield = false
//   }
//   
//   func commit() {
//      if AddCategory.newCategoryName != "" && categoryNameIsUnique(name: AddCategory.newCategoryName) {
//         //      addCategory(categoryName: AddCategory.newCategoryName, thisItem: self.thisItem)
//         //      self.setFocusTextfieldToFalse()
//         //      self.presentationModeChooseCategory.wrappedValue.dismiss()
//         //      AddCategory.newCategoryName = ""
//      }
//      else if AddCategory.newCategoryName == "" {
//         // Do nothing
//      }
//      else if !categoryNameIsUnique(name: AddCategory.newCategoryName) {
//         //      self.duplicateCategoryAlert = true
//      }
//      else if AddCategory.newCategoryName == "" {
//         //      self.setFocusTextfieldToFalse()
//         //      self.presentationModeChooseCategory.wrappedValue.dismiss()
//      }
//      
//      
//   }
//   
//}
