//
//  Home.swift
//  iShop
//
//  Created by Chris Filiatrault on 2/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//


import SwiftUI
import CoreData

struct Home: View {
   
   @EnvironmentObject var globalVariables: GlobalVariableClass
   
   // Set this to false once some code has been run
   var runCodeOnce: Bool = true
   
   
   
   @FetchRequest(entity: ListOfItems.entity(), sortDescriptors: [
      NSSortDescriptor(keyPath: \ListOfItems.name, ascending: true)
   ]) var listsFromFetchRequest: FetchedResults<ListOfItems>
   
   
   @State var showSettings: Bool = false
   @State var showAddList: Bool = false
   @State var initialListName: String = "Groceries"
   @State var action: Int? = 0
   
   let standardDarkBlueUIColor: UIColor = UIColor(red: 0/255, green: 10/255, blue: 30/255, alpha: 1)
   
   var body: some View {
      VStack {
         
         // ===List of lists===
         
         // ===========HERE===========
         // Try and setup the navigation list as buttons with a shadow, not just boring rows
         NavigationView {
            List {
               Text(" ")
                  .listRowBackground(Color("listBackground"))
               
               ForEach(listsFromFetchRequest, id: \.self) { list in
                  NavigationLink(destination: ItemList(listFromHomePage: list)) {
                     Text(list.wrappedName)
                        .font(.headline)
                     
                  }
               }.onDelete(perform: deleteSwipedList)
            }
               
            .background(Color("listBackground"))
            .edgesIgnoringSafeArea(.bottom)
            .edgesIgnoringSafeArea(.horizontal)
            .navigationBarTitle(Text("Lists"), displayMode: .inline)
               
               
            .background(NavigationConfigurator { nc in
               nc.navigationBar.barTintColor = self.standardDarkBlueUIColor
               nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            })
               
               
               
               
               
               // ===Nav bar items===
               .navigationBarItems(
                  
                  // Settings gear button
                  leading:
                  Button(action: {
                     self.showSettings = true
                  }) {
                     Image(systemName: "gear")
                        .imageScale(.large)
                        .padding()
                        .foregroundColor(Color("navBarFont"))
                        .offset(x: -5)
                  }
                  .sheet(isPresented: self.$showSettings){
                     Settings(showSettingsBinding: self.$showSettings)
                        .environmentObject(self.globalVariables)
                  },
                  
                  // Add list plus button
                  trailing:
                  Button(action: {
                     self.showAddList = true
                     
                  }) {
                     Image(systemName: "plus")
                        .imageScale(.large)
                        .padding()
                        .foregroundColor(Color("navBarFont"))
                        .offset(x: 5)
                  }.sheet(isPresented: $showAddList) {
                     AddList(showingAddListBinding: self.$showAddList)
                  }
            )
         }
            // ===Nav bar modifiers===
            .accentColor(Color("navBarFont"))
            .navigationViewStyle(StackNavigationViewStyle())
         
      }
      
   } // End of body
   
   
   
   // ========================================
   // ========== APP INITIALISATION ==========
   // ========================================
   
   init() {
      
      // To remove all separators in list:
      // UITableView.appearance().separatorStyle = .none
      
      // To remove only extra separators below the list:
      UITableView.appearance().tableFooterView = UIView()
      
      // Remove UITableView background, so it can be programmed using SwiftUI
      UITableView.appearance().backgroundColor = .clear
      
      
      // Create initial lists and items, if the user doesn't have any saved on their phone
      if userHasNoLists() {
         
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
         }
         
         let managedContext = appDelegate.persistentContainer.viewContext
         
         let itemEntity = NSEntityDescription.entity(forEntityName: "Item", in:
            managedContext)!
         
         let listEntity = NSEntityDescription.entity(forEntityName: "ListOfItems", in:
            managedContext)!
         
         let categoryEntity = NSEntityDescription.entity(forEntityName: "Category", in:
            managedContext)!
         
         
         // The startup categories and items below need to have the same number of elements in the array
         // String for categories, [String] for items
         let startupCategories: [String] = ["Fruit", "Vegetables", "Dairy", "Pantry", "Meat", "Snacks", "Skin Care", "Supplements", "Medicine", "Dental", "First aid"]
         
         let startupItems: [[String]] = [
            ["Oranges", "Apples", "Bananas"], // Fruit
            ["Carrots", "Cucumber", "Onion", "Potato"], // Vegetables
            ["Milk", "Cheese", "Eggs"], // Dairy
            ["Coffee", "Bread", "Tea", "Soda", "Cereal", "Beer",  ], // Pantry
            ["Chicken", "Bacon"], // Meat
            ["Chocolate", "Chips"], // Snacks
            ["Sunscreen", "Moisturiser"], // Skin care
            ["Probiotic", "Multivitamin"], // Supplements
            ["Tylenol", "Ibuprofen"], // Medicine
            ["Toothpaste", "Toothbrush", "Mouth guard"], // Dental
            ["Band-aids", "Antiseptic"] // First aid
         ]
         
         
         // Groceries list
         let groceriesList = ListOfItems(entity: listEntity, insertInto: managedContext)
         groceriesList.name = "Groceries"
         groceriesList.id = UUID()
         groceriesList.dateAdded = Date()
         
         
         // Grocery categories & items
         var groceryIndex: Int = 0
         for categoryName in startupCategories {
            let newGroceryCategory = Category(entity: categoryEntity, insertInto: managedContext)
            newGroceryCategory.name = categoryName
            newGroceryCategory.id = UUID()
            newGroceryCategory.dateAdded = Date()
            
            for itemName in startupItems[groceryIndex] {
               
               let item = Item(entity: itemEntity, insertInto: managedContext)
               item.name = itemName
               item.id = UUID()
               item.dateAdded = Date()
               item.addedToAList = false
               item.markedOff = false
               item.quantity = 1
               item.origin = groceriesList
               groceriesList.addToItems(item)
               newGroceryCategory.addToItemsInCategory(item)
            }
            groceryIndex += 1
         }
         
         
         // In Basket category
         let inBasketCategory = Category(entity: categoryEntity, insertInto: managedContext)
         inBasketCategory.name = "In Basket"
         inBasketCategory.id = UUID()
         inBasketCategory.dateAdded = Date()
         
         // Uncategorised category
         let uncategorisedCategory = Category(entity: categoryEntity, insertInto: managedContext)
         uncategorisedCategory.name = "Uncategorised"
         uncategorisedCategory.id = UUID()
         uncategorisedCategory.dateAdded = Date()
         
         
         do {
            try managedContext.save()
         } catch let error as NSError {
            print("Could not save items. \(error), \(error.userInfo)")
         }
      }
      
   } // End of init function
   
}
