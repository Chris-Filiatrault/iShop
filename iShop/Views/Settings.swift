//
//  Settings.swift
//  iShop
//
//  Created by Chris Filiatrault on 4/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

struct Settings: View {
   @State var model = ToggleModel()
   @Binding var showSettingsBinding: Bool
   @State var disableAutocorrect: Bool = false
   @EnvironmentObject var globalVariables: GlobalVariableClass
   
   
   var body: some View {
      VStack {
         NavigationView {
            Form {
               Section(header: Text("General")) {
                  Toggle(isOn: $disableAutocorrect) {
                     Text("Disable autocorrect")
                  }
                  
               }//.listRowBackground(Color(.white))
               }.padding(.top, 15)
               
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(leading:
                  Button(action: {
                     self.showSettingsBinding = false
                  }) {
                     Text("Cancel")
                     .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 15))
                  },
            trailing:
            Button(action: {
               self.showSettingsBinding = false
               
               //print("disableAutocorrect is now: \(self.globalVariables.disableAutoCorrect)")
            }) {
               Text("Done")
                  .font(.headline)
                  .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 5))
               })
         }
         
         
         
         
         
         // ----------
         Button(action: {
            // ==========TEST CODE GOES HERE==========
//            for list in self.lists {
//               print(itemNameIsUnique(name: "Banana", thisList: list))
//            }
            
            
            
            
            
            // ========================================
         }) { Rectangle()
            .foregroundColor(.white)
            .frame(width: 300, height: 200)
         }
         // ----------
         
         
         
         
         
         
      } // End of VStack
         .onAppear() {
            self.disableAutocorrect = self.globalVariables.disableAutoCorrect
      }
      .onDisappear() {
         self.globalVariables.disableAutoCorrect = self.disableAutocorrect
      }
   }
}



struct ToggleModel {
   @EnvironmentObject var globalVariables: GlobalVariableClass
   var isWifiOpen: Bool = true {
        willSet {
            
//         self.globalVariables.disableAutoCorrect.toggle()
         
         
        }
    }
}

struct ToggleDemo: View {
    @State var model = ToggleModel()

    var body: some View {
        Toggle(isOn: $model.isWifiOpen) {
            HStack {
                Image(systemName: "wifi")
                Text("wifi")
            }
       }.accentColor(.pink)
       .padding()
   }
}


