//
//  ItemCategoryRow.swift
//  iShop
//
//  Created by Chris Filiatrault on 9/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

struct ItemRow: View {
   
   
   @Environment(\.managedObjectContext) var context
   
   var thisList: ListOfItems
   var thisItem: Item
   @State var itemInListMarkedOff: Bool
   @State var thisItemQuantity: Int32
   @State var showItemDetails: Bool = false
   
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
                        .multilineTextAlignment(.leading)
                  }
                Spacer()
                  
                  Button(action: {
                     self.showItemDetails.toggle()
                  }) {
                     Image(systemName: "square.and.pencil")
                        .imageScale(.large)
                        .foregroundColor(Color("blackWhiteFont"))
                  }
                  .sheet(isPresented: $showItemDetails) {
                     ItemDetails(thisItem: self.thisItem, showItemDetails: self.$showItemDetails, itemName: self.thisItem.wrappedName, oldItemCategory: self.thisItem.categoryOrigin!, newItemCategory: self.thisItem.categoryOrigin!)
                        .environment(\.managedObjectContext, self.context)
                  }
               }
            }
         }
         
         
      }
      
   }
   
}





//         HStack {
//
//
//            Button(action: {
//               incrementItemQuantity(thisItem: self.thisItem, thisList: self.thisList)
//               self.thisItemQuantity += 1
//            }) {
//               Image(systemName: "plus")
//                  .foregroundColor(.black)
//                  .imageScale(.large)
//            }
//
//            Button(action: {
//               if self.thisItemQuantity > 1 {
//               self.thisItemQuantity -= 1
//               decrementItemQuantity(thisItem: self.thisItem, thisList: self.thisList)
//               }
//            }) {
//               Image(systemName: "minus")
//                  .foregroundColor(.black)
//                  .imageScale(.large)
//            }
//         }
