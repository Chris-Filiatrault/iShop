//
//  ItemCategoryRow.swift
//  iShop
//
//  Created by Chris Filiatrault on 9/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

struct ItemRow: View {
   
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @Environment(\.managedObjectContext) var context
   
   var thisList: ListOfItems
   var thisItem: Item
   @State var showItemDetails: Bool = false
   
   var body: some View {
      
      HStack {
         
         Button(action: {
               markOffItemInList(thisItem: self.thisItem, thisList: self.thisList)
            }) {
            
            ZStack {
               Rectangle().hidden()
               
               HStack {
                  Image(systemName: thisItem.markedOff == true ? "checkmark.circle.fill" : "circle")
                     .imageScale(.large)
                     .foregroundColor(thisItem.markedOff == true ? Color("navBarFont") : .black)
                  
                     Text(thisItem.quantity > 1 ?
                        "\(self.thisItem.quantity) x \(thisItem.wrappedName)" :
                        "\(thisItem.wrappedName)")
                        .strikethrough(color: thisItem.markedOff == true ? .white : .clear)
                        .foregroundColor(thisItem.markedOff == true ? .white : .black)
                        .multilineTextAlignment(.leading)
                  
                Spacer()
                  
                  Button(action: {
                     self.showItemDetails.toggle()
                  }) {
                     Image(systemName: "square.and.pencil")
                        .imageScale(.large)
                        .foregroundColor(thisItem.markedOff == true ? .white : .black)
                        .padding(7)
                  }
                     
                  .sheet(isPresented: self.$showItemDetails) {
                     ItemDetails(thisItem: self.thisItem,
                                 showItemDetails: self.$showItemDetails,
                                 itemName: self.thisItem.wrappedName,
                                 oldItemCategory: self.thisItem.categoryOrigin!,
                                 newItemCategory: self.thisItem.categoryOrigin!,
                                 thisItemQuantity: self.thisItem.quantity,
                                 oldList: self.thisItem.origin!,
                                 newList: self.thisItem.origin!,
                                 categoryName: self.thisItem.categoryOrigin!.wrappedName,
                                 thisList: self.thisList)
                        .environment(\.managedObjectContext, self.context)
                  }
               }
            }
         }
         
         
      }
      .listRowBackground(thisItem.markedOff == true ? Color("standardDarkBlue") : Color(.white))
   }
}



