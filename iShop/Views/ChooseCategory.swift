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
   @State var deleteItemCategoryAlert: Bool = false
   @State var deletedCategory: String = ""
   @State var categoryBeingRenamed: Category? = nil
   
   @Binding var oldItemCategory: Category
   @Binding var newItemCategory: Category
   @Binding var categoryName: String
   @Binding var textfieldActive: Bool
   
   var body: some View {
      
      ZStack {
         VStack {
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
                                 hapticFeedback(enabled: self.userDefaultsManager.hapticFeedback)
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
         }
         
         // Makes the screen dim when RenameCategory is shown
         Color(.black)
            .edgesIgnoringSafeArea(.all)
            .opacity(showRenameCategory == true ? 0.25 : 0)
      }
         
      .overlay(
         self.showRenameCategory == true ?
            // Rename category is shown if the "Rename" button above successfully assigned a category to categoryBeingRenamed
            RenameCategory(thisItem: self.thisItem, thisCategory: categoryBeingRenamed!, showRenameCategory: $showRenameCategory, categoryName: self.$categoryName)
            : nil
      )
         .navigationBarTitle(Text("Category"), displayMode: .inline)
         .navigationBarItems(trailing:
            EditButton()
               .padding()
               .opacity(showRenameCategory == true ? 0 : 1)
      )
               
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
      
      let uncategorisedFetchRequest:NSFetchRequest<Category> = NSFetchRequest.init(entityName: "Category")
      uncategorisedFetchRequest.predicate = NSPredicate(format: "name == %@", "Uncategorised")
      
      do {
         let categories = try managedContext.fetch(fetchRequest)
         let uncategorisedFetchReturn = try managedContext.fetch(uncategorisedFetchRequest)
         
         if uncategorisedFetchReturn != [] {
            let uncategorised = uncategorisedFetchReturn[0]
            
            for index in indices {
               
               let categoryToBeDeleted = categories[index]
               
               if categoryToBeDeleted == self.oldItemCategory {
                  self.oldItemCategory = uncategorised
                  self.newItemCategory = uncategorised
                  //                  self.deletedCategory = categoryToBeDeleted.wrappedName
                  //                  self.deleteItemCategoryAlert.toggle()
                  //                  return
               }
               
               for category in categories {
                  if category.position > categoryToBeDeleted.position {
                     category.position -= 1
                  }
               }
               for item in categoryToBeDeleted.itemsInCategoryArray {
                  item.categoryOrigin = uncategorised
                  item.categoryOriginName = "Uncategorised"
               }
               
               managedContext.delete(categoryToBeDeleted)
            }
            //            self.categoryName = "Uncategorised"
         }
         
         do {
            try managedContext.save()
         } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
         }
         
      } catch let error as NSError {
         print("Could not fetch. \(error), \(error.userInfo)")
      }
   }
}

