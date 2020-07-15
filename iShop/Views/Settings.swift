//
//  Settings.swift
//  iShop
//
//  Created by Chris Filiatrault on 4/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

struct Settings: View {
   @Binding var showSettingsBinding: Bool
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   
   var body: some View {
      VStack {
         NavigationView {
            
            Form {
               Section(header: Text("General")) {
                  Toggle(isOn: $userDefaultsManager.disableAutoCorrect) {
                     Text("Disable autocorrect")
                  }
               }
            }.padding(.top, 15)
                  
               // === Nav bar ===
               .navigationBarTitle("Settings", displayMode: .inline)
               .navigationBarItems(trailing:
                  Button(action: {
                     self.showSettingsBinding.toggle()
                  }) {
                     Text("Done")
                        .font(.headline)
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 5))
               })
         }
         
         
         
         
         
         // -----Test code-----
         Button(action: {
            // ==========TEST CODE GOES HERE==========
         }) { Rectangle()
            .foregroundColor(.white)
            .frame(width: 300, height: 200)
         }
         
      } // End of VStack
   }
}


