////
////  SettingsHaptics.swift
////  iShop
////
////  Created by Chris Filiatrault on 5/8/20.
////  Copyright © 2020 Chris Filiatrault. All rights reserved.
////
//
//
//
//import SwiftUI
//import CoreData
//
//struct SettingsHaptics: View {
//   @Environment(\.presentationMode) var presentationModeHaptics: Binding<PresentationMode>
//   
//   @ObservedObject var userDefaultsManager = UserDefaultsManager()
//   
//   
////   @State var showSettings: Bool = true
//   
//   var body: some View {
//         
//         VStack {
//            List {
//               NavigationLink(destination: AddCategory(thisItem: thisItem, newItemCategory: $newItemCategory, categoryName: $categoryName)) {
//                  HStack {
//                     Text("Add new")
//                        .bold()
//                  }
//               }
//               if thisItem.categoryOrigin?.wrappedName == "Uncategorised" {
//                  HStack {
//                     Text("Uncategorised")
//                     Spacer()
//                     Image(systemName: "checkmark")
//                        .imageScale(.medium)
//                  }.foregroundColor(.blue)
//               }
//               ForEach(self.categories, id: \.self) { category in
//                  Button(action: {
//                     self.newItemCategory = category
//                     self.categoryName = category.wrappedName
//                     self.presentationModeHaptics.wrappedValue.dismiss()
//                  }) {
//                     HStack {
//                        if category.wrappedName == self.thisItem.categoryOrigin!.wrappedName {
//                           HStack {
//                              Text(category.wrappedName)
//                              Spacer()
//                              Image(systemName: "checkmark")
//                                 .imageScale(.medium)
//                           }.foregroundColor(.blue)
//                        }
//                        else {
//                           Text(category.wrappedName)
//                              .foregroundColor(.black)
//                        }
//                     }
//                  }
//               }
//               .onDelete(perform: deleteSwipedCategory)
//            }
//         }
//      .navigationBarTitle(Text("Category"), displayMode: .inline)
//      .navigationBarItems(trailing:
//         EditButton()
//            .padding()
//      )
//      
//   }
//   // ===DELETE (swiped) CATEGORY===
//   func deleteSwipedCategory(indices: IndexSet) {
//      
//      guard let appDelegate =
//         UIApplication.shared.delegate as? AppDelegate else {
//            return
//      }
//      
//      let managedContext =
//         appDelegate.persistentContainer.viewContext
//      
//      let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Category")
//      fetchRequest.sortDescriptors = [
//         NSSortDescriptor(keyPath: \Category.name, ascending: true)
//      ]
//      fetchRequest.predicate = NSPredicate(format: "NOT name IN %@", ["Uncategorised", "In Cart"])
//      
//      let uncategorisedFetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Category")
//      uncategorisedFetchRequest.predicate = NSPredicate(format: "name == %@", "Uncategorised")
//      
//      
//      do {
//         let fetchReturn = try managedContext.fetch(fetchRequest) as! [Category]
//         let uncategorisedFetchReturn = try managedContext.fetch(uncategorisedFetchRequest) as! [Category]
//         
//         if uncategorisedFetchReturn != [] {
//            let uncategorised = uncategorisedFetchReturn[0]
//            
//            for index in indices {
//               let categoryToBeDeleted = fetchReturn[index]
//               for item in categoryToBeDeleted.itemsInCategoryArray {
//                  item.categoryOrigin = uncategorised
//               }
//               managedContext.delete(categoryToBeDeleted)
//            }
//            self.categoryName = "Uncategorised"
//         }
//         
//         do {
//            try managedContext.save()
//            print("Deleted category successfully")
//         } catch let error as NSError {
//            print("Could not delete. \(error), \(error.userInfo)")
//         }
//         
//      } catch let error as NSError {
//         print("Could not fetch. \(error), \(error.userInfo)")
//      }
//   }
//}
