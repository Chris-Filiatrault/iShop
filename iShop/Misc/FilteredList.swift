//
//  FilteredList.swift
//  iShop
//
//  Created by Chris Filiatrault on 27/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//
//
//import SwiftUI
//
//struct FilteredList: View {
//
//   var fetchRequest: FetchRequest<Item>
//
//   init(filter: String) {
//       fetchRequest = FetchRequest<Item>(entity: Item.entity(), sortDescriptors: [], predicate: NSPredicate(format: "originName CONTAINS %@", filter))
//   }
//
//    var body: some View {
//        List(fetchRequest.wrappedValue, id: \.self) { item in
//            Text("\(item.name ?? "") \(item.originName ?? "")")
//        }
//    }
//}


//
//import SwiftUI
//
//struct FilteredList: View {
//   
//   
//   var fetchRequest: FetchRequest<Item>
//   
//   init(filter: String) {
//      fetchRequest = FetchRequest<Item>(entity: Item.entity(), sortDescriptors: [], predicate: NSPredicate(format: "name CONTAINS %@", filter))
//   }
//   
//   var body: some View {
//
//      List {
//         ForEach(fetchRequest.wrappedValue, id: \.self) { item in
//            Text("\(item.name ?? "Unknown item")")
//         }
//      }
//      
//   }
//}
