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
            removeItemFromList(item: self.catalogueItem)
            self.globalVariables.catalogueShown = true
         }
            
            
         else if self.catalogueItem.addedToAList == false {
            self.catalogueItem.addedToAList = true
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
         .frame(height: 20)
         .font(.headline)
      }
   }
}

