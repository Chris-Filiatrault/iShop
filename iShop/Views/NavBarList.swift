//
//  NavBarList.swift
//  iShop
//
//  Created by Chris Filiatrault on 28/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import MessageUI

struct NavBarList: View {
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @Environment(\.editMode)  var editMode
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   @Binding var showListOptions: Bool
   @Binding var showRenameList: Bool
   @State var confirmDeleteListAlert: Bool = false
   var thisList: ListOfItems
   var startUp: StartUp
   var presentationModeNav: Binding<PresentationMode>
   let uncategorised = uncategorisedCategory()
   let inCart = inCartCategory()
   
   var body: some View {
      
      HStack {
         if globalVariables.catalogueShown == false {
            if UserDefaults.standard.string(forKey: "syncSortItemsBy") == "Manual" && UserDefaultsManager().useCategories == false {
            EditButton()
            }
            
            // More options button
            Button(action: {
               self.showListOptions.toggle()
               withAnimation {
                  self.editMode?.wrappedValue = .inactive
               }
            }) {
               Image(systemName: "ellipsis.circle")
                  .imageScale(.large)
                  .foregroundColor(Color("navBarFont"))
                  .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
            }.padding(.vertical, 10)
          
               // === Action sheet ===
               .actionSheet(isPresented: self.$showListOptions) {
                  ActionSheet(title: Text("Options"), buttons: [
                     .destructive(Text("Delete List")) {
                        self.confirmDeleteListAlert.toggle()
                     },
                     .default(Text("Delete All Items")) {
                        clearList(thisList: self.thisList)
                     },
                     .default(Text("Rename List")) {
                        self.showRenameList.toggle()
                     },
                     .default(Text("Send Via Text")) {
                        self.startUp.presentMessageCompose(
                           messageBody:
                           self.userDefaultsManager.useCategories == true ?
                           listItemsWithCategoriesAsString(thisList: self.thisList) :
                           listItemsWithoutCategoriesAsString(thisList: self.thisList)
                        )
                     },
                     .default(Text("Copy Items")) {
                        let pasteboard = UIPasteboard.general
                        pasteboard.string =
                           self.userDefaultsManager.useCategories == true ?
                           listItemsWithCategoriesAsString(thisList: self.thisList) :
                           listItemsWithoutCategoriesAsString(thisList: self.thisList)

                        successHapticFeedback(enabled: self.userDefaultsManager.hapticFeedback)
                     },
                     .cancel(Text("Cancel"))])
            }
            .alert(isPresented: $confirmDeleteListAlert) {
               Alert(title: Text("Delete List?"),
                     message: Text("This can't be undone."),
                     primaryButton: .default(Text("Cancel")),
                     secondaryButton: .destructive(Text("Delete")) {
                        self.presentationModeNav.wrappedValue.dismiss()
                        deleteList(thisList: self.thisList)
                        if !isFirstTimeLaunch() && userHasNoLists() {
                           addList(listName: "Groceries")
                        }
                  }
               )
            }
            
         }
            
            // Done button
         else if globalVariables.catalogueShown == true && globalVariables.itemInTextfield.count == 0 {
            Button(action: {
               withAnimation {
                  UIApplication.shared.endEditing()
                  self.globalVariables.catalogueShown = false
               }
            }) {
               Text("Done")
                  .font(.headline)
                  .foregroundColor(Color("navBarFont"))
            }
         }
            
            // Add button
         else if globalVariables.catalogueShown == true && globalVariables.itemInTextfield.count > 0 {
            Button(action: {
//               UIApplication.shared.endEditing()
               if self.globalVariables.itemInTextfield != "" {
                  addNewItem(itemName: self.$globalVariables.itemInTextfield, listOrigin: self.thisList)
                  self.globalVariables.itemInTextfield = ""
               }
               self.globalVariables.itemInTextfield = ""
            }) {
               Text("Add")
                  .font(.headline)
                  .foregroundColor(Color("navBarFont"))
            }
         }
      }
      
   }
}


