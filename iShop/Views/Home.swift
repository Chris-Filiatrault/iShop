//
//  ListsView.swift
//  iShop
//
//  Created by Chris Filiatrault on 28/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import CoreData

struct Home: View {
   @Environment(\.presentationMode) var presentationModeHome
   @Environment(\.managedObjectContext) var context
   @EnvironmentObject var globalVariables: GlobalVariableClass
   
   @Binding var navBarFont: UIColor
   @Binding var navBarColor: UIColor
   @State var showSettings: Bool = false
   @State var showAddList: Bool = false
   var startUp: StartUp
   
   @FetchRequest(entity: ListOfItems.entity(), sortDescriptors: [
      NSSortDescriptor(key: "name", ascending: true, selector:  #selector(NSString.localizedCaseInsensitiveCompare(_:)))
   ], predicate: NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D"))
   var listsAlphabetical: FetchedResults<ListOfItems>
   
   @FetchRequest(entity: ListOfItems.entity(), sortDescriptors: [
      NSSortDescriptor(keyPath: \ListOfItems.position, ascending: true)
   ], predicate: NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D"))
   var listsManual: FetchedResults<ListOfItems>
   
   
   var body: some View {
      VStack {
         
         // ===List of lists===
         NavigationView {
            List {
               
               VStack {
                  if listsManual.count == 0 && listsAlphabetical.count == 0 {
                     VStack {
                        Text("\nNo Lists?\nPlease keep the app open, iCloud should sync before long.\n\nIf your lists don't sync within a few minutes you can request support via the Contact button in Settings.\n")
                     }
                  } else {
                     Text(" ")
                  }
               }.listRowBackground(Color("listBackground"))
               
               ForEach(UserDefaults.standard.string(forKey: "syncSortListsBy") == "Manual" ?
                  listsManual : listsAlphabetical) { list in
                     NavigationLink(destination: ItemList(listFromHomePage: list, startUpPassedIn: self.startUp)
                        .environment(\.managedObjectContext, self.context)
                        .environmentObject(self.globalVariables)
                     ) {
                        HStack {
                           Text(list.wrappedName)
                              .font(.headline)
//                           Text("\(list.position)")
                           Spacer()
                           if numListUntickedItems(list: list) > 0 {
                              Text("\(numListUntickedItems(list: list))")
                                 .font(.headline)
                                 .padding(.trailing, 5)
                           }
                        }
                        
                     }
               }
               .onDelete(perform: UserDefaults.standard.string(forKey: "syncSortListsBy") == "Manual" ? deleteSwipedListManual : deleteSwipedListAlphabetical)
               .onMove(perform: moveList)
               
            }
            .background(Color("listBackground").edgesIgnoringSafeArea(.all))
            .navigationBarTitle(Text("Lists"), displayMode: .inline)
               
            .background(NavigationConfigurator { nc in
               nc.navigationBar.barTintColor = self.navBarColor
               nc.navigationBar.titleTextAttributes = [.foregroundColor : self.navBarFont]
            })
               
               // ===Nav bar items===
               .navigationBarItems(
                  
                  leading:
                  HStack {
                     
                     // Reset MOC
                     resetButton()
                     
                     // Settings
                     SettingsButton(showSettings: self.$showSettings, startUp: self.startUp)
                  },
                  // Add list plus button
                  trailing:
                  HStack {
                     
                     if UserDefaults.standard.string(forKey: "syncSortListsBy") == "Manual" {
                        EditButton()
                     }
                     if listsManual.count != 0 && listsAlphabetical.count != 0 {
                        AddListButton(showAddList: self.$showAddList)
                     }
                  }
            )
         }
            // ===Nav bar modifiers===
            .accentColor(Color("navBarFont")) // Back button color
            .navigationViewStyle(StackNavigationViewStyle())
      }
   } // End of body
}




