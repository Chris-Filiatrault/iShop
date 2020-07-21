//
//  Settings.swift
//  iShop
//
//  Created by Chris Filiatrault on 4/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import MessageUI

struct Settings: View {
   @Binding var showSettingsBinding: Bool
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   @State var result: Result<MFMailComposeResult, Error>? = nil
   @State var isShowingMailView = false
   @State var alertNoMail = false
   
   @State var disableAutocorrect: Bool = false
   
   var body: some View {
      
      NavigationView {
         VStack {
            
            Form {
               
               // General
               Section(header: Text("GENERAL")) {
                  Toggle(isOn: $disableAutocorrect) {
                     Text("Disable autocorrect")
                  }

                  Button(action: {
                  MFMailComposeViewController.canSendMail() ? self.isShowingMailView.toggle() : self.alertNoMail.toggle()
                  }) {
                     HStack {
                        Text("Send feedback")
                        .foregroundColor(.black)
                     Image(systemName: "envelope")
                        .foregroundColor(.gray)
                     }
                  }
                     
                  .sheet(isPresented: $isShowingMailView) {
                     MailView(result: self.$result)
                  }
                  .alert(isPresented: self.$alertNoMail) {
                      Alert(title: Text("Can't send mail on this device."))
                  }

               }
            }
            .padding(.top, 15)

               // === Nav bar ===
               .navigationBarTitle("Settings", displayMode: .inline)
               .navigationBarItems(trailing:
                  Button(action: {
                     self.showSettingsBinding.toggle()
                     self.globalVariables.keyValStore.set(self.disableAutocorrect, forKey: "disableAutocorrect")
                     self.globalVariables.keyValStore.synchronize()
                  }) {
                     Text("Done")
                        .font(.headline)
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 5))
               })
         }
         
         

      } // End of VStack
      .environment(\.horizontalSizeClass, .compact)
         .onAppear {
            self.disableAutocorrect = self.globalVariables.keyValStore.bool(forKey: "disableAutocorrect")
      }
   }
}


//// -----Test code-----
//Button(action: {
//   // ==========TEST CODE GOES HERE==========
//}) { Rectangle()
//   .foregroundColor(.white)
//   .frame(width: 300, height: 200)
//}
