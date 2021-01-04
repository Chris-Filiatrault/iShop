//
//  NewView.swift
//  iShop
//
//  Created by Chris Filiatrault on 3/1/21.
//  Copyright © 2021 Chris Filiatrault. All rights reserved.
//

import SwiftUI

struct NewView: View {
   var body: some View {
      
      
      List {
         Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
         Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
         Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
      }
      .navigationBarTitle("Title")
      
   }
}

struct NewView_Previews: PreviewProvider {
   static var previews: some View {
      NewView()
   }
}
