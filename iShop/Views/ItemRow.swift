//
//  ItemCategoryRow.swift
//  iShop
//
//  Created by Chris Filiatrault on 9/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

struct ItemRow: View {
   
   var thisList: ListOfItems
   var thisItem: Item
   @State var itemInListMarkedOff: Bool
   @State var thisItemQuantity: Int32
   
   var body: some View {
      
      HStack {
         
         Button(action: {
            self.itemInListMarkedOff.toggle()
            markOffItemInList(thisItem: self.thisItem, thisList: self.thisList)
         }) {
            
            ZStack {
               Rectangle().hidden()
               
               HStack {
                  Image(systemName: itemInListMarkedOff ? "checkmark.circle" : "circle")
                     .imageScale(.large)
                     .foregroundColor(itemInListMarkedOff ? .gray : .black)
                  
                  if thisItem.quantity > 1 {
                     Text("\(self.thisItem.quantity) x \(thisItem.wrappedName)")
                        .foregroundColor(thisItem.markedOff ? .gray : .black)
                        .font(thisItem.markedOff ? .subheadline : .headline)
                        .multilineTextAlignment(.leading)
                  }
                  else {
                     Text("\(thisItem.wrappedName)")
                        .strikethrough(color: itemInListMarkedOff ? .gray : .clear)
                        .foregroundColor(itemInListMarkedOff ? .gray : .black)
                        .font(itemInListMarkedOff ? .subheadline : .headline)
                        .multilineTextAlignment(.leading)
                  }
                Spacer()
               }
            }
         }
         
         HStack {
            
            
            Button(action: {
               incrementItemQuantity(thisItem: self.thisItem, thisList: self.thisList)
               self.thisItemQuantity += 1
            }) {
               Image(systemName: "plus")
                  .foregroundColor(.black)
                  .imageScale(.large)
            }
            
            Button(action: {
               if self.thisItemQuantity > 1 {
               self.thisItemQuantity -= 1
               decrementItemQuantity(thisItem: self.thisItem, thisList: self.thisList)
               }
            }) {
               Image(systemName: "minus")
                  .foregroundColor(.black)
                  .imageScale(.large)
            }
         }
         
      }
      
   }
   
}


// toggle function, for ticking off items
//   func toggle(){
//      markedOff = !markedOff
//
//   }


