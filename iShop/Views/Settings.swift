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
      NSSortDescriptor(key: "name", ascending: true, selector:  #selector(NSString.localizedCaseInsensitiveCompare(_:)))
   ], predicate: NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D"))
   var lists: FetchedResults<ListOfItems>
   
   let sortOptions: [String] = ["Alphabetical", "Manual"]
//   let hapticFeedbackOptions: [String] = ["On", "Off"]
   var startUp: StartUp
   
   @Environment(\.presentationMode) var mode: Binding<PresentationMode>
   @State var result: Result<MFMailComposeResult, Error>? = nil
   @State var isShowingMailView = false
   @State var alertNoMail = false
   @State var disableAutocorrect: Bool = false
   @State var sortItemsBy: String = UserDefaults.standard.string(forKey: "syncSortItemsBy") ?? "Manual"
   @State var sortListsBy: String = UserDefaults.standard.string(forKey: "syncSortListsBy") ?? "Manual"
   @State var navBarFont: UIColor = UIColor.white
   @State var navBarColor: UIColor = UIColor(red: 0/255, green: 10/255, blue: 30/255, alpha: 1)
   @State var onboardingShownFromSettings: Bool = false
   let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
   
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
                        .foregroundColor(.black)
                  }
                  
                  // Item Order
                  NavigationLink(destination: ChooseItemOrder(sortItemsBy: $sortItemsBy)
                  ) {
                        HStack {
                           Text("Item Order")
                              .foregroundColor(.black)
                           Spacer()
                           Text(userDefaultsManager.useCategories == true ?
                              "Alphabetical" :
                              "\(sortItemsBy)"
                           )
                           .foregroundColor(.gray)
                           .font(.headline)
                  }
               }
                  
               
               }
               .listRowBackground(Color(.white))
               
               // ===GENERAL===
               if !globalVariables.userIsOnMac {
               Section(header: Text("GENERAL")) {
                  
                  // Keep screen on
                  Toggle(isOn: $userDefaultsManager.keepScreenOn) {
                     Text("Keep Screen On")
                        .foregroundColor(.black)
                  }
               }
               .listRowBackground(Color(.white))
               }
               
               // ===ISHOP===
               Section(header: Text("ISHOP"),
                       footer: appVersion == "" ?
                  Text("") :
                  Text("Version \(appVersion ?? "")")
                  
               ) {
                                 

                  // Introduction
                  if !globalVariables.userIsOnMac {
                  Button(action: {
                     self.onboardingShownFromSettings.toggle()
                  }) {
                     Text("Show Introduction")
                        .foregroundColor(.black)
                  }
                  .sheet(isPresented: $onboardingShownFromSettings) {
                     OnboardingViewSettings(onboardingShownFromSettings: self.$onboardingShownFromSettings)
                  }
                  }
                  
                  // Contact

                  //Mac
                  if globalVariables.userIsOnMac {
                     Link("Contact", destination: URL(string: "https://chrisfiliatrault.com/contact/")!)
                        .foregroundColor(.black)
                        .listRowBackground(Color(.white))
                  } else
                  // iPad & iOS
                  {
                     Button(action: {
                        MFMailComposeViewController.canSendMail() ? self.isShowingMailView.toggle() : self.alertNoMail.toggle()
                     }) {
                        HStack {
                           Text("Contact")
                           Image(systemName: "envelope")
                        }
                        .foregroundColor(.black)

                     }
                     .sheet(isPresented: $isShowingMailView) {
                        MailView(result: self.$result)
                        
                     }
                     .alert(isPresented: self.$alertNoMail) {
                        Alert(title: Text("Oops! 😵"), message: Text("Can't send emails on this device."))
                     }
                     .listRowBackground(Color(.white))
                  }
               }
               
               
               
            }
            .font(.headline)
            .padding(.top, 15)
            
               
            
               
         }
         .navigationBarColor(backgroundColor: .clear, fontColor: .black)
         .background(Color("listBackground").edgesIgnoringSafeArea(.all))
         
         // === Nav bar ===
         .navigationBarTitle("Settings", displayMode: .inline)
         .navigationBarItems(trailing:
            
            // Done button
            Button(action: {
               self.showSettingsBinding.toggle()
               
               // If going from alphabetically ordered items to manually ordered, update indices (so the items don't move)
               if self.sortItemsBy == "Manual" && UserDefaults.standard.string(forKey: "syncSortItemsBy") == "Alphabetical" {
                  for list in self.lists {
                     sortItemPositionsAlphabetically(thisList: list)
                     print("Change item order")
                  }
               }
               
               // If going from alphabetically ordered lists to manually ordered, update indices (so the lists don't move)
               if self.sortListsBy == "Manual" && UserDefaults.standard.string(forKey: "syncSortListsBy") == "Alphabetical" {
                  sortListPositionsAlphabetically()
               }
               
               // Update user defaults
               UserDefaults.standard.set(self.sortItemsBy, forKey: "syncSortItemsBy")
               UserDefaults.standard.set(self.sortListsBy, forKey: "syncSortListsBy")
               
            }) {
               Text("Done")
                  .font(.headline)
                  .foregroundColor(.blue)
                  .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 5))
               
         })
         
      } // End of VStack
         .environment(\.horizontalSizeClass, .compact)
   }
}
