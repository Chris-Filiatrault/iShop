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
   @Binding var oldItemCategory: Category
   @Binding var newItemCategory: Category
   @Binding var categoryName: String
   @Binding var textfieldActive: Bool
   @State var showRenameCategory: Bool = false
   @State var deleteItemCategoryAlert: Bool = false
   @State var deletedCategory: String = ""
   @State var categoryBeingRenamed: Category = uncategorisedCategory()!
   
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

                        Image(systemName: "square.and.pencil")
                           .imageScale(.large)
                           .foregroundColor(.black)
                           .padding(7)
                           .onTapGesture {
                              RenameCategory.renamedCategoryName = category.wrappedName
                              hapticFeedback(enabled: self.userDefaultsManager.hapticFeedback)
                                 self.categoryBeingRenamed = category
                              self.showRenameCategory = true
                        }
                        
//                        .sheet(isPresented: self.$showRenameCategory){
//                           RenameCategory(thisCategory: category, showRenameCategory: self.$showRenameCategory, categoryName: self.$categoryName)
//                                    .environment(\.managedObjectContext, self.context)
////                              .onDisappear {
////                                 self.editMode?.wrappedValue = .inactive
////                           }
//                        }
                     }
                  }
               }
            }
            .onDelete(perform: deleteSwipedCategory)
         }
      }
         
         Color(.black)
            .edgesIgnoringSafeArea(.all)
            .opacity(showRenameCategory == true ? 0.2 : 0)
      }
//      .brightness(showRenameCategory == true ? -0.2 : 0)
      .overlay(
         self.showRenameCategory == true ?
         RenameCategory(thisCategory: categoryBeingRenamed, showRenameCategory: $showRenameCategory, categoryName: self.$categoryName)
         : nil
      )
      .navigationBarTitle(Text("Category"), displayMode: .inline)
      .navigationBarItems(trailing:
         EditButton()
            .padding()
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

