//
//  SettingsButton.swift
//  iShop
//
//  Created by Chris Filiatrault on 4/8/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

// Separate struct needed for the button, as if the button is inside a navigation view, the call to dismiss edit mode doesn't work
struct SettingsButton: View {
   
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @Environment(\.managedObjectContext) var context
   @Environment(\.editMode)  var editMode
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   @Binding var showSettings: Bool
   var startUp: StartUp
   
    var body: some View {
      
      
      VStack {
           Button(action: {
              self.showSettings = true
            withAnimation {
               self.editMode?.wrappedValue = .inactive 
            }
           }) {
            
            HStack {
            if globalVariables.userIsOnMac {
               Text("Settings")
            } else {
              Image(systemName: "gear")
                 .imageScale(.large)
            }
            }
            .padding()
            .foregroundColor(Color("navBarFont"))
            .offset(x: -5)

           }
        .sheet(isPresented: self.$showSettings){
           Settings(startUp: self.startUp, showSettingsBinding: self.$showSettings)
              .environmentObject(self.globalVariables)
              .environment(\.managedObjectContext, self.context)
               .navigationBarColor(backgroundColor: .clear, fontColor: UIColor.black)
      }
         
      }.environment(\.colorScheme, userDefaultsManager.useDarkMode ? .dark : .light)
   }
}
