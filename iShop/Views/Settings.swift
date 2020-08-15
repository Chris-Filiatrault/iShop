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
   @Environment(\.editMode)  var editMode
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   @FetchRequest(entity: ListOfItems.entity(), sortDescriptors: [
      NSSortDescriptor(keyPath: \ListOfItems.name, ascending: true)
   ], predicate: NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D"))
   var lists: FetchedResults<ListOfItems>
   
   let sortOptions: [String] = ["Alphabetical", "Manual"]
//   let hapticFeedbackOptions: [String] = ["On", "Off"]
   var startUp: StartUp
   
   @State var result: Result<MFMailComposeResult, Error>? = nil
   @State var isShowingMailView = false
   @State var alertNoMail = false
   @State var disableAutocorrect: Bool = false
//   @State var hapticFeedbackSelection: String = UserDefaults.standard.string(forKey: "syncHapticFeedback") ?? "On"
   @State var sortItemsBy: String = UserDefaults.standard.string(forKey: "syncSortItemsBy") ?? "Manual"
   @State var sortListsBy: String = UserDefaults.standard.string(forKey: "syncSortListsBy") ?? "Alphabetical"
   @State var navBarFont: UIColor = UIColor.white
   @State var navBarColor: UIColor = UIColor(red: 0/255, green: 10/255, blue: 30/255, alpha: 1)
   @State var onboardingShownFromSettings: Bool = false
   
   @Binding var showSettingsBinding: Bool
   
   var body: some View {
      
      NavigationView {
         VStack {
            
            Form {
               
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
                           Text("Items are sorted alphabetically when using categories. To sort items manually, disable") +
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
                        HStack {
                        Text("To manually sort items, select") +
                           Text(" Manual ").bold() +
                        Text("above, then press the") +
                           Text(" Edit ").bold() +
                        Text("button in any list.")
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.vertical, 5)                     }
                  }
                  
                  // List Order
                  Picker(selection: self.$sortListsBy, label: Text("List Order")) {
                     ForEach(self.sortOptions, id: \.self) { option in
                        Text(option)
                     }
                     HStack {
                     Text("To manually sort lists, select") +
                        Text(" Manual ").bold() +
                     Text("above, then press the") +
                        Text(" Edit ").bold() +
                     Text("button on the home page.")
                     }
                     .font(.subheadline)
                     .foregroundColor(.gray)
                     .padding(.vertical, 5)
                  }
               }
               
               // ===GENERAL===
               Section(header: Text("GENERAL")) {
                  
                  // Keep screen on
                  Toggle(isOn: $userDefaultsManager.keepScreenOn) {
                     Text("Keep Screen On")
                  }
                  
                  // Haptic feedback
                  Toggle(isOn: $userDefaultsManager.hapticFeedback) {
                     Text("Haptic Feedback")
                  }
                  
                  // Autocorrect
//                  Toggle(isOn: $userDefaultsManager.disableAutoCorrect) {
//                     Text("Disable Autocorrect")
//                  }
                  
               }
               
               // ===ISHOP===
               Section(header: Text("ISHOP")) {
                  
//                  // Review
//                  // UNCOMMENT IN FIRST POST-RELEASE UPDATE
//                  //                  if UserDefaults.standard.integer(forKey: "syncNumTimesUsed") > 10 {
//                  Button(action: {
////                     UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/id1518384911#?platform=iphone")!)
//                  }) {
//                     Text("Review on App Store")
//                        .foregroundColor(.black)
//                  }
//                  }
                  
                  
                  
                  // Introduction
                  Button(action: {
                     self.onboardingShownFromSettings.toggle()
                  }) {
                     Text("Show Introduction")
                        .foregroundColor(.black)
                  }
                  .sheet(isPresented: $onboardingShownFromSettings) {
                     OnboardingViewSettings(onboardingShownFromSettings: self.$onboardingShownFromSettings)
                  }
                  
                  
                  // Contact
                  Button(action: {
                     MFMailComposeViewController.canSendMail() ? self.isShowingMailView.toggle() : self.alertNoMail.toggle()
                  }) {
                     HStack {
                        Text("Contact")
                           .foregroundColor(.black)
                        Image(systemName: "envelope")
                           .foregroundColor(.gray)
                     }
                  }
                  .sheet(isPresented: $isShowingMailView) {
                     MailView(result: self.$result)
                  }
                  .alert(isPresented: self.$alertNoMail) {
                     Alert(title: Text("Oops! 😵"), message: Text("Can't send emails on this device."))
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
                        for list in self.lists {
                           ItemList(listFromHomePage: list, startUpPassedIn: self.startUp).sortItemPositionsAlphabetically()
                           print("Change item order")
                        }
                     }
                     if self.sortListsBy == "Manual" && UserDefaults.standard.string(forKey: "syncSortListsBy") == "Alphabetical" {
                        sortListPositionsAlphabetically()
                     }
                     UserDefaults.standard.set(self.sortItemsBy, forKey: "syncSortItemsBy")
                     UserDefaults.standard.set(self.sortListsBy, forKey: "syncSortListsBy")
                     UserDefaults.standard.set(self.userDefaultsManager.hapticFeedback, forKey: "syncHapticFeedback")
                     
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
