//
//  NavBarItems.swift
//  iShop
//
//  Created by Chris Filiatrault on 28/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import MessageUI

struct NavBarItems: View {
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @Binding var showMoreOptions: Bool
   @Binding var showRenameList: Bool
   var thisList: ListOfItems
   var startUp: StartUp
   
    var body: some View {
        HStack {
              if globalVariables.catalogueShown == false {
                 // More options button
                 Button(action: {
                    self.showMoreOptions.toggle()
                 }) {
                    Image(systemName: "ellipsis.circle")
                       .imageScale(.large)
                       .foregroundColor(Color("navBarFont"))
                       .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
                 }.padding(.vertical, 10)
                       
                 // === Action sheet ===
                 .actionSheet(isPresented: self.$showMoreOptions) {
                    ActionSheet(title: Text("Options"), buttons: [
                       .destructive(Text("Delete All Items")) {
                          clearList(thisList: self.thisList)
                       },
                       .default(Text("Rename List")) {
                          self.showRenameList.toggle()
                       },
                       .default(Text("Send Via Text")) {
                        self.startUp.presentMessageCompose(messageBody: listContentString(thisList: self.thisList))
                        
                       },
                    .cancel(Text("Cancel"))])
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
                    UIApplication.shared.endEditing()
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


