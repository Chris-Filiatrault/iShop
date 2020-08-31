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
   
   @Environment(\.editMode) var editMode
   
   @FetchRequest(entity: Category.entity(), sortDescriptors: [
      NSSortDescriptor(key: "name", ascending: true, selector:  #selector(NSString.localizedCaseInsensitiveCompare(_:)))
   ] ,predicate: NSPredicate(format: "NOT name IN %@", ["Uncategorised", "In Cart"])) var categories: FetchedResults<Category>
   
   
   var thisItem: Item
   var thisCategory: Category
   
   @State var duplicateCategoryAlert: Bool = false
   @State var opacityValue: Double = 0
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
            CustomTextField("",
                            text: RenameCategory.renamedCategoryNameBinding,
                            focusTextfieldCursor: RenameCategory.focusTextfield,
                            onCommit: { self.commit() }
            )
            .padding(.bottom, 5)
            
            Divider()
               .padding(.horizontal, -25)
               .offset(y: 5)
               .alert(isPresented: $duplicateCategoryAlert) {
                  Alert(title: Text("Alert"), message: Text("Category names must be unique\nPlease choose another name"), dismissButton: .default(Text("OK")) {
                     RenameCategory.focusTextfield = true
                     })
                  
            }
            
            // ===Buttons===
            HStack(alignment: .center) {
               
               Spacer()
               
               // Cancel button
               Button(action: {
                  self.showRenameCategory = false
                  RenameCategory.renamedCategoryName = ""
                  UIApplication.shared.endEditing()
                  self.editMode?.wrappedValue = .inactive
               }) {
                  ZStack {
                     Rectangle()
                        .hidden()
                  Text("Cancel")
                     .padding(15)
                     
                  }
               }.padding(.trailing, 5)
               
               Spacer()
               Divider()
               Spacer()
               
               // Add button
               Button(action: {
                  self.commit()
               }) {
                  ZStack {
                     Rectangle()
                        .hidden()
                        
                  Text("Rename")
                     .bold()
                     .padding(15)
                  }
               }
               .padding(.leading, 5)
               
               Spacer()
            }
         }
         .padding(EdgeInsets(top: 15, leading: 25, bottom: 0, trailing: 25))
         .onAppear {
            RenameCategory.renamedCategoryName = self.thisCategory.wrappedName
            RenameCategory.focusTextfield = true
         }
         .onDisappear {
            RenameCategory.focusTextfield = false
         }
         
      }.frame(width: deviceIsiPhoneSE() ? 300 : 350,
              height: 150)
         // Bring up the alert so it doesn't get in the way of the keyboard (bring it up higher on iPad)
         .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? -110 : -200)
   }
   
   
   
   /// Setting `focusTextfield = false` prevents the navigation link from glitching after the view is dismissed
   func setFocusTextfieldToFalse() {
      RenameCategory.focusTextfield = false
   }
   
   func commit() {
      
      // Changes made
      if RenameCategory.renamedCategoryName != "" && categoryNameIsUnique(name: RenameCategory.renamedCategoryName) {
         
         // change the string category name shown in the picker preview
         if thisItem.categoryOriginName == thisCategory.wrappedName {
            self.categoryName = RenameCategory.renamedCategoryName
         }
         
         // rename in core data
         renameCategory(currentName: thisCategory.wrappedName, newName: RenameCategory.renamedCategoryName)
               self.setFocusTextfieldToFalse()
         RenameCategory.renamedCategoryName = ""
         UIApplication.shared.endEditing()
         self.editMode?.wrappedValue = .inactive
         showRenameCategory = false
      }
         
      // Blank string
      else if RenameCategory.renamedCategoryName == "" {
         // Do nothing
      }
      
      // No changes made
      else if RenameCategory.renamedCategoryName == thisCategory.wrappedName {
            RenameCategory.renamedCategoryName = ""
            UIApplication.shared.endEditing()
            self.editMode?.wrappedValue = .inactive
            showRenameCategory = false

      }
      
      // New name not unique
      else if !categoryNameIsUnique(name: RenameCategory.renamedCategoryName) && RenameCategory.renamedCategoryName != thisCategory.wrappedName {
         self.duplicateCategoryAlert = true // dismiss keyboard, otherwise the user can't dismiss the alert on devices with small screens
         self.setFocusTextfieldToFalse()
      }
      
   }
   
}


struct RenameCategory_Previews: PreviewProvider {
   static var previews: some View {
      ZStack {
      Color(.black)
         RenameCategory(thisItem: itemForCanvasPreview()!, thisCategory: uncategorisedCategory()!, showRenameCategory: PreviewValues().$myBinding, categoryName: PreviewValues().$categoryName)
   }
   }

}
