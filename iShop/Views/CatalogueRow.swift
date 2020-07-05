//
//  CatalogueRow.swift
//  iShop
//
//  Created by Chris Filiatrault on 24/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

struct CatalogueRow: View {
   
   @EnvironmentObject var globalVariables: GlobalVariableClass
   
   var thisList: ListOfItems
   var catalogueItem: Item
   @State var removeItemAlert: Bool = false
   
   var body: some View {
      Button(action: {
         
         if self.catalogueItem.addedToAList == true {
            self.removeItemAlert.toggle()
         }
         
         
         else if self.catalogueItem.addedToAList == false {
            self.catalogueItem.addedToAList = true
            //toggleCatalogueItem(item: self.catalogueItem, thisList: self.thisList)
            
            addItemFromCatalogue(item: self.catalogueItem, listOrigin: self.thisList)
            self.globalVariables.itemInTextfield = ""
            self.globalVariables.catalogueShown = true
         }
         
         
         
      }) {
         HStack {
            
            Image(systemName: catalogueItem.addedToAList ? "plus.circle" : "plus.circle.fill")
               .imageScale(.medium)
               .foregroundColor(catalogueItem.addedToAList ? .clear : Color("tickedOffItemBox"))
               
            
            VStack {
               
               if catalogueItem.quantity > 1 {
                  Text("\(catalogueItem.quantity) x \(catalogueItem.wrappedName)")
                     .foregroundColor(catalogueItem.addedToAList ? .gray : .black)
                     .font(catalogueItem.addedToAList ? .subheadline : .headline)
               } else {
                  Text(catalogueItem.wrappedName)
                     .foregroundColor(catalogueItem.addedToAList ? .gray : .black)
                     .font(catalogueItem.addedToAList ? .subheadline : .headline)
               }
            }
            
         }
            
         .alert(isPresented: $removeItemAlert) {
            Alert(title: Text("Remove \n\"\(catalogueItem.wrappedName)\" from \"\(thisList.wrappedName)\"?"),
                  primaryButton: .cancel(Text("Cancel")){
                     print("Cancel item pressed")
               }, secondaryButton:
               .default(Text("Remove")) {
                  
                  self.catalogueItem.addedToAList = false
                  self.catalogueItem.quantity = 1
                  
                  if self.catalogueItem.markedOff == true {
                     self.catalogueItem.markedOff = false
                  }
                  
                  removeItemFromWithinCatalogue(item: self.catalogueItem, thisList: self.thisList)
                  self.globalVariables.itemInTextfield = ""
                  self.globalVariables.catalogueShown = true
               }
            )
         }
         .frame(height: 20)
         .font(.headline)
      }
   }
}

