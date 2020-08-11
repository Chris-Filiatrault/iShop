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
   @Environment(\.presentationMode) var presentationMode
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
  
   @FetchRequest(entity: Category.entity(), sortDescriptors: [
      NSSortDescriptor(keyPath: \Category.name, ascending: true)
   ],predicate: NSPredicate(format: "NOT name IN %@", ["Uncategorised", "In Cart"])) var categories: FetchedResults<Category>

   
   var thisItem: Item
   @Binding var oldItemCategory: Category
   @Binding var newItemCategory: Category
   @Binding var categoryName: String
   @Binding var textfieldActive: Bool
   @State var showSettings: Bool = true
   @State var deleteItemCategoryAlert: Bool = false
   @State var deletedCategory: String = ""
   
   var body: some View {
      VStack {
         
//         if userDefaultsManager.useCategories == false {
//            VStack {
//               Text("Categories are not being used.\n\nYou can enable categories in the Settings page.")
//                  .padding(.top)
//                  .padding(.top)
//                  .font(.headline)
//                  .lineLimit(nil)
//
////               NavigationLink(destination: Settings(showSettingsBinding: $showSettings)) {
////                  Text("Settings")
////               }
//               Spacer()
//            }
//         }
//         else {
            VStack {
               List {
                  NavigationLink(destination: AddCategory(thisItem: thisItem, newItemCategory: $newItemCategory, categoryName: $categoryName)) {
                     HStack {
                        Text("Add Category")
                           .bold()
                     }
                  }
                  if thisItem.categoryOriginName == "Uncategorised" {
                     HStack {
                        Text("Uncategorised")
                        Spacer()
                        Image(systemName: "checkmark")
                           .imageScale(.medium)
                     }.foregroundColor(.blue)
                  }
                  ForEach(self.categories) { category in
                     Button(action: {
                        self.newItemCategory = category
                        self.categoryName = category.wrappedName
                        self.presentationMode.wrappedValue.dismiss()
                     }) {
                        HStack {
                           if category.wrappedName == self.thisItem.categoryOriginName {
                              HStack {
                                 Text(category.wrappedName)
//                                 Text("\(category.position)")
                                 Spacer()
                                 Image(systemName: "checkmark")
                                    .imageScale(.medium)
                              }
                              .foregroundColor(.blue)
                           }
                           else {
                              Text(category.wrappedName)
                                 .foregroundColor(.black)
//                              Text("\(category.position)")
                           }
                        }
                     }
                  }
                  .onDelete(perform: deleteSwipedCategory)
               }
            }
            .alert(isPresented: $deleteItemCategoryAlert) {
               Alert(title: Text(""), message: Text("To delete \(self.deletedCategory), first move \(thisItem.wrappedName) to a different category."), dismissButton: .default(Text("OK")))
         }
//         }
      }
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
         NSSortDescriptor(keyPath: \Category.name, ascending: true)
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
                  self.deletedCategory = categoryToBeDeleted.wrappedName
                  self.deleteItemCategoryAlert.toggle()
                  return
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
