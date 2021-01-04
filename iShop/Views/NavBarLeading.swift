//
//  NavBarLeading.swift
//  iShop
//
//  Created by Chris Filiatrault on 17/8/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

struct NavBarLeading: View {
   
   var presentationMode: Binding<PresentationMode>
   var thisList: ListOfItems
   var startUp: StartUp
   @Binding var showListOptions: Bool
   @Binding var showRenameList: Bool
   
    var body: some View {
        HStack {
           // Custom back button
           // Implemented to allow the more options ellipsis to go next to the back button when using iPad
           Button(action : {
              self.presentationMode.wrappedValue.dismiss()
           }) {
            
            
              HStack {
                 Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .font(.headline)
                 
                 Text("Lists")
              }
              .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 15))
              .foregroundColor(Color("navBarFont"))
            
           }
           
           // More options ellipsis for iPad (the action sheet doesn't work as a trailing button on iPad)
           if UIDevice.current.userInterfaceIdiom == .pad {
              ListActionSheet(showListOptions: self.$showListOptions, showRenameList: self.$showRenameList, thisList: self.thisList, startUp: self.startUp, presentationMode: self.presentationMode)
                 .padding()
           }
        }
    }
}
