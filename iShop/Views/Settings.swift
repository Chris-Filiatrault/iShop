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
   @State var theme: String = UserDefaults.standard.string(forKey: "syncTheme") ?? "System"
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
                  }
                  
                  // Item Order
                  NavigationLink(destination: ChooseItemOrder(sortItemsBy: $sortItemsBy)) {
                     HStack {
                        Text("Item Order")
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
               
               // ===GENERAL===
               Section(header: Text("GENERAL"),
                       footer: appVersion == "" ?
                        Text("") :
                        Text("Version \(appVersion ?? "")")
               ) {

                  
                  // Keep Screen On
                  if !globalVariables.userIsOnMac {
                     // Keep screen on
                     Toggle(isOn: $userDefaultsManager.keepScreenOn) {
                        Text("Keep Screen On")
                     }
                  }
                
                
                // Contact
                
                //Mac
                if globalVariables.userIsOnMac {
                   Link("Contact", destination: URL(string: "https://chrisfiliatrault.com/contact/")!)
                      .foregroundColor(Color("blackWhiteFont"))
                }
                
                // iPad & iOS
                else {
                   Button(action: {
                      MFMailComposeViewController.canSendMail() ? self.isShowingMailView.toggle() : self.alertNoMail.toggle()
                   }) {
                      HStack {
                         Text("Contact")
                            .foregroundColor(Color("blackWhiteFont"))
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
                
               
            }
            .font(.headline)
            .padding(.top, 15)
            
         }
         .navigationBarColor(backgroundColor: .clear, fontColor: .gray)
         .background(Color("listBackground"))
         
         // === Nav bar ===
         .navigationBarTitle("Settings", displayMode: .inline)
         .navigationBarItems(trailing:
                              
                              // Save button
                              Button(action: {
                                 self.showSettingsBinding.toggle()
                                 
                                 // If going from alphabetically ordered items to manually ordered, update indices (so the items don't move)
                                 if self.sortItemsBy == "Manual" && UserDefaults.standard.string(forKey: "syncSortItemsBy") == "Alphabetical" {
                                    for list in self.lists {
                                       sortItemPositionsAlphabetically(thisList: list)
                                    }
                                 }
                                 
                                 // If going from alphabetically ordered lists to manually ordered, update indices (so the lists don't move)
                                 if self.sortListsBy == "Manual" && UserDefaults.standard.string(forKey: "syncSortListsBy") == "Alphabetical" {
                                    sortListPositionsAlphabetically()
                                 }
                                 
                                 // Update user defaults
                                 UserDefaults.standard.set(self.sortItemsBy, forKey: "syncSortItemsBy")
                                 UserDefaults.standard.set(self.sortListsBy, forKey: "syncSortListsBy")
                                 
                                 // Update theme
                                 UserDefaults.standard.set(self.theme, forKey: "syncTheme")
                                 
                              }) {
                                 Text("Save")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 5))
                                 
                              })
         
         

         
      } // End of VStack
      .environment(\.horizontalSizeClass, .compact)
   }
}




//               // ===ISHOP===
//               Section(header: Text("ISHOP"),
//                       footer: appVersion == "" ?
//                        Text("") :
//                        Text("Version \(appVersion ?? "")")
//
//               ) {
   
   // Introduction
//                  if !globalVariables.userIsOnMac {
//                     Button(action: {
//                        self.onboardingShownFromSettings.toggle()
//                     }) {
//                        Text("Show Introduction")
//                           .foregroundColor(Color("blackWhiteFont"))
//                     }
//                     .sheet(isPresented: $onboardingShownFromSettings) {
//                         OnboardingViewHome(onboardingShown: $onboardingShown, navBarColor: $navBarColor, navBarFont: $navBarFont)
//                     }
//                  }





//                  NavigationLink(destination: ChooseTheme(theme: $theme)) {
//                     HStack {
//                        Text("Theme")
//                        Spacer()
//                        Text("\(theme)")
//                           .foregroundColor(.gray)
//                           .font(.headline)
//                     }
//                  }
