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
   var presentationMode: Binding<PresentationMode>
   
   var body: some View {
      
      HStack {
         
         // More options ellipsis for iPhone
         if UIDevice.current.userInterfaceIdiom != .pad && globalVariables.catalogueShown == false {
            ListActionSheet(showListOptions: self.$showListOptions, showRenameList: self.$showRenameList, thisList: self.thisList, startUp: self.startUp, presentationMode: self.presentationMode)
         }
         
         
         // Done button
         if globalVariables.catalogueShown == true {
            Button(action: {
               withAnimation {
                  UIApplication.shared.endEditing()
                  self.globalVariables.catalogueShown = false
                  self.globalVariables.itemInTextfield = ""
               }
            }) {
               Text(globalVariables.itemInTextfield.count == 0 ? "Done" : "Cancel")
               .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
            }
         }
         
      }
      .font(.headline)
      .foregroundColor(Color("navBarFont"))
      
   }
}


