//
//  AddList.swift
//  iShop
//
//  Created by Chris Filiatrault on 11/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//


import SwiftUI

struct AddList: View {
   
   @State var newList: String = ""
   @State var duplicateListAlert = false
   @Binding var showingAddListBinding: Bool
   
   var body: some View {
      
      NavigationView {
         VStack {
            
            // ===Enter item textfield===
            TextField("Enter list name", text: $newList, onCommit: {
                        if self.newList != "" && listNameIsUnique(name: self.newList) {
                           addList(listName: self.newList)
                           self.showingAddListBinding = false
                           self.newList = ""
                        }
                        else if !listNameIsUnique(name: self.newList) {
                           self.duplicateListAlert = true
                        }
                        else if self.newList == "" {
                           self.showingAddListBinding = false
                        }
            })
               .textFieldStyle(RoundedBorderTextFieldStyle())
               .padding(5)
               .cornerRadius(5)
               .padding(.bottom, 20)
               .alert(isPresented: $duplicateListAlert) {
                  Alert(title: Text("Alert"), message: Text("List names must be unique\nPlease choose another name"), dismissButton: .default(Text("OK")))
            }
            
            
            // ===Buttons===
            HStack(alignment: .center) {
               
               // Cancel button
               Button(action: {self.showingAddListBinding = false}) {
                  Text("Cancel")
                     .bold()
                     .cornerRadius(20)
                     .font(.subheadline)
                     .foregroundColor(.black)
                     .frame(minWidth: 50)
               }.contentShape(Rectangle())
               
               // Add button
               Button(action: {
                  if self.newList != "" && listNameIsUnique(name: self.newList) {
                     addList(listName: self.newList)
                     self.showingAddListBinding = false
                     self.newList = ""
                  }
                  else if !listNameIsUnique(name: self.newList) { self.duplicateListAlert = true
                  }
               }) {
                  Text("Add")
                     .bold()
                     .frame(minWidth: 50)
                     .font(.subheadline)
                     .padding(10)
                     .background(Color("blueButton"))
                     .foregroundColor(.white)
                     .cornerRadius(10)
                     .transition(.scale)
                     .edgesIgnoringSafeArea(.horizontal)
               }
               .contentShape(Rectangle())
               .padding(.leading, 20)
               
            }
            
            Spacer()
         }
         .padding()
         .modifier(AdaptsToSoftwareKeyboard())
         
         .navigationBarTitle("Add List", displayMode: .large)
         
      } // End of VStack
      .environment(\.horizontalSizeClass, .compact)
   }
}
