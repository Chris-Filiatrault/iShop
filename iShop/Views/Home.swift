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
   
   @State var showSettings: Bool = false
   @State var showAddList: Bool = false
   @State var showDeleteListAlert: Bool = false
   @State var deletedList: ListOfItems? = nil
   @Binding var navBarFont: UIColor
   @Binding var navBarColor: UIColor
   
   var startUp: StartUp
   
   @FetchRequest(entity: ListOfItems.entity(), sortDescriptors: [
      NSSortDescriptor(key: "name", ascending: true, selector:  #selector(NSString.localizedCaseInsensitiveCompare(_:)))
   ], predicate: NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D"))
   var listsAlphabetical: FetchedResults<ListOfItems>
   
   var body: some View {
      VStack {
         
         // ===List of lists===
         NavigationView {
            List {
               
               VStack {	
                  if listsAlphabetical.count == 0 {
                     VStack {
                        Text("\nNo Lists?\nPlease keep the app open, iCloud should sync before long.")
                     }
                  }
               }.listRowBackground(Color("listBackground"))
               
               ForEach(listsAlphabetical) { list in
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
               .onDelete(perform: deleteSwipedList)
               
            }
            .background(Color("listBackground").edgesIgnoringSafeArea(.all))
            .navigationBarTitle(Text("Lists"), displayMode: .inline)
            .navigationBarColor(backgroundColor: globalVariables.navBarColor, fontColor: UIColor.white)
            
   
               
               // ===Nav bar items===
               .navigationBarItems(
                  leading:
                  HStack {
//                  resetButton()
                  SettingsButton(showSettings: self.$showSettings, startUp: self.startUp)
                  }
                  ,trailing:
                  HStack {
//                  EditButton()
                  if listsAlphabetical.count != 0 {
                        AddListButton(showAddList: self.$showAddList)
                     }
                  }
            )
         }
            // ===Nav bar modifiers===
            .accentColor(Color("navBarFont")) // Back button color
            .navigationViewStyle(StackNavigationViewStyle())
            .alert(isPresented: $showDeleteListAlert) {
               Alert(title: Text("Delete List?"), message: Text("This can't be undone."), primaryButton: .destructive(Text("Delete")) {
                  if self.deletedList != nil {
                     deleteList(thisList: self.deletedList!)
                  }
                  }, secondaryButton: .cancel())
         }
      }
      .onAppear {
         self.navBarFont = UIColor.white
         self.navBarColor = UIColor(red: 0/255, green: 10/255, blue: 30/255, alpha: 1)
      }
   } // End of body
   
   
   /// Assigns the state variable `deletedList` with the swiped list, and brings up the delete list confirmation alert.
   func deleteSwipedList(indices: IndexSet) {
      for index in indices {
         showDeleteListAlert = true
         self.deletedList = listsAlphabetical[index]
      }
      
   }

   
}

