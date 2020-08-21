//
//  ViewModifiers.swift
//  iShop
//
//  Created by Chris Filiatrault on 17/8/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI



// For adding the cross circle next to the textfield
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


struct MainBlueButton: ViewModifier {
    func body(content: Content) -> some View {
        content
         .padding(.horizontal, 15)
         .frame(minWidth: 50)
         .padding(10)
         .background(LinearGradient(gradient: Gradient(colors: [Color("darkBlue"), Color("lightBlue")]), startPoint: .leading, endPoint: .trailing))
         .foregroundColor(.white)
         .cornerRadius(40)

    }
}
