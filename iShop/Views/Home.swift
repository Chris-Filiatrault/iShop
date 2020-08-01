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
   @Environment(\.presentationMode) var presentationMode
   @Environment(\.managedObjectContext) var context
   @EnvironmentObject var globalVariables: GlobalVariableClass
   
   @Binding var navBarFont: UIColor
   @Binding var navBarColor: UIColor
   @State var showSettings: Bool = false
   @State var showAddList: Bool = false
   var startUp: StartUp
   
   @FetchRequest(entity: ListOfItems.entity(), sortDescriptors: [
      NSSortDescriptor(keyPath: \ListOfItems.name, ascending: true)
   ], predicate: NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D"))
   var listsFromFetchRequest: FetchedResults<ListOfItems>
   
   @FetchRequest(entity: Category.entity(), sortDescriptors:[],
                 predicate: NSPredicate(format: "name == %@", "Uncategorised")) var uncategorised: FetchedResults<Category>
   
   
   var body: some View {
      VStack {
         
         // ===List of lists===
         NavigationView {
            List {
               Text(" ")
                  .listRowBackground(Color("listBackground"))
               
               ForEach(listsFromFetchRequest, id: \.self) { list in
                  NavigationLink(destination: ItemList(listFromHomePage: list, startUpPassedIn: self.startUp)
                     .environment(\.managedObjectContext, self.context)
                     .environmentObject(self.globalVariables)
                  ) {
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
               }
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
                        print(isFirstTimeLaunch())
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
                        .environment(\.managedObjectContext, self.context)
                        
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
            .accentColor(Color("navBarFont")) // Back button color
            .navigationViewStyle(StackNavigationViewStyle())
      }
   } // End of body
}


