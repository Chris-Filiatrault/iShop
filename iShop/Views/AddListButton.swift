//
//  AddListButton.swift
//  iShop
//
//  Created by Chris Filiatrault on 4/8/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

/// Separate struct needed for the button, as if the button is inside a navigation view, the call to dismiss edit mode doesn't work
struct AddListButton: View {
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @Environment(\.editMode)  var editMode
   @Binding var showAddList: Bool
   
   var body: some View {
      
      Button(action: {
         AddList.focusTextfield = true
         self.showAddList = true
         withAnimation {
            self.editMode?.wrappedValue = .inactive
         }
      }) {
         HStack {
            if globalVariables.userIsOnMac {
               Text("➕")

            } else {
               Image(systemName: "plus")
                  .imageScale(.large)
            }
         }
         .padding()
         .foregroundColor(Color("navBarFont"))
         .offset(x: 5)
      }
      .sheet(isPresented: $showAddList) {
         AddList(showingAddListBinding: self.$showAddList)
      }
      
   }
}


