//
//  ListMoreOptions.swift
//  iShop
//
//  Created by Chris Filiatrault on 17/8/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

struct ListActionSheet: View {
   
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @Environment(\.editMode)  var editMode
   @Environment(\.presentationMode) var presentationModeNav
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   @Binding var showListOptions: Bool
   @Binding var showRenameList: Bool
   @State var confirmDeleteListAlert: Bool = false
   var thisList: ListOfItems
   var startUp: StartUp
//   var presentationModeNav: Binding<PresentationMode>
   
    var body: some View {
        
      HStack {
      if globalVariables.catalogueShown == false {
         
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
               .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
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
      }
      
    }
}
