//
//  ViewModifiers.swift
//  iShop
//
//  Created by Chris Filiatrault on 17/8/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI



// For adding the cross circle next to the textfield
// Doing it this way just avoids some extra code in ItemList
struct ClearButton: ViewModifier {

   @EnvironmentObject var globalVariables: GlobalVariableClass

   public func body(content: Content) -> some View {
      HStack() {
         content
         if !globalVariables.itemInTextfield.isEmpty {
            Spacer()
            Button(action: {
               self.globalVariables.itemInTextfield = ""
            }) {
               Image(systemName: "multiply.circle")
                  .imageScale(.large)
                  .foregroundColor(Color(.gray))
                  .padding(5)
            }
            .padding(.trailing, 10)
         }
      }
   }
}
