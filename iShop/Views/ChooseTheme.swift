//
//  ChooseTheme.swift
//  iShop
//
//  Created by Chris Filiatrault on 8/1/21.
//  Copyright © 2021 Chris Filiatrault. All rights reserved.
//

import SwiftUI

struct ChooseTheme: View {
   
   
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @Environment(\.presentationMode) var presentationMode
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   
   @Binding var theme: String
   let themeOptions: [String] = ["Light", "Dark", "System"]
   
   var body: some View {
      
      
      List {
         ForEach(self.themeOptions, id: \.self) { option in
            Button(action: {
               self.theme = option
               self.presentationMode.wrappedValue.dismiss()
               
               
//               if option == "Light" {
//                  UserDefaults.standard.set("Light", forKey: "syncTheme")
//                  SceneDelegate().window?.overrideUserInterfaceStyle = .light
//               }
//               
//               else if option == "Dark" {
//                  
////                  UserDefaults.standard.set("Dark", forKey: "useDarkMode")
////                  SceneDelegate().window?.overrideUserInterfaceStyle = .dark
//               }
//
//               else if option == "System" {
////
////                  UserDefaults.standard.set("System", forKey: "useDarkMode")
////                  SceneDelegate().window?.overrideUserInterfaceStyle = .unspecified
//               }
            }) {
               HStack {
                  if option == self.theme {
                     HStack {
                        Text(option)
                           .font(.headline)
                        Spacer()
                        Image(systemName: "checkmark")
                           .imageScale(.medium)
                     }
                     .foregroundColor(.blue)
                  } else {
                     Text(option)
                        .font(.headline)
                  }
               }
            }
         }
      }
      .listStyle(GroupedListStyle())
      .navigationBarTitle(Text("Choose Theme"), displayMode: .inline)
      .navigationBarColor(backgroundColor: .clear, fontColor: UIColor.gray)
      
      .navigationBarItems(
         leading:
            Button(action : {
               self.presentationMode.wrappedValue.dismiss()
            }) {
               HStack {
                  Image(systemName: "chevron.left")
                     .imageScale(.large)
                     .font(.headline)
                  
                  Text("Back")
               }
               .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 15))
               .foregroundColor(.blue)
            })
      .navigationBarBackButtonHidden(true)
   }
}


