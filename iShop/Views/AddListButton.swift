//
//  AddListButton.swift
//  iShop
//
//  Created by Chris Filiatrault on 4/8/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

// Separate struct needed for the button, as if the button is inside a navigation view, the call to dismiss edit mode doesn't work
struct AddListButton: View {

   @Environment(\.editMode)  var editMode
   @Binding var showAddList: Bool
   
   let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
   let osVersion = UIDevice.current.systemVersion
   
   var body: some View {
      
      Button(action: {
         
         if UIDevice.current.userInterfaceIdiom == .pad {
            let OS = "iPadOS"
            print(OS + ": " + UIDevice.current.systemVersion)
         }
         else {
            let OS = "iOS"
            print(OS + ": " + UIDevice.current.systemVersion)
         }
         
         self.showAddList = true
         withAnimation {
         self.editMode?.wrappedValue = .inactive
         }
      }) {
         Image(systemName: "plus")
            .imageScale(.large)
            .padding()
            .foregroundColor(Color("navBarFont"))
            .offset(x: 5)
      }
      .sheet(isPresented: $showAddList) {
         AddList(showingAddListBinding: self.$showAddList)
      }
      
   }
}


