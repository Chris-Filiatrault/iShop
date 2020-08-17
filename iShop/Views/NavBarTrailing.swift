//
//  NavBarList.swift
//  iShop
//
//  Created by Chris Filiatrault on 28/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import MessageUI

struct NavBarTrailing: View {
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   @Environment(\.editMode)  var editMode
   var thisList: ListOfItems
   var startUp: StartUp
   @Binding var showListOptions: Bool
   @Binding var showRenameList: Bool
   
   var body: some View {
      
      HStack {
         
         // Edit button
//         if globalVariables.catalogueShown {
//
////            == false && UserDefaults.standard.string(forKey: "syncSortItemsBy") == "Manual" && UserDefaultsManager().useCategories == false {
//
//         }
         
         // More options ellipsis for iPhone
         if UIDevice.current.userInterfaceIdiom != .pad && globalVariables.catalogueShown == false {
            ListActionSheet(showListOptions: self.$showListOptions, showRenameList: self.$showRenameList, thisList: self.thisList, startUp: self.startUp)
         }
         
         
         // Done button
         if globalVariables.catalogueShown == true && globalVariables.itemInTextfield.count == 0 {
            Button(action: {
               withAnimation {
                  UIApplication.shared.endEditing()
                  self.globalVariables.catalogueShown = false
               }
            }) {
               Text("Done")
               .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
            }
         }
            
         // Add button
         else if globalVariables.catalogueShown == true && globalVariables.itemInTextfield.count > 0 && editMode?.wrappedValue == .inactive {
            Button(action: {
               if self.globalVariables.itemInTextfield != "" {
                  addNewItem(itemName: self.$globalVariables.itemInTextfield, listOrigin: self.thisList)
                  self.globalVariables.itemInTextfield = ""
               }
               self.globalVariables.itemInTextfield = ""
            }) {
               Text("Add")
                  .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
            }
         }
      }
      .font(.headline)
      .foregroundColor(Color("navBarFont"))
      
   }
}


