//
//  ChooseItemOrder.swift
//  iShop
//
//  Created by Chris Filiatrault on 26/9/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//


import SwiftUI
import CoreData

struct ChooseItemOrder: View {
   
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @Environment(\.presentationMode) var presentationMode
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   
   @Binding var sortItemsBy: String
   let sortOptions: [String] = ["Alphabetical", "Manual"]
   
   var body: some View {
      
      List {
         

         if userDefaultsManager.useCategories == false {
            ForEach(self.sortOptions, id: \.self) { option in
               Button(action: {
                  self.sortItemsBy = option
                  self.presentationMode.wrappedValue.dismiss()
               }) {
                  HStack {
                     if option == self.sortItemsBy {
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
                           .foregroundColor(.black)
                     }
                  }
               }
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
            .padding(.vertical, 5)
         }


         if userDefaultsManager.useCategories == true {

            Button(action: {
               self.presentationMode.wrappedValue.dismiss()
            }) {
               HStack {
                  Text("Alphabetical")
                     .font(.headline)
                  Spacer()
                  Image(systemName: "checkmark")
                     .imageScale(.medium)
               }
               .foregroundColor(.blue)
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
         
      }
      
               .listStyle(GroupedListStyle())
                  .navigationBarTitle(Text("Item Order"), displayMode: .inline)
                  .navigationBarColor(backgroundColor: .clear, fontColor: UIColor.black)
      
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

