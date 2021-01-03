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
      HStack(alignment: .center) {
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
            .padding(.trailing, 5)
            .padding(5)
         }
      }
   }
}


struct MainBlueButton: ViewModifier {
    func body(content: Content) -> some View {
        content
         .frame(minWidth: 60)
         .font(.headline)
         .padding(10)
         .background(Color("blueButton"))
         .foregroundColor(.white)
         .cornerRadius(8)
    }
}


struct CancelButton: ViewModifier {
    func body(content: Content) -> some View {
        content
         .padding()
         .foregroundColor(Color("blueButton"))
    }
}

struct InCartButton: ViewModifier {
    func body(content: Content) -> some View {
        content
         .frame(minWidth: 50)
         .font(.subheadline)
         .padding(10)
         .background(Color(.white))
         .foregroundColor(.black)
         .cornerRadius(40)
         .padding(.horizontal)
    }
}
