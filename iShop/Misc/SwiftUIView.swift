//
//  SwiftUIView.swift
//  iShop
//
//  Created by Chris Filiatrault on 27/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//
//
//import SwiftUI
//
//
//
//
//struct SwiftUIView: View {
//   
//   @Environment(\.managedObjectContext) var moc
//   @State private var lastNameFilter = "A"
//   
//   var body: some View {
//      VStack {
//         
//         FilteredList(filter: lastNameFilter)
//         
//         Button("Add Examples") {
//            let taylor = Item(context: self.moc)
//            taylor.name = "Taylor"
//            taylor.originName = "Swift"
//            
//            
//            let letter = Item(context: self.moc)
//            letter.name = " "
//            letter.originName = "SA"
//            
//            let ed = Item(context: self.moc)
//            ed.name = "Ed"
//            ed.originName = "Sheeran"
//            
//            let adele = Item(context: self.moc)
//            adele.name = "Adele"
//            adele.originName = "Adkins"
//            
//            try? self.moc.save()
//            print("Added examples")
//         }
//         
//         Button("Show A") {
//            self.lastNameFilter = "A"
//         }
//         
//         Button("Show S") {
//            self.lastNameFilter = "S"
//         }
//      }
//   }
//}
