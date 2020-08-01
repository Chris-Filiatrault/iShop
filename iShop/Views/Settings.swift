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
   
   @FetchRequest(entity: ListOfItems.entity(), sortDescriptors: [
      NSSortDescriptor(keyPath: \ListOfItems.name, ascending: true)
   ], predicate: NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D"))
   var lists: FetchedResults<ListOfItems>
   
   @Binding var showSettingsBinding: Bool
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   @State var result: Result<MFMailComposeResult, Error>? = nil
   @State var isShowingMailView = false
   @State var alertNoMail = false
   @State var disableAutocorrect: Bool = false
   let sortOptions: [String] = ["Alphabetical", "Manual"]
   @State var currentSortListOption: String = UserDefaults.standard.string(forKey: "syncSortListBy") ?? "Manual"
   
   var body: some View {
      
      NavigationView {
         VStack {
            
            Form {
               
               // General
               Section(header: Text("GENERAL")) {
                  
                  // Autocorrect
                  Toggle(isOn: $userDefaultsManager.disableAutoCorrect) {
                     Text("Disable Autocorrect")
                  }
                  
                  // Review
                  if UserDefaults.standard.integer(forKey: "syncNumTimesUsed") > 10 {
                     Button(action: {
                        //                        UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/id1518384911#?platform=iphone")!)
                     }) {
                        Text("Review on App Store")
                           .foregroundColor(.black)
                     }
                  }
                  
                  // Contact
                  Button(action: {
                     MFMailComposeViewController.canSendMail() ? self.isShowingMailView.toggle() : self.alertNoMail.toggle()
                  }) {
                     HStack {
                        Text("Send Feedback")
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
               
               // List options
               Section(header: Text("LIST OPTIONS")) {
                  
                  // Use categories
                  Toggle(isOn: $userDefaultsManager.useCategories) {
                     Text("Use Categories")
                  }
                  
                  // Item Order
                     
                  if userDefaultsManager.useCategories == true {
                  Picker(selection: self.$currentSortListOption, label: Text("Item Order")) {
                     HStack {
                        Text("Alphabetical")
                        Spacer()
                        Image(systemName: "checkmark")
                           .foregroundColor(.blue)
                           .imageScale(.medium)
                           .font(.headline)
                     }
                     Text("When categories are turned off, you can also choose to sort items manually.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.vertical, 5)

                  }
                  } else {
                     Picker(selection: self.$currentSortListOption, label: Text("Item Order")) {
                           ForEach(self.sortOptions, id: \.self) { option in
                              Text(option)
                        }
                     }
                  }
                  
                  
                  
               }
               
            }
            .padding(.top, 15)
               
               // === Nav bar ===
               .navigationBarTitle("Settings", displayMode: .inline)
               .navigationBarItems(trailing:
                  Button(action: {
                     self.showSettingsBinding.toggle()
                     UserDefaults.standard.set(self.currentSortListOption, forKey: "syncSortListBy")
                     
                  }) {
                     Text("Done")
                        .font(.headline)
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 5))
               })
         }
         .background(Color("listBackground").edgesIgnoringSafeArea(.all))
         
         
         
      } // End of VStack
         .environment(\.horizontalSizeClass, .compact)
   }
}


//// -----Test code-----
//Button(action: {
//   // ==========TEST CODE GOES HERE==========
//}) { Rectangle()
//   .foregroundColor(.white)
//   .frame(width: 300, height: 200)
//}
