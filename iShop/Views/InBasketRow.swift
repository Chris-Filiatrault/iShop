////
////  InBasketRow.swift
////  iShop
////
////  Created by Chris Filiatrault on 26/7/20.
////  Copyright © 2020 Chris Filiatrault. All rights reserved.
////
//
//import SwiftUI
//
//struct InBasketRow: View {
//      
//   @EnvironmentObject var globalVariables: GlobalVariableClass
//   @Environment(\.managedObjectContext) var context
//   
//   var thisList: ListOfItems
//   var thisItem: Item
//   @State var showItemDetails: Bool = false
//   @State var markedOff: Bool
//   
//   var body: some View {
//      
//      HStack {
//         
//         Button(action: {
//               markOffItemInList(thisItem: self.thisItem, thisList: self.thisList)
//            }) {
//            
//            ZStack {
//               Rectangle().hidden()
//               HStack {
//                  Image(systemName: "checkmark.circle.fill")
//                     .imageScale(.large)
//                     .foregroundColor(Color("navBarFont"))
//                  
//                     Text(thisItem.quantity > 1 ?
//                        "\(self.thisItem.quantity) x \(thisItem.wrappedName)" :
//                        "\(thisItem.wrappedName)")
//                        .strikethrough(color: .white)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.leading)
//                  
//                Spacer()
//                  
//                  Button(action: {
//                     self.showItemDetails.toggle()
//                  }) {
//                     Image(systemName: "square.and.pencil")
//                        .imageScale(.large)
//                        .foregroundColor(.white)
//                        .padding(7)
//                  }
//                  .sheet(isPresented: self.$showItemDetails) {
//                     ItemDetails(thisItem: self.thisItem,
//                                 showItemDetails: self.$showItemDetails,
//                                 itemName: self.thisItem.wrappedName,
//                                 oldItemCategory: self.thisItem.categoryOrigin!,
//                                 newItemCategory: self.thisItem.categoryOrigin!,
//                                 thisItemQuantity: self.thisItem.quantity,
//                                 oldList: self.thisItem.origin!,
//                                 newList: self.thisItem.origin!,
//                                 categoryName: self.thisItem.categoryOrigin!.wrappedName,
//                                 thisList: self.thisList)
//                        .environment(\.managedObjectContext, self.context)
//                  }
//               }
//            }
//         }
//      }
//      .listRowBackground(Color("standardDarkBlue"))
//   }
//}
//
//
//
