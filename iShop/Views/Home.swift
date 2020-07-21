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
      
   @FetchRequest(entity: ListOfItems.entity(), sortDescriptors: [
      NSSortDescriptor(keyPath: \ListOfItems.name, ascending: true)
   ]) var listsFromFetchRequest: FetchedResults<ListOfItems>
   
   @FetchRequest(entity: Category.entity(), sortDescriptors:[],
                 predicate: NSPredicate(format: "name == %@", "Uncategorised")) var uncategorised: FetchedResults<Category>
   
   
   @State var showSettings: Bool = false
   @State var showAddList: Bool = false
   @State var initialListName: String = "Groceries"
   @State var action: Int? = 0
   @State var onboardingShown = UserDefaults.standard.object(forKey: "onboardingShown") as? Bool ?? nil
   
   
   @State var navBarFont: UIColor = UIColor.white
   @State var navBarColor: UIColor = UIColor(red: 0/255, green: 10/255, blue: 30/255, alpha: 1)
   
   var body: some View {
      VStack {
         if onboardingShown != true {
            ZStack {
               
            OnboardingView(onboardingShown: $onboardingShown, navBarColor: $navBarColor, navBarFont: $navBarFont)
            
            }
         }
         else {
         VStack {
            
            // ===List of lists===
            NavigationView {
               List {
                  Text(" ")
                     .listRowBackground(Color("listBackground"))
                  
                  ForEach(listsFromFetchRequest, id: \.self) { list in
                     NavigationLink(destination: ItemList(listFromHomePage: list)) {
                        HStack {
                        Text(list.wrappedName)
                           .font(.headline)
                           Spacer()
                           if numListUntickedItems(list: list) > 0 {
                              Text("\(numListUntickedItems(list: list))")
                                 .font(.headline)
                                 .padding(.trailing, 5)
                           }
                        }
                        
                     }
                  }.onDelete(perform: deleteSwipedList)
               }
                  
               .background(Color("listBackground").edgesIgnoringSafeArea(.all))
               .navigationBarTitle(Text("Lists"), displayMode: .inline)
                  
                  
               .background(NavigationConfigurator { nc in
                  nc.navigationBar.barTintColor = self.navBarColor
                  nc.navigationBar.titleTextAttributes = [.foregroundColor : self.navBarFont]
               })
                  
                  
                  
                  
                  
                  // ===Nav bar items===
                  .navigationBarItems(
                     
                     // Settings gear button
                     leading:
                     HStack {
                     Button(action: {
                        resetMOC()
                     }) {
                        Text("Del")
                     }
                     
                     Button(action: {
                        self.showSettings = true
                     }) {
                        Image(systemName: "gear")
                           .imageScale(.large)
                           .padding()
                           .foregroundColor(Color("navBarFont"))
                           .offset(x: -5)
                     }
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
         }
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
      
      
      
      // Setup code
      if userHasNoLists() {
      
                     print("Creating new list, items and categories")
                     print("Printing startupCodeRun value: \(SceneDelegate().globalVariables.keyValStore.set(true, forKey: "startupCodeRun"))")
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
         
                     // Groceries list
                        let chemistList = ListOfItems(entity: listEntity, insertInto: managedContext)
                        chemistList.name = "Chemist"
                        chemistList.id = UUID()
                        chemistList.dateAdded = Date()
      
      
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
                     inBasketCategory.defaultCategory = true
      
                     // Uncategorised category
                     let uncategorisedCategory = Category(entity: categoryEntity, insertInto: managedContext)
                     uncategorisedCategory.name = "Uncategorised"
                     uncategorisedCategory.id = UUID()
                     uncategorisedCategory.dateAdded = Date()
                     uncategorisedCategory.defaultCategory = true
      
                     do {
                        try managedContext.save()
                     } catch let error as NSError {
                        print("Could not save items. \(error), \(error.userInfo)")
                     }
   
   
                     SceneDelegate().globalVariables.keyValStore.set(true, forKey: "startupCodeRun")
                     SceneDelegate().globalVariables.keyValStore.synchronize()
         
                  }
                  
      
      
   } // End of init function
   
}
