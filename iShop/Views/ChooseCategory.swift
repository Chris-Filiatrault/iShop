//
//  ChooseCategory.swift
//  iShop
//
//  Created by Chris Filiatrault on 12/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//
import SwiftUI
import CoreData

struct ChooseCategory: View {
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @Environment(\.presentationMode) var presentationMode
   @Environment(\.managedObjectContext) var context
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   @Environment(\.editMode) var editMode
   
   @FetchRequest(entity: Category.entity(), sortDescriptors: [
      NSSortDescriptor(key: "name", ascending: true, selector:  #selector(NSString.localizedCaseInsensitiveCompare(_:)))
   ] ,predicate: NSPredicate(format: "NOT name IN %@", ["Uncategorised", "In Cart"])) var categories: FetchedResults<Category>

   
   var thisItem: Item
   
   @State var showRenameCategory: Bool = false
   @State var deleteCategoryAlert: Bool = false
   @State var categoryBeingRenamed: Category? = nil
   @State var deletedCategory: Category? = nil
   @State var isLoading: Bool = false
   
   @Binding var oldItemCategory: Category
   @Binding var newItemCategory: Category
   @Binding var categoryName: String
   @Binding var textfieldActive: Bool
   
   var body: some View {
      
         List {
            
            // Add new category
            NavigationLink(destination: AddCategory(thisItem: thisItem, newItemCategory: $newItemCategory, categoryName: $categoryName)) {
               HStack {
                  Text("Add Category")
                     .bold()
               }
            }
            
            
            // Uncategorised (label, not a button)
            if thisItem.categoryOriginName == "Uncategorised" {
               HStack {
                  Text("Uncategorised")
                  Spacer()
                  Image(systemName: "checkmark")
                     .imageScale(.medium)
               }.foregroundColor(.blue)
            }
            
            // List of categories
            ForEach(self.categories) { category in
               Button(action: {
                  self.newItemCategory = category
                  self.categoryName = category.wrappedName
                  self.presentationMode.wrappedValue.dismiss()
               }) {
                  HStack {
                     
                     // Selected category
                     if category.wrappedName == self.thisItem.categoryOriginName {
                        HStack {
                           Text(category.wrappedName)
                           Spacer()
                           Image(systemName: "checkmark")
                              .imageScale(.medium)
                        }
                        .foregroundColor(.blue)
                     }
                     
                     // Non-selected categories
                     else {
                        Text(category.wrappedName)
                           .foregroundColor(.black)
                     }
                     Spacer()
                     
                     // Rename button
                     if self.editMode?.wrappedValue == .active {
                        
                        Divider()
                        
                        Text("Rename")
                           .foregroundColor(Color("blueButton"))
                           .padding(3)
                           .onTapGesture {
                              self.categoryBeingRenamed = category
                              hapticFeedback()
                              RenameCategory.renamedCategoryName = category.wrappedName
                              RenameCategory.focusTextfield = true
                              if self.categoryBeingRenamed != nil {
                                 self.showRenameCategory = true
                              }
                           }
                     }
                  }
               }
            }
            .onDelete(perform: deleteSwipedCategory)
         }
         .listStyle(GroupedListStyle())
         .navigationBarTitle(Text("Category"), displayMode: .inline)
         .navigationBarItems(trailing:
                              EditButton()
                              .padding()
                              .opacity(showRenameCategory == true ? 0 : 1)
         )
      .overlay(
         self.showRenameCategory == true ?
            ZStack {

               Color(.black).edgesIgnoringSafeArea(.all)
                  .opacity(0.3)
               // Rename category is shown if the "Rename" button above successfully assigned a category to categoryBeingRenamed
               RenameCategory(thisItem: self.thisItem, thisCategory: categoryBeingRenamed!, showRenameCategory: $showRenameCategory, categoryName: self.$categoryName)
            }
            : nil
      )
      .alert(isPresented: $deleteCategoryAlert, content: {

         self.deletedCategory == self.thisItem.categoryOrigin ?

            // Deleted category contains thisItem
            Alert(title: Text("Alert"),
                  message: Text("Cannot delete a category containing the current item.\n\nTo delete \(oldItemCategory.wrappedName), first move \(thisItem.wrappedName) to a different category."),
                  dismissButton: .default(Text("Done")))
            :
            // Deleted category doesn't contain thisItem
            Alert(title: Text("Delete Category?"),
                  message: Text("All items in \(deletedCategory?.wrappedName ?? "this category") will be moved to Uncategorised."),
                  primaryButton: .destructive(Text("Delete")) {
                     print("Deleted")
                     if self.deletedCategory != nil {
                        deleteCategory(category: self.deletedCategory!)
                     }
                  }, secondaryButton: .cancel())
      })
         }
         
      
      
   
   
   // ===DELETE (swiped) CATEGORY===
   func deleteSwipedCategory(indices: IndexSet) {
      
      guard let appDelegate =
               UIApplication.shared.delegate as? AppDelegate else {
         return
      }
      
      let managedContext =
         appDelegate.persistentContainer.viewContext
      
      let fetchRequest:NSFetchRequest<Category> = NSFetchRequest.init(entityName: "Category")
      fetchRequest.sortDescriptors = [
         NSSortDescriptor(key: "name", ascending: true, selector:  #selector(NSString.localizedCaseInsensitiveCompare(_:)))
      ]
      fetchRequest.predicate = NSPredicate(format: "NOT name IN %@", ["Uncategorised", "In Cart"])
      
      do {
         let categories = try managedContext.fetch(fetchRequest)
         
         for index in indices {
            
            // Assign the deleted category to deletedCategory, and bring up the deleteCategory alert. What is displayed in the alert and the options available depend on whether thisItem is in the deleted category.
            deletedCategory = categories[index]
            self.deleteCategoryAlert.toggle()
            
         }
         
      } catch let error as NSError {
         print("Could not fetch. \(error), \(error.userInfo)")
      }
   }
   
   
//   func categoryFetchRequest() -> FetchedResults<Category>? {
//      self.isLoading = true
//      guard let appDelegate =
//         UIApplication.shared.delegate as? AppDelegate else {
//            return nil
//      }
//
//      let managedContext =
//         appDelegate.persistentContainer.viewContext
//
//      let fetchRequest:NSFetchRequest<Category> = NSFetchRequest.init(entityName: "Category")
//      fetchRequest.predicate = NSPredicate(format: "NOT name IN %@", ["Uncategorised", "In Cart"])
//
//      do {
//         let categories = try managedContext.fetch(fetchRequest)
//         return categories
//      } catch let error as NSError {
//         print("Could not fetch. \(error), \(error.userInfo)")
//      }
//      self.isLoading = false
//      return nil
//   }
}
