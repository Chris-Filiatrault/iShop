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
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   
   var thisList: ListOfItems
   var thisItem: Item
   @State var removeItemAlert: Bool = false
   
   var body: some View {
      
      Button(action: {
         if self.thisItem.addedToAList == true {
            removeItemFromList(thisItem: self.thisItem, listOrigin: self.thisList)
            self.globalVariables.catalogueShown = true
         }
         else if self.thisItem.addedToAList == false {
            self.thisItem.addedToAList = true
            addItemFromCatalogue(item: self.thisItem, listOrigin: self.thisList)
            incrementItemPurchaseCount(thisItem: self.thisItem)
            self.globalVariables.itemInTextfield = ""
            self.globalVariables.catalogueShown = true
         }
         
         hapticFeedback(enabled: self.userDefaultsManager.hapticFeedback)
      }) {
         HStack {
            
            Image(systemName: thisItem.addedToAList ? "plus.circle" : "plus.circle.fill")
               .imageScale(.medium)
               .foregroundColor(thisItem.addedToAList ? .clear : Color("tickedOffItemBox"))
            VStack {
               if thisItem.quantity > 1 {
                  Text("\(thisItem.quantity) x \(thisItem.wrappedName)")
                     .foregroundColor(thisItem.addedToAList ? .gray : .black)
                     .font(thisItem.addedToAList ? .subheadline : .headline)
               } else {
                  Text(thisItem.wrappedName)
                     .foregroundColor(thisItem.addedToAList ? .gray : .black)
                     .font(thisItem.addedToAList ? .subheadline : .headline)
               }
            }
//            Text("\(catalogueItem.position)")
         }
         .frame(height: 20)
         .font(.headline)
      }
   }
}

