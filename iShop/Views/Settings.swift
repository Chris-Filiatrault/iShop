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
   
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   
   @FetchRequest(entity: ListOfItems.entity(), sortDescriptors: [
      NSSortDescriptor(keyPath: \ListOfItems.name, ascending: true)
   ], predicate: NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D"))
   var lists: FetchedResults<ListOfItems>
   
   let sortOptions: [String] = ["Alphabetical", "Manual"]
   
   @State var result: Result<MFMailComposeResult, Error>? = nil
   @State var isShowingMailView = false
   @State var alertNoMail = false
   @State var disableAutocorrect: Bool = false
   @State var sortItemsBy: String = UserDefaults.standard.string(forKey: "syncSortItemsBy") ?? "Alphabetical"
   @State var sortListsBy: String = UserDefaults.standard.string(forKey: "syncSortListsBy") ?? "Alphabetical"
   
   @Binding var showSettingsBinding: Bool
   
   var body: some View {
      
      NavigationView {
         VStack {
            
            Form {
               
               // ===GENERAL===
               Section(header: Text("GENERAL")) {
                  
                  // Autocorrect
                  Toggle(isOn: $userDefaultsManager.disableAutoCorrect) {
                     Text("Disable Autocorrect")
                  }
                  
                  // Review
                  // UNCOMMENT IN FIRST POST-RELEASE UPDATE
                  //                  if UserDefaults.standard.integer(forKey: "syncNumTimesUsed") > 10 {
                  //                     Button(action: {
                  //                        //                        UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/id1518384911#?platform=iphone")!)
                  //                     }) {
                  //                        Text("Review on App Store")
                  //                           .foregroundColor(.black)
                  //                     }
                  //                  }
                  
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
               
               // ===LIST OPTIONS===
               Section(header: Text("LIST OPTIONS")) {
                  
                  // Use categories
                  Toggle(isOn: $userDefaultsManager.useCategories) {
                     Text("Use Categories")
                  }
                  
                  // Item Order
                  if userDefaultsManager.useCategories == true {
                     Picker(selection: self.$sortItemsBy, label: Text("Item Order")) {
                        HStack {
                           Text("Alphabetical")
                           Spacer()
                           Image(systemName: "checkmark")
                              .foregroundColor(.blue)
                              .imageScale(.medium)
                              .font(.headline)
                        }
                        HStack {
                           Text("To sort items manually, disable") +
                              Text(" Use Categories ").bold() +
                              Text("in Settings.")
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.vertical, 5)
                        
                     }
                  } else {
                     Picker(selection: self.$sortItemsBy, label: Text("Item Order")) {
                        ForEach(self.sortOptions, id: \.self) { option in
                           Text(option)
                        }
                        Text("To manually sort items, select Manual above, then press the Edit button in any list.")
                           .font(.subheadline)
                           .foregroundColor(.gray)
                           .padding(.vertical, 5)
                     }
                  }
                  
                  
                  // List Order
                  Picker(selection: self.$sortListsBy, label: Text("List Order")) {
                     ForEach(self.sortOptions, id: \.self) { option in
                        Text(option)
                     }
                     Text("To manually sort lists, select Manual above, then press the Edit button on the home page.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.vertical, 5)
                  }
                  
                  
                  
               }
               
            }
            .padding(.top, 15)
               
               // === Nav bar ===
               .navigationBarTitle("Settings", displayMode: .inline)
               .navigationBarItems(trailing:
                  Button(action: {
                     self.showSettingsBinding.toggle()
                     
                     if self.sortItemsBy == "Manual" && UserDefaults.standard.string(forKey: "syncSortItemsBy") == "Alphabetical" {
                        print("Change order")
                     }
                     
                     if self.sortListsBy == "Manual" && UserDefaults.standard.string(forKey: "syncSortListsBy") == "Alphabetical" {
                        print("Change order")
                        sortListPositionsAlphabetically()
                     }
                     UserDefaults.standard.set(self.sortItemsBy, forKey: "syncSortItemsBy")
                     UserDefaults.standard.set(self.sortListsBy, forKey: "syncSortListsBy")
                     
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
